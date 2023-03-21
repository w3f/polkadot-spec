module.exports = function (context, options) {
  return {
    name: 'graphviz-svg-fixer',
	async loadContent() {
		console.log('loadContent');
	},
    async postBuild({siteConfig = {}, routesPaths = [], outDir}) {
		// Print out to console all the rendered routes.
		routesPaths.map((route) => {
		  console.log(route);
		});
	  },
  };
};