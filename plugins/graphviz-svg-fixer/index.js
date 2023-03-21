const fs = require('fs');
const cheerio = require('cheerio');

module.exports = function (context, options) {
  return {
    name: 'graphviz-svg-fixer',
	async postBuild(props) {
		console.log(props.routesPaths)
		console.log(props.outDir)
		const blacklist = [
			'/404.html',
			'/',
		];
		const routes = props.routesPaths.filter(
			(route) => !blacklist.includes(route) && !route.startsWith('/__docusaurus')
		);
		let htmlFilesToFix = [];
		for (let route of routes) {
			let filePath = `${props.outDir}${route}/index.html`;
			let html = fs.readFileSync(filePath, 'utf8');
			if (html.includes('graphviz')) {
				// push to htmlFilesToFix an object  with the route without the / and the html
				htmlFilesToFix.push({ route: route.slice(1), html });
			}
		}
		// now find all the svg files and fix them
	},
  };
};