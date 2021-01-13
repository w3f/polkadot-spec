use crate::builder::{Builder, FunctionName, ModuleInfo, ModuleName};
use crate::executor::ClientInMem;
use crate::Result;
use serde::de::DeserializeOwned;
use serde::Serialize;
use std::cell::Cell;
use std::cmp::PartialEq;
use std::collections::HashMap;
use std::hash::Hash;
use std::mem::{drop, take};

pub trait Mapper: Sized + Eq + PartialEq + Hash {
    fn map(proc: &mut Processor<Self>, task: Task<Self>, client: &ClientInMem) -> Result<()>;
}

pub struct Processor<TaskType: Eq + Hash> {
    global_var_pool: VarPool,
    tasks: Vec<Task<TaskType>>,
}

#[derive(Debug, Clone, Serialize)]
pub struct TaskOutcome<Data> {
    #[serde(skip_serializing_if = "Option::is_none")]
    pub task_name: Option<String>,
    pub module: ModuleName,
    pub function: FunctionName,
    pub data: Data,
}

impl<TaskType: Eq + PartialEq + Hash + Clone + DeserializeOwned + Mapper> Processor<TaskType> {
    pub fn new(input: &str) -> Result<Self> {
        let (global_var_pool, tasks) = global_parser::<TaskType>(input)?;

        Ok(Processor {
            global_var_pool: global_var_pool,
            tasks: tasks,
        })
    }
    pub fn process(mut self) -> Result<()> {
        let client = ClientInMem::new()?;
        for task in take(&mut self.tasks) {
            TaskType::map(&mut self, task, &client)?;
        }

        Ok(())
    }
    pub fn parse_task<Command>(
        &mut self,
        mut task: Task<TaskType>,
        client: &ClientInMem,
    ) -> Result<()>
    where
        Command: Builder + From<<Command as Builder>::Input>,
        <Command as Builder>::Input: ModuleInfo,
        <Command as Builder>::Output: Clone,
    {
        let (flattened, register) = task_parser::<TaskType, <Command as Builder>::Input>(
            &self.global_var_pool,
            &mut task.properties,
        )?;

        let mut results = vec![];

        let mut module_name = None;
        let mut function_name = None;
        for task in flattened {
            module_name = Some(task.module_name());
            function_name = Some(task.function_name());

            results.push(Command::from(task).run(client)?);
        }

        if let Some(var_name) = register {
            self.global_var_pool
                .insert_named(var_name, serde_yaml::to_value(results.clone())?);
        }

        println!(
            "{}",
            serde_json::to_string_pretty(&TaskOutcome {
                task_name: Some(task.name().to_string()),
                module: module_name.unwrap(),
                function: function_name.unwrap(),
                data: results,
            })?
        );

        Ok(())
    }
}

// The `global_parser` parses tasks and global variables and inserts those
// variables into the global variable pool. It does however not "expand" the
// tasks (such as recurring tasks which have loops, or having to insert
// variables). That job is done by the `task_parser`.
fn global_parser<TaskType: Eq + PartialEq + Hash + DeserializeOwned>(
    input: &str,
) -> Result<(VarPool, Vec<Task<TaskType>>)> {
    let yaml_blocks: Vec<YamlItem<TaskType>> = serde_yaml::from_str(input)?;

    let mut tasks = vec![];
    let mut global_vars = None;
    let mut global_var_pool = VarPool::new();

    // A "local" variable pool is not relevant in this context.
    let converter = VariableProcessor::new(&global_var_pool, &global_var_pool, 0);

    // Process global variables.
    let mut first_vars = false;
    for item in yaml_blocks {
        match item {
            YamlItem::Vars(mut vars) => {
                if !first_vars {
                    for (_, var) in &mut vars.vars.0 {
                        converter.process_yaml_value(var)?;
                    }

                    global_vars = Some(vars.vars);
                    first_vars = true;
                } else {
                    return Err(failure::err_msg(
                        "Only one global variable entry block allowed",
                    ));
                }
            }
            YamlItem::Task(task) => tasks.push(task),
        }
    }

    // Drop converter so variables can be inserted into pool.
    drop(converter);

    // Insert global variables into the global variable pool.
    if let Some(vars) = global_vars {
        global_var_pool.insert(vars);
    }

    Ok((global_var_pool, tasks))
}

