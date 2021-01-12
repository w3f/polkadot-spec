macro_rules! module {
    (
        #[serde(rename = $module_name:expr)]
        struct $struct:ident;

        enum $enum:ident {
            $(
                #[serde(rename = $func_name:expr)]
                $func:ident {
                    $($func_tt:tt)*
                },
            )*
        }

        impl $struct2:ident {
            fn run($self:ident) -> Result<$ret:ty> $run_body:block
        }
    ) => {
        #[derive(Debug, Serialize, Deserialize)]
        #[serde(rename = $module_name)]
        pub struct $struct {
            call: $enum,
        }

        #[derive(Debug, Serialize, Deserialize)]
        pub enum $enum {
            $(
                #[serde(rename = $func_name)]
                $func {
                    $($func_tt)*
                },
            )*
        }

        impl crate::builder::ModuleInfo for $struct {
            fn module_name(&self) -> crate::builder::ModuleName {
                crate::builder::ModuleName::from($module_name)
            }
            fn function_name(&self) -> crate::builder::FunctionName {
                match self.call {
                    $( $enum::$func { .. } => crate::builder::FunctionName::from($func_name), )*
                }
            }
        }

        impl crate::builder::ModuleInfo for $enum {
            fn module_name(&self) -> crate::builder::ModuleName {
                crate::builder::ModuleName::from($module_name)
            }
            fn function_name(&self) -> crate::builder::FunctionName {
                match self {
                    $( $enum::$func { .. } => crate::builder::FunctionName::from($func_name), )*
                }
            }
        }

        impl crate::builder::Builder for $struct {
            type Input = $enum;
            type Output = $ret;

            fn run($self) -> crate::Result<Self::Output> $run_body
        }

        impl From<$enum> for $struct {
            fn from(value: $enum) -> Self {
                $struct {
                    call: value,
                }
            }
        }
    };
}

macro_rules! from_str {
    ($($name:ident,)*) => {
        $(
            impl FromStr for $name {
                type Err = failure::Error;

                fn from_str(val: &str) -> Result<Self> {
                    Ok($name(val.to_string()))
                }
            }
        )*
    };
}

macro_rules! mapping {
    ($($ident:ident => $cmd:ident,)*) => {
        #[derive(Debug, Clone, Eq, PartialEq, Hash, Serialize, Deserialize)]
        #[serde(rename_all = "snake_case")]
        enum Mapping {
            $($ident,)*
        }

        impl crate::tool_spec::Mapper for Mapping {
            fn map(proc: &mut Processor<Mapping>, task: Task<Mapping>) -> Result<()> {
                match task.task_type()? {
                    $(
                        Mapping::$ident => proc.parse_task::<$cmd>(task)?,
                    )*
                };

                Ok(())
            }
        }
    };
}
