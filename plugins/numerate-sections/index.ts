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
        }
        const filePath = `${props.outDir}/${route.id}/index.html`;
        const html = fs.readFileSync(filePath, 'utf8');
        if (html.includes('-sec-num-')) {
          let htmlFile: HtmlFile = { routeId: route.id, html };
          htmlFilesToFix.push(htmlFile);
        }
      }

      let sectionLevelCounter = {}; // level -> sectionNumber
      let subsectionMap = []; // subsectionId -> subsectionNumber
      // first we replace the placeholders in the headings
      // and we fill the subsectionMap
      for (let htmlFile of htmlFilesToFix) {
        let $ = cheerio.load(htmlFile.html);
        // take all headings that include -sec-num- (no h6)
        let sectionNumber = sectionsNumbersMap[htmlFile.routeId];
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

      // now that we have the subsectionMap, we can replace the references
      for (let htmlFile of htmlFilesToFix) {
        let $ = cheerio.load(htmlFile.html);
        // replace references placeholders
        let a = $('a');
        for (let aItem of Array.from(a)) {
          let aText = $(aItem).text();
          // replace references to sections
          if (aText.includes('-sec-num-ref-')) {
            let href = $(aItem).attr('href');
            let subsectionId = href.split('#')[1];
            let subsectionNumber = subsectionMap[subsectionId];
            let newAText = aText.replace('-sec-num-ref-', subsectionNumber);
            $(aItem).text(newAText);
          }
          // replace references to chapters
          if (aText.includes('-chap-num-ref-')) {
            let href = $(aItem).attr('href');
            let routeId = href.substring(1);
            let sectionNumber = sectionsNumbersMap[routeId];
            let newAText = aText.replace('-chap-num-ref-', sectionNumber);
            $(aItem).text(newAText);
          }
        }
        // replace TOC placeholders
        let tocLinks = $('a.table-of-contents__link');
        for (let tocLink of Array.from(tocLinks)) {
          let tocLinkText = $(tocLink).text();
          if (tocLinkText.includes('-sec-num-')) {
            let href = $(tocLink).attr('href');
            // cut the first character (#)
            let subsectionId = href.substring(1);
            let subsectionNumber = subsectionMap[subsectionId];
            let newTocLinkText = tocLinkText.replace('-sec-num-', subsectionNumber);
            $(tocLink).text(newTocLinkText);
          }
        }
        fs.writeFileSync(`${props.outDir}/${htmlFile.routeId}/index.html`, $.html());
      }

    },
  }
};