// The `task_parser` "expands" each tasks, such as creating a new tasks for each
// iteration of a loop or searching through the global/local variable pool and
// inserting those values.
fn task_parser<
    TaskType: Eq + PartialEq + Hash + Clone + DeserializeOwned,
    Expanded: DeserializeOwned,
>(
    global_var_pool: &VarPool,
    properties: &HashMap<KeyType<TaskType>, serde_yaml::Value>,
) -> Result<(Vec<Expanded>, Option<VariableName>)> {
    let mut register = None;

    let mut local_var_pool = VarPool::new();
    let converter = VariableProcessor::new(global_var_pool, &local_var_pool, 0);

    let mut vars = None;
    let mut loop_vars = None;

    // First, just collect the necessary information in order to be able to
    // expand the tasks. This includes variables, loops and any special
    // keywords.
    for (key, val) in properties {
        match key {
            KeyType::TaskType(_) => {}
            KeyType::Keyword(keyword) => match keyword {
                Keyword::Register => {
                    register = Some(serde_yaml::from_value::<VariableName>(val.clone())?)
                }
                Keyword::Loop => {
                    // Ensure only one `loop:` entry is present per task.
                    if loop_vars.is_none() {
                        let mut parsed = serde_yaml::from_value::<LoopType>(val.clone())?;

                        for v in &mut parsed.0 {
                            converter.process_yaml_value(v)?;
                        }

                        loop_vars = Some(parsed);
                    } else {
                        return Err(failure::err_msg("Only one loop entry per task allowed"));
                    }
                }
                Keyword::Vars => {
                    // Ensure only one `vars:` entry is present per task.
                    if vars.is_none() {
                        let mut parsed = serde_yaml::from_value::<VarType>(val.clone())?;

                        for (_, v) in &mut parsed.0 {
                            converter.process_yaml_value(v)?;
                        }

                        vars = Some(parsed);
                    } else {
                        return Err(failure::err_msg(
                            "Only one variable entry per task allowed ",
                        ));
                    }
                }
            },
        }
    }

    // Keep track of loop count
    let loop_count = loop_vars.as_ref().map(|l| l.len()).unwrap_or(1);

    // Drop converter so variables can be inserted into pool.
    drop(converter);

    // Insert variables into the pool.
    if let Some(vars) = vars {
        local_var_pool.insert(vars);
    }

    if let Some(vars) = loop_vars {
        local_var_pool.insert_loop(vars);
    }

    let mut expanded = vec![];

    // Expand all tasks, where variables and loops are all layed out.
    for index in 0..loop_count {
        let mut loop_properties = properties.clone();
        // Created an new variable processor with the new `index`.
        let converter = VariableProcessor::new(global_var_pool, &local_var_pool, index);
        converter.process_properties(&mut loop_properties)?;

        for (key, val) in loop_properties {
            match key {
                KeyType::TaskType(_) => {
                    expanded.push(serde_yaml::from_value::<Expanded>(val.clone())?);
                }
                _ => {}
            }
        }
    }

    Ok((expanded, register))
}

struct VariableProcessor<'a> {
    global_var_pool: &'a VarPool,
    local_var_pool: &'a VarPool,
    loop_index: usize,
}

