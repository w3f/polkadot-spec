import * as fs from 'fs';
import * as cheerio from 'cheerio';
import { Plugin, LoadContext } from '@docusaurus/types';
import * as fsc from 'fs-cheerio';

export interface HtmlFile {
  route: string;
  html: string;
}

export interface SvgFile {
  route: string;
  svg: cheerio.Cheerio<cheerio.Element>;
  htmlIndex: number;
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
      let allSvgFiles: SvgFile[] = [];  

      for (const route of routes) {
        const filePath = `${props.outDir}${route}/index.html`;
        const html = fs.readFileSync(filePath, 'utf8');
  
        if (html.includes('graphviz')) {
          // push to htmlFilesToFix an object with the route without the / and the html
          let htmlFile: HtmlFile = { route: route.slice(1), html };
          htmlFilesToFix.push(htmlFile);
        }
      }

      // // we get all the svg files to fix foreach html
      // // TODO: remove g > path and fix the size
      // let htmlIndex = 0;
      // while (htmlIndex < htmlFilesToFix.length) {
      //   let htmlFile = htmlFilesToFix[htmlIndex];
      //   const $ = cheerio.load(htmlFile.html);
      //   let svgFiles = $('svg.graphviz');
      //   for (let svgFile of svgFiles) {
      //     let svgFileObj: SvgFile = { route: htmlFile.route, svg: $(svgFile), htmlIndex };
      //     allSvgFiles.push(svgFileObj);
      //   }
      //   htmlIndex++;
      // }

      // // delete all the svgs from the html files
      // for (let htmlFile of htmlFilesToFix) {
      //   const $ = cheerio.load(htmlFile.html);
      //   $('svg.graphviz').remove();
      //   // log a thing that shows that svg has been removed (like $('svg.graphviz').length)
      //   console.log($(`svg.graphviz`).length);
      //   fs.writeFileSync(`${props.outDir}/${htmlFile.route}/index.html`, $.html());
      // }

      (async function(){
        
        for (let htmlFile of htmlFilesToFix) {
          let html = fs.readFileSync(`${props.outDir}/${htmlFile.route}/index.html`);
          const $ = cheerio.load(html);
          const prev = $.html();
          $('svg.graphviz').remove();
          let next = $.html();
          console.log(prev == next);
          fs.writeFileSync(`${props.outDir}/${htmlFile.route}/index.html`, $.html());
        }
       
      })();

    },
  }
};
