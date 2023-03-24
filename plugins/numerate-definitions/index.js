const visit = require('unist-util-visit');

let definitionNumber = 1;

const definitionNumberingPlugin = (options) => {
  const transformer = async (ast) => {
    visit(ast, 'heading', (node) => {
      if (node.children.length > 0) {
        const content = node.children[0].value;
        if (content.includes('-def-num-')) {
          node.children[0].value = content.replace('-def-num-', `${definitionNumber}.`);
          definitionNumber++;
        }
      }
    });
  };
  return transformer;
};

module.exports = definitionNumberingPlugin;