impl<'a> VariableProcessor<'a> {
    fn new(global: &'a VarPool, local: &'a VarPool, index: usize) -> Self {
        VariableProcessor {
            global_var_pool: global,
            local_var_pool: local,
            loop_index: index,
        }
    }
    // Convenience function for quickly processing task properties.
    fn process_properties<TaskType: DeserializeOwned>(
        &self,
        properties: &mut HashMap<KeyType<TaskType>, serde_yaml::Value>,
    ) -> Result<()> {
        for (_, val) in properties {
            self.process_yaml_value(val)?;
        }

        Ok(())
    }
    fn process_yaml_value(&self, value: &mut serde_yaml::Value) -> Result<()> {
        if let Some(string) = value.as_str() {
            // Check whether the value is a variable. If not, then just ignore.
            if let Some(var_chain) = VariableChain::new(string)? {
                // Check the local variable pool first (local pool overwrites
                // the global pool). If nothing was found, then check to global
                // variable pool.
                let var = if let Some(var) = self.local_var_pool.get(self.loop_index, &var_chain) {
                    var
                } else if let Some(var) = self.global_var_pool.get(self.loop_index, &var_chain) {
                    var
                } else {
                    return Err(failure::err_msg(format!(
                        "Variable \"{}\" not found",
                        string
                    )));
                };

                // Overwrite the variable with the actual value.
                *value = var.clone();
                // Process the actual value; it might contain variables itself.
                self.process_yaml_value(value)?;
            }
        } else if let Some(seq) = value.as_sequence_mut() {
            for val in seq {
                self.process_yaml_value(val)?;
            }
        } else if let Some(map) = value.as_mapping_mut() {
            for (_, val) in map {
                self.process_yaml_value(val)?;
            }
        }

        Ok(())
    }
}

#[derive(Clone, Debug, Eq, PartialEq)]
struct VariableChain {
    chain: Vec<VariableType>,
    is_loop: bool,
    // Specifies the current position in the nested variable chain.
    cursor: Cell<usize>,
}

#[derive(Clone, Debug, Eq, PartialEq)]
enum VariableType {
    Name(VariableName),
    Index(usize),
}

// TODO: Variable cannot start with an index.
impl VariableChain {
    fn new(name: &str) -> Result<Option<Self>> {
        // Check if input qualifies as a variable
        let name = if name.contains("{{") && name.contains("}}") {
            name.replace("{{", "").replace("}}", "").trim().to_string()
        } else {
            return Ok(None);
        };

        // Process variable
        let mut chain = vec![];
        let mut is_loop = false;
        let parts: Vec<&str> = name.split('.').collect();

        for part in parts {
            let subparts: Vec<&str> = part.split('[').collect();

            let mut first = true;
            for sub in subparts {
                // First item is a regular name.
                if first {
                    // Handle special case of "item", which is reserved for loop iterations.
                    if sub == "item" {
                        is_loop = true;
                    }

                    chain.push(VariableType::Name(sub.into()));
                    first = false;
                    continue;
                }

                // "item" is not allowed to have indexes.
                if is_loop {
                    return Err(failure::err_msg(
                        "'item' is a reserved keyword and is not \
                    allowed how have array indexes",
                    ));
                }

                // Any other items are (array) indexes.
                chain.push(VariableType::Index(
                    sub.trim_matches(']').parse::<usize>().map_err(|_| {
                        failure::err_msg(format!(
                            "Expected a number as index in variable: {}",
                            part
                        ))
                    })?,
                ));
            }
        }

        Ok(Some(VariableChain {
            chain: chain,
            is_loop: is_loop,
            cursor: Cell::new(0),
        }))
    }
    // Fetches the current variable. This call advances the cursor.
    fn get(&self) -> Option<&VariableType> {
        let cursor = self.cursor.get();
        let val = self.chain.get(self.cursor.get());
        self.cursor.set(cursor + 1);
        val
    }
    fn reset_cursor(&self) {
        self.cursor.set(0);
    }
    fn is_loop(&self) -> bool {
        self.is_loop
    }
}

// struct VarType(HashMap<VariableName, serde_yaml::Value>);
// struct LoopType(Vec<serde_yaml::Value>);

