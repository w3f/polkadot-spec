import * as fs from 'fs';
import * as cheerio from 'cheerio';
import { Plugin, LoadContext } from '@docusaurus/types';
const sidebarRoutes = require('../sidebarRoutes');

export interface HtmlFile {
  routeId: string;
  html: string;
}

export default function numerateSections(
  context: LoadContext,
): Plugin {
  return {
    name: 'numerate-sections',
    async postBuild(props) {
      // init html files array and sectionNumbers mapping
      let htmlFilesToFix: HtmlFile[] = [];
      let sectionsNumbersMap = []; // routeId -> sectionNumber
      let normalSectionsCounter = 1;
      let appendixSectionsCounter = "A";
      for (const route of sidebarRoutes) {
        // we don't want to include the main chapters and index in the numbering
        if (route.level != 0 || route.label.includes('Appendix')) {
          if (route.label.includes('Appendix')) {
            sectionsNumbersMap[route.id] = appendixSectionsCounter;
            appendixSectionsCounter = String.fromCharCode(appendixSectionsCounter.charCodeAt(0) + 1);
          } else {
            sectionsNumbersMap[route.id] = normalSectionsCounter;
            normalSectionsCounter++;
          }
          const filePath = `${props.outDir}/${route.id}/index.html`;
          const html = fs.readFileSync(filePath, 'utf8');
          if (html.includes('-sec-num-')) {
            let htmlFile: HtmlFile = { routeId: route.id, html };
            htmlFilesToFix.push(htmlFile);
          }
        }
      }

      let sectionLevelCounter = {}; // level -> sectionNumber
      let subsectionMap = []; // subsectionId -> subsectionNumber
      
      // TODO: replace -sec-num- also inside table of contents
      for (let htmlFile of htmlFilesToFix) {
        let $ = cheerio.load(htmlFile.html);
        // take all headings that include -sec-num- (no h6)
        let sectionNumber = sectionsNumbersMap[htmlFile.routeId];
        console.log(sectionNumber)
        sectionLevelCounter = {
          1: sectionNumber,
          2: 0,
          3: 0,
          4: 0,
          5: 0,
        };
        let headings = $('h2, h3, h4, h5');
        let prevLevel = 1;
        for (let heading of Array.from(headings)) {
          let level = +$(heading).prop('tagName').replace('H', '');
          let headingText = $(heading).text();
          if (headingText.includes('-sec-num-')) {
            let subsectionId = $(heading).attr('id');
            let subsectionNumber = "";
            if (level > prevLevel) {
              sectionLevelCounter[level] = 0;
            }
            sectionLevelCounter[level]++;
            for (let i = 1; i <= level; i++) {
              subsectionNumber += sectionLevelCounter[i] + ".";
            }
            subsectionMap[subsectionId] = subsectionNumber;
            let newHeadingText = headingText.replace('-sec-num-', subsectionNumber);
            $(heading).text(newHeadingText);
            prevLevel = level;
          }
        }
        htmlFile.html = $.html();
      }

      // replace references placeholders
      for (let htmlFile of htmlFilesToFix) {
        let $ = cheerio.load(htmlFile.html);
        let a = $('a');
        for (let aItem of Array.from(a)) {
          let aText = $(aItem).text();
          if (aText.includes('-sec-num-ref-')) {
            let href = $(aItem).attr('href');
            let subsectionId = href.split('#')[1];
            let subsectionNumber = subsectionMap[subsectionId];
            let newAText = aText.replace('-sec-num-ref-', subsectionNumber);
            $(aItem).text(newAText);
          }
        }
        fs.writeFileSync(`${props.outDir}/${htmlFile.routeId}/index.html`, $.html());
      }

    },
  }
};
