const visit = require('unist-util-visit');

let definitionNumber = 1;
let definitionMap = {};

const definitionNumberingPlugin = (options) => {
  const transformer = async (ast, vfile) => {
    visit(ast, 'heading', (node) => {
      if (node.children.length > 0) {
        const content = node.children[0].value;
        if (content.includes('-def-num-')) {
          node.children[0].value = content.replace('-def-num-', `${definitionNumber}.`);
          definitionMap[node.data.id] = {
            number: definitionNumber,
            // pageName: vfile.path.split('/docs/')[1].replace('.md', ''),
          };
          definitionNumber++;
        }
      }
    });
  
    visit(ast, 'link', (node) => {
      if (node.children.length > 0) {
        if (node.children[0].value.includes('-def-num-ref-')) {
          const definitionPage = node.url.split('#')[0];
          const definitionId = node.url.split('#')[1];
          const definition = definitionMap[definitionId];
          if (definition) {
            const pageName = definition.pageName;
            const number = definition.number;
            node.children[0].value = node.children[0].value.replace('-def-num-ref-', `${number}`);
          } else {

          }
        }
      }
    });
  };
  return transformer;
};

module.exports = definitionNumberingPlugin;



