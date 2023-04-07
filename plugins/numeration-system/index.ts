import * as fs from 'fs';
import * as cheerio from 'cheerio';
import { Plugin, LoadContext } from '@docusaurus/types';
const sidebarRoutes = require('../sidebarRoutes');

export interface HtmlFile {
  routeId: string;
  html: string;
}

const defNum = '-def-num-';
const defNumRef = '-def-num-ref-';
const tabNum = '-tab-num-';
const tabNumRef = '-tab-num-ref-';
const secNum = '-sec-num-';
const secNumRef = '-sec-num-ref-';
const chapNumRef = '-chap-num-ref-';
const toReplace = [defNum, defNumRef, tabNum, tabNumRef, secNum, secNumRef, chapNumRef];

const replaceReferencePlaceholder = (
  linkText: string,
  placeholder: string,
  linkItem: cheerio.Element,
  map: any,
  $: cheerio.CheerioAPI,
  findId: (href: string) => string,
) => {
  if (linkText.includes(placeholder)) {
    let href = $(linkItem).attr('href');
    let id = findId(href);
    let number = map[id];
    let newLinkText = linkText.replace(placeholder, number);
    $(linkItem).text(newLinkText);
  }
};

export default function numerationSystem(
  context: LoadContext,
): Plugin {
  return {
    name: 'numeration-system',
    async postBuild(props) {
      // init html files array and sectionNumbers mapping
      let htmlFilesToFix: HtmlFile[] = [];
      let chaptersMap = []; // routeId -> sectionNumber
      let chaptersCounter = 1;
      let appendixsCounter = "A";
      for (const route of sidebarRoutes) {
        // we don't want to include the main chapters and index in the numbering
        if (route.level != 0 || route.label.includes('Appendix')) {
          if (route.label.includes('Appendix')) {
            chaptersMap[route.id] = appendixsCounter;
            appendixsCounter = String.fromCharCode(appendixsCounter.charCodeAt(0) + 1);
          } else {
            chaptersMap[route.id] = chaptersCounter;
            chaptersCounter++;
          }
        }
        const filePath = `${props.outDir}/${route.id}/index.html`;
        const html = fs.readFileSync(filePath, 'utf8');
        let isToFix = toReplace.some((item) => html.includes(item));
        if (isToFix) {
          let htmlFile: HtmlFile = { routeId: route.id, html };
          htmlFilesToFix.push(htmlFile);
        }
      }

      let definitionsMap = [];
      let defCounter = 0;
      let tablesMap = [];
      let tablesCounter = 0;
      let sectionLevelCounter = {}; // level -> sectionNumber
      let sectionsMap = []; // subsectionId -> subsectionNumber

      // first we replace the numbersplaceholders in the headings
      // and we fill the mappings
      for (let htmlFile of htmlFilesToFix) {
        let $ = cheerio.load(htmlFile.html) as cheerio.CheerioAPI;
        // replace definitions numbers placeholders
        // and fill the definitionsMap
        let h6s = $('h6');
        for (let h6 of Array.from(h6s)) {
          let h6Text = $(h6).text();
          if (h6Text.includes(defNum)) {
            defCounter++;
            let id = $(h6).attr('id');
            definitionsMap[id] = defCounter;
            let newH6Text = h6Text.replace(defNum, defCounter.toString()+".");
            $(h6).text(newH6Text);
          }
          if (h6Text.includes(tabNum)) {
            tablesCounter++;
            let id = $(h6).attr('id');
            tablesMap[id] = tablesCounter;
            let newH6Text = h6Text.replace(tabNum, tablesCounter.toString()+".");
            $(h6).text(newH6Text);
          }
        }
        // replace section numbers placeholders
        // and fill the sectionsMap
        let sectionNumber = chaptersMap[htmlFile.routeId];
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
          if (headingText.includes(secNum)) {
            let subsectionId = $(heading).attr('id');
            let subsectionNumber = "";
            if (level > prevLevel) {
              sectionLevelCounter[level] = 0;
            }
            sectionLevelCounter[level]++;
            for (let i = 1; i <= level; i++) {
              subsectionNumber += sectionLevelCounter[i] + ".";
            }
            sectionsMap[subsectionId] = subsectionNumber;
            let newHeadingText = headingText.replace(secNum, subsectionNumber);
            $(heading).text(newHeadingText);
            prevLevel = level;
          }
        }
        htmlFile.html = $.html();
      }

      // now that we have the mappings, we can replace the references
      for (let htmlFile of htmlFilesToFix) {
        let $ = cheerio.load(htmlFile.html) as cheerio.CheerioAPI;
        // replace references placeholders
        let a = $('a');
        let defaultFindId = (href: string) => href.split('#')[1];
        for (let aItem of Array.from(a)) {
          let aText = $(aItem).text();
          // replace references to definitions
          replaceReferencePlaceholder(aText, defNumRef, aItem, definitionsMap, $, defaultFindId);
          replaceReferencePlaceholder(aText, tabNumRef, aItem, tablesMap, $, defaultFindId);
          replaceReferencePlaceholder(aText, secNumRef, aItem, sectionsMap, $, defaultFindId);
          replaceReferencePlaceholder(aText, chapNumRef, aItem, chaptersMap, $, (href) => href.substring(1));
        }
        // replace TOC placeholders
        let tocLinks = $('a.table-of-contents__link');
        for (let tocLink of Array.from(tocLinks)) {
          let tocLinkText = $(tocLink).text();
          replaceReferencePlaceholder(tocLinkText, secNum, tocLink, sectionsMap, $, defaultFindId);
        }
        fs.writeFileSync(`${props.outDir}/${htmlFile.routeId}/index.html`, $.html());
      }
    },
  }
};
