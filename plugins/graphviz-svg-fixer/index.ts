import * as fs from 'fs';
import * as cheerio from 'cheerio';
import { Plugin, LoadContext } from '@docusaurus/types';
import fsc from "fs-cheerio";

// (async function(){

//   let $ = await fsc.readFile(__dirname + "/example.html");
//   $("#app").text("i changed this");

//   await fsc.writeFile(__dirname + "/example.html", $);

// })();

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

      // we get all the svg files to fix foreach html
      // TODO: remove g > path and fix the size
      let htmlIndex = 0;
      while (htmlIndex < htmlFilesToFix.length) {
        let htmlFile = htmlFilesToFix[htmlIndex];
        const $ = cheerio.load(htmlFile.html);
        let svgFiles = $('svg.graphviz');
        for (let svgFile of svgFiles) {
          let svgFileObj: SvgFile = { route: htmlFile.route, svg: $(svgFile), htmlIndex };
          allSvgFiles.push(svgFileObj);
        }
        htmlIndex++;
      }

      // for each svg file
      for (let svgFile of allSvgFiles) {
        const $ = cheerio.load(htmlFilesToFix[svgFile.htmlIndex].html);
        const prev = $.root().html();;
        // take all the g > g.node with at max 2 children
        const nodes = $(svgFile.svg).find('g > g.node');
        for (const node of nodes) {
          if ($(node).children().length == 2) {
            // take the text inside the text tag 
            let text = $(node).find('text');
            let cropped_text = text.text().split('__')[0];
            // cropped_text is sneak_case, we need to convert it to PascalCase
            let cropped_text_array = cropped_text.split('_');
            let CroppedText = '';
            for (let i = 0; i < cropped_text_array.length; i++) {
              CroppedText += cropped_text_array[i].charAt(0).toUpperCase() + cropped_text_array[i].slice(1);
            }
            // also we want the cropped-text version from cropped_text
            const croppedDashText = cropped_text.replace(/_/g, '-');
            let svgFound = false;
            let i = 0;
            while (!svgFound && i < allSvgFiles.length) {
              const svgFileToLink = allSvgFiles[i];
              if (svgFileToLink != svgFile) {
                let main_cluster = $(svgFileToLink.svg).find('g > g.cluster')[0];
                let clusterTitle = $(main_cluster).find('title').text().split('__')[1];
                if (cropped_text == clusterTitle) {
                  // we found the cluster to link
                  // encapsulate the text node in a link, like this:
                  // <a xlink:href="(external-page)#img-cropped-text" xlink:title="CroppedText">
                  //   <text ... >CroppedText</text>
                  // </a>
                  $(text).text(CroppedText);
                  let external_page = svgFileToLink.route == svgFile.route ? '' : svgFileToLink.route;
                  let link = $(`<a xlink:href="${external_page}#img-${croppedDashText}" xlink:title="${CroppedText}"></a>`);
                  $(text).wrap(link);
                  // log the parent of the text parent
                  svgFound = true;
                }
              }
              i++;
            }
            if (!svgFound) {
              
            }
          }
        }
        htmlFilesToFix[svgFile.htmlIndex].html = $.root().html();;
        console.log(prev == htmlFilesToFix[svgFile.htmlIndex].html);
      }
      // write the html files in the filesystem
      for (let htmlFile of htmlFilesToFix) {
        console.log(htmlFile.route)
        fs.writeFileSync(`${props.outDir}/${htmlFile.route}/index.html`, htmlFile.html);
        // find xlink:href="#img-cropped-text" inside the html and print it
        const $ = cheerio.load(htmlFile.html);
        let links = $('a[xlink\\:href]');
        for (let link of links) {
          console.log($(link).attr('xlink:href'));
        }
      }
      const $ = cheerio.load('<h2 class="title">Hello world</h2>');
      const prev = $.root().html();
      $('h2.title').text('Hello there!');
      $('h2').addClass('welcome');
      console.log(prev == $.root().html());
      console.log($.html());
    },
  }
};
