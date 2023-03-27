import * as fs from 'fs';
import * as cheerio from 'cheerio';
import { Plugin, LoadContext } from '@docusaurus/types';

export interface HtmlFile {
  route: string;
  html: string;
}

export default function graphvizSvgFixer(
  context: LoadContext,
): Plugin {
  return {
    name: 'graphviz-svg-fixer',
    async postBuild(props) {
      const blacklist: string[] = [
        '/404.html',
        '/',
      ];
  
      const routes = props.routesPaths.filter(
        (route) =>
          !blacklist.includes(route) &&
          !route.startsWith('/__docusaurus')
      );
  
      let htmlFilesToFix: HtmlFile[] = [];
      // svgs to fix foreach html file
      let svgsMap: string[] = [];

      for (const route of routes) {
        const filePath = `${props.outDir}${route}/index.html`;
        const html = fs.readFileSync(filePath, 'utf8');
  
        if (html.includes('graphviz')) {
          // push to htmlFilesToFix an object with the route without the / and the html
          let htmlFile: HtmlFile = { route: route.slice(1), html };
          htmlFilesToFix.push(htmlFile);
        }
      }

      // we get all the svg files to fix foreach html
      // TODO: remove g > path and fix the size
      let htmlIndex = 0;
      while (htmlIndex < htmlFilesToFix.length) {
        let htmlFile = htmlFilesToFix[htmlIndex];
        const $ = cheerio.load(htmlFile.html);
        let svgElements = $('svg.graphviz');
        for (let svgElement of svgElements) {
          let cluster = $(svgElement).find('g > g.cluster')[0];
          let clusterTitle = $(cluster).find('title').text().split("__")[1];
          svgsMap[clusterTitle] = htmlFile.route;
        }
        htmlIndex++;
      }

      // for each html file
      for (let htmlFile of htmlFilesToFix) {
        const $ = cheerio.load(htmlFile.html);
        // take all the svgs with selector
        $('svg.graphviz').each((index, svg) => {
          // take all the g > g.node with at max 2 children
          $(svg).find('g > g.node').each((index, node) => {
            if ($(node).children().length == 2) {
              let text = $(node).find('text');
              let cropped_text = text.text().split('__')[0];
              let cropped_text_array = cropped_text.split('_');
              let CroppedText = '';
              for (let i = 0; i < cropped_text_array.length; i++) {
                CroppedText += cropped_text_array[i].charAt(0).toUpperCase() + cropped_text_array[i].slice(1);
              }
              const croppedDashText = cropped_text.replace(/_/g, '-');
              if (svgsMap[cropped_text] != undefined) {
                let externalLink = `
                  <a xlink:href="${svgsMap[cropped_text]}.html#img-${croppedDashText}" xlink:title="${CroppedText}">
                    ${CroppedText}
                  </a>
                `;
                text.html(externalLink);
              } else {
                // delete the node
                $(node).remove();
                // delete the associated edges
                $(svg).find('g > g.edge').each((index, edge) => {
                  if ($(edge).find('title').text().includes(cropped_text)) {
                    $(edge).remove();
                  }
                });
              }
            }
          });
        });
        // remove the path from the svg
        $('svg > g > path').remove();
        // adjust the viewbox for all the svg.graphviz
        // the new one has to fit the dimensions of the svg > g.graph
        

        fs.writeFileSync(`${props.outDir}/${htmlFile.route}/index.html`, $.html());
      }
    },
  }
};