struct VarPool {
    pool: VarType,
    loop_pool: LoopType,
}

impl VarPool {
    fn new() -> Self {
        VarPool {
            pool: Default::default(),
            loop_pool: Default::default(),
        }
    }
    // Insert variables.
    fn insert(&mut self, vars: VarType) {
        for (name, val) in vars.0 {
            self.pool.0.insert(name, val);
        }
    }
    // Insert a single key/value.
    fn insert_named(&mut self, name: VariableName, value: serde_yaml::Value) {
        self.insert(VarType([(name, value)].iter().cloned().collect()))
    }
    // Insert the variables for each loop iteration.
    fn insert_loop(&mut self, pool: LoopType) {
        self.loop_pool = pool;
    }
    fn get<'a>(&'a self, index: usize, name: &VariableChain) -> Option<&'a serde_yaml::Value> {
        // Fetching for variables is done twice. First, fetch from local pool,
        // then from global pool. Since `VariableChain::get` will advance the
        // cursor by one, it must be reset.
        name.reset_cursor();

        let value = match name.get()? {
            VariableType::Name(var) => {
                if name.is_loop() {
                    self.loop_pool.0.get(index)
                } else {
                    self.pool.0.get(var)
                }
            }
            // Should never occur, since this case is handled in the `VariableChain::new()`
            VariableType::Index(_) => {
                panic!("Variable name starts with an index: {:?}", name.chain)
            }
        }?;

        Self::search_nested(name, value)
    }
    fn search_nested<'a>(
        name: &VariableChain,
        value: &'a serde_yaml::Value,
    ) -> Option<&'a serde_yaml::Value> {
        // Check if the variable chain goes deeper.
        if let Some(var) = name.get() {
            let value = match var {
                VariableType::Name(var) => value.get(&var.0),
                VariableType::Index(index) => value.get(*index),
            }?;

            Self::search_nested(name, value)
        } else {
            // If the final variable has been reached, return the value.
            Some(value)
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(untagged)]
enum YamlItem<TaskType: Eq + PartialEq + Hash> {
    Task(Task<TaskType>),
    Vars(Vars),
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct Vars {
    vars: VarType,
}

#[derive(Debug, Clone, Default, Eq, PartialEq, Serialize, Deserialize)]
struct VarType(HashMap<VariableName, serde_yaml::Value>);

#[derive(Debug, Clone, Default, Eq, PartialEq, Serialize, Deserialize)]
struct LoopType(Vec<serde_yaml::Value>);

impl LoopType {
    fn len(&self) -> usize {
        self.0.len()
    }
}

#[derive(Debug, Clone, Eq, PartialEq, Hash, Serialize, Deserialize)]
pub struct VariableName(String);

impl From<&str> for VariableName {
    fn from(value: &str) -> Self {
        VariableName(value.to_string())
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Task<TaskType: Eq + PartialEq + Hash> {
    name: String,
    #[serde(flatten)]
    properties: HashMap<KeyType<TaskType>, serde_yaml::Value>,
}

impl<TaskType: Eq + PartialEq + Hash> Task<TaskType> {
    pub fn name(&self) -> &str {
        self.name.as_str()
    }
    pub fn task_type(&self) -> Result<&TaskType> {
        let mut task = None;

        for (key, _) in &self.properties {
            match key {
                KeyType::TaskType(task_ty) => {
                    if task.is_none() {
                        task = Some(task_ty)
                    } else {
                        return Err(failure::err_msg(
                            "Only one task type per yaml block allowed",
                        ));
                    }
                }
                _ => {}
            }
        }

        Ok(task.ok_or(failure::err_msg("No task found for yaml block"))?)
    }
}

#[derive(Debug, Clone, Eq, PartialEq, Hash, Serialize, Deserialize)]
#[serde(untagged)]
enum KeyType<TaskType> {
    TaskType(TaskType),
    Keyword(Keyword),
}

#[derive(Debug, Clone, Eq, PartialEq, Hash, Serialize, Deserialize)]
enum Keyword {
    #[serde(rename = "register")]
    Register,
    #[serde(rename = "loop")]
    Loop,
    #[serde(rename = "vars")]
    Vars,
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde::de::DeserializeOwned;

    #[derive(Debug, Clone, Eq, PartialEq, Hash, Serialize, Deserialize)]
    #[serde(rename_all = "snake_case")]
    enum TaskType {
        Person,
    }

    /// Convenience function for processing tests.
    fn parse<T: DeserializeOwned>(input: &str) -> Vec<T> {
        let (var_pool, mut tasks) = global_parser::<TaskType>(input).unwrap();
        task_parser::<TaskType, T>(&var_pool, &mut tasks[0].properties)
            .unwrap()
            .0
    }

    #[test]
    fn nested_variables_simple_names() {
        let res = VariableChain::new("var").unwrap();
        assert!(res.is_none());

        let res = VariableChain::new("{{ var }}").unwrap().unwrap();
        assert_eq!(res.chain, vec![VariableType::Name("var".into())]);

        let res = VariableChain::new("{{ var.name }}").unwrap().unwrap();
        assert_eq!(
            res.chain,
            vec![
                VariableType::Name("var".into()),
                VariableType::Name("name".into())
            ]
        );

        let res = VariableChain::new("{{ var.name.surname }}")
            .unwrap()
            .unwrap();
        assert_eq!(
            res.chain,
            vec![
                VariableType::Name("var".into()),
                VariableType::Name("name".into()),
                VariableType::Name("surname".into())
            ]
        );
    }

    #[test]
    fn nested_variables_indexes() {
        let res = VariableChain::new("{{ var.name[0] }}").unwrap().unwrap();
        assert_eq!(
            res.chain,
            vec![
                VariableType::Name("var".into()),
                VariableType::Name("name".into()),
                VariableType::Index(0)
            ]
        );

        let res = VariableChain::new("{{ var.name[0].surname }}")
            .unwrap()
            .unwrap();
        assert_eq!(
            res.chain,
            vec![
                VariableType::Name("var".into()),
                VariableType::Name("name".into()),
                VariableType::Index(0),
                VariableType::Name("surname".into()),
            ]
        );

        let res = VariableChain::new("{{ var.name[0][4] }}").unwrap().unwrap();
        assert_eq!(
            res.chain,
            vec![
                VariableType::Name("var".into()),
                VariableType::Name("name".into()),
                VariableType::Index(0),
                VariableType::Index(4)
            ]
        );

        let res = VariableChain::new("{{ var.name[0][4].categories.parts[1][1] }}")
            .unwrap()
            .unwrap();
        assert_eq!(
            res.chain,
            vec![
                VariableType::Name("var".into()),
                VariableType::Name("name".into()),
                VariableType::Index(0),
                VariableType::Index(4),
                VariableType::Name("categories".into()),
                VariableType::Name("parts".into()),
                VariableType::Index(1),
                VariableType::Index(1)
            ]
        );
    }

    #[test]
    fn converter_simple() {
        #[derive(Debug, Eq, PartialEq, Deserialize)]
        struct Person {
            name: String,
            age: usize,
            categories: Vec<String>,
        }

        let yaml = r#"
            - name: Some person
              person:
                name: alice
                age: 33
                categories:
                  - business
                  - finance
        "#;

        let res = parse::<Person>(yaml);
        assert_eq!(res.len(), 1);
        assert_eq!(
            res[0],
            Person {
                name: "alice".to_string().to_string(),
                age: 33,
                categories: vec!["business".to_string(), "finance".to_string()]
            }
        );
    }

    #[test]
    fn converter_local_vars() {
        #[derive(Debug, Eq, PartialEq, Deserialize)]
        struct Person {
            name: String,
            age: usize,
            categories: Vec<String>,
        }

        let yaml = r#"
            - name: Some person
              person:
                name: alice
                age: "{{ age }}"
                categories:
                  - business
                  - finance
              vars:
                age: 33
        "#;

        let res = parse::<Person>(yaml);
        assert_eq!(res.len(), 1);
        assert_eq!(
            res[0],
            Person {
                name: "alice".to_string(),
                age: 33,
                categories: vec!["business".to_string(), "finance".to_string()]
            }
        );
    }

    #[test]
    fn converter_local_vars_map_abbreviated_nested() {
        #[derive(Debug, Eq, PartialEq, Deserialize)]
        struct Person {
            name: String,
            age: usize,
            categories: Vec<String>,
            employer: String,
        }

        let yaml = r#"
            - name: Some person
              person:
                name: alice
                age: "{{ info.age }}"
                categories: "{{ info.categories }}"
                employer: "{{ info.job.employer}}"
              vars:
                info: {
                  age: 33,
                  categories: ["business", "finance"],
                  job: {
                    position: "accountant",
                    employer: "CorpA"
                  }
                }
        "#;

        let res = parse::<Person>(yaml);
        assert_eq!(res.len(), 1);
        assert_eq!(
            res[0],
            Person {
                name: "alice".to_string(),
                age: 33,
                categories: vec!["business".to_string(), "finance".to_string()],
                employer: "CorpA".to_string(),
            }
        );
    }

    #[test]
    fn converter_loop_string() {
        #[derive(Debug, Eq, PartialEq, Deserialize)]
        struct Person {
            name: String,
            age: usize,
            categories: Vec<String>,
        }

        let yaml = r#"
            - name: Some person
              person:
                name: "{{ item }}"
                age: 33
                categories:
                  - business
                  - finance
              loop:
                - alice
                - bob
                - eve
        "#;

        let res = parse::<Person>(yaml);
        assert_eq!(res.len(), 3);
        assert_eq!(
            res[0],
            Person {
                name: "alice".to_string(),
                age: 33,
                categories: vec!["business".to_string(), "finance".to_string()]
            }
        );
        assert_eq!(
            res[1],
            Person {
                name: "bob".to_string(),
                age: 33,
                categories: vec!["business".to_string(), "finance".to_string()]
            }
        );
        assert_eq!(
            res[2],
            Person {
                name: "eve".to_string(),
                age: 33,
                categories: vec!["business".to_string(), "finance".to_string()]
            }
        );
    }

    #[test]
    fn converter_loop_list() {
        #[derive(Debug, Eq, PartialEq, Deserialize)]
        struct Person {
            name: String,
            age: usize,
            categories: Vec<String>,
        }

        let yaml = r#"
            - name: Some person
              person:
                name: alice
                age: 33
                categories: "{{ item }}"
              loop:
                -
                  - business
                  - finance
                -
                  - hr
                  - marketing
        "#;

        let res = parse::<Person>(yaml);
        assert_eq!(res.len(), 2);
        assert_eq!(
            res[0],
            Person {
                name: "alice".to_string(),
                age: 33,
                categories: vec!["business".to_string(), "finance".to_string()]
            }
        );
        assert_eq!(
            res[1],
            Person {
                name: "alice".to_string(),
                age: 33,
                categories: vec!["hr".to_string(), "marketing".to_string()]
            }
        );
    }

    #[test]
    fn converter_loop_map() {
        #[derive(Debug, Eq, PartialEq, Deserialize)]
        struct Person {
            name: String,
            age: usize,
            attributes: Attributes,
        }

        #[derive(Debug, Eq, PartialEq, Deserialize)]
        struct Attributes {
            hair: String,
            height: usize,
        }

        let yaml = r#"
            - name: Some person
              person:
                name: alice
                age: 33
                attributes: "{{ item }}"
              loop:
                -
                  hair: blonde
                  height: 174
                -
                  hair: red
                  height: 165

        "#;

        let res = parse::<Person>(yaml);
        assert_eq!(res.len(), 2);
        assert_eq!(
            res[0],
            Person {
                name: "alice".to_string(),
                age: 33,
                attributes: Attributes {
                    hair: "blonde".to_string(),
                    height: 174
                }
            }
        );
        assert_eq!(
            res[1],
            Person {
                name: "alice".to_string(),
                age: 33,
                attributes: Attributes {
                    hair: "red".to_string(),
                    height: 165
                }
            }
        );
    }

    #[test]
    fn converter_loop_map_abbreviated() {
        #[derive(Debug, Eq, PartialEq, Deserialize)]
        struct Person {
            name: String,
            age: usize,
            attributes: Attributes,
        }

        #[derive(Debug, Eq, PartialEq, Deserialize)]
        struct Attributes {
            hair: String,
            height: usize,
        }

        let yaml = r#"
            - name: Some person
              person:
                name: alice
                age: 33
                attributes: "{{ item }}"
              loop:
                - { hair: "blonde", height: 174 }
                - { hair: "red", height: 165 }
        "#;

        let res = parse::<Person>(yaml);
        assert_eq!(res.len(), 2);
        assert_eq!(
            res[0],
            Person {
                name: "alice".to_string(),
                age: 33,
                attributes: Attributes {
                    hair: "blonde".to_string(),
                    height: 174
                }
            }
        );
        assert_eq!(
            res[1],
            Person {
                name: "alice".to_string(),
                age: 33,
                attributes: Attributes {
                    hair: "red".to_string(),
                    height: 165
                }
            }
        );
    }

    #[test]
    fn converter_loop_map_abbreviated_nested() {
        #[derive(Debug, Eq, PartialEq, Deserialize)]
        struct Person {
            name: String,
            age: usize,
            hair: String,
            height: usize,
        }

        let yaml = r#"
            - name: Some person
              person:
                name: alice
                age: 33
                hair: "{{ item.hair }}"
                height: "{{ item.height }}"
              loop:
                - { hair: "blonde", height: 174 }
                - { hair: "red", height: 165 }
        "#;

        let res = parse::<Person>(yaml);
        assert_eq!(res.len(), 2);
        assert_eq!(
            res[0],
            Person {
                name: "alice".to_string(),
                age: 33,
                hair: "blonde".to_string(),
                height: 174,
            }
        );
        assert_eq!(
            res[1],
            Person {
                name: "alice".to_string(),
                age: 33,
                hair: "red".to_string(),
                height: 165,
            }
        );
    }

    #[test]
    fn converter_index_array() {
        #[derive(Debug, Eq, PartialEq, Deserialize)]
        struct Person {
            name: String,
            age: usize,
            category: String,
        }

        let yaml = r#"
            - name: Some person
              person:
                name: alice
                age: 33
                category: "{{ category[1] }}"
              vars:
                category:
                  - business
                  - finance
                  - hr
        "#;

        let res = parse::<Person>(yaml);
        assert_eq!(res.len(), 1);
        assert_eq!(
            res[0],
            Person {
                name: "alice".to_string(),
                age: 33,
                category: "finance".to_string(),
            }
        );
    }

    #[test]
    fn converter_index_array_nested() {
        #[derive(Debug, Eq, PartialEq, Deserialize)]
        struct Person {
            name: String,
            age: usize,
            category: String,
        }

        let yaml = r#"
            - name: Some person
              person:
                name: alice
                age: 33
                category: "{{ category.finance[0] }}"
              vars:
                category:
                  business:
                    - marketing
                    - customers
                  finance:
                    - accountant
                    - cfo
        "#;

        let res = parse::<Person>(yaml);
        assert_eq!(res.len(), 1);
        assert_eq!(
            res[0],
            Person {
                name: "alice".to_string(),
                age: 33,
                category: "accountant".to_string(),
            }
        );
    }
}
