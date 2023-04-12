import * as fs from 'fs';
const sidebarRoutes = require('../sidebarRoutes');
const filePathIn = 'src/docs'
const filePathOut = 'docs'

export interface MdFile {
  routeId: string;
  md: string;
}

const defNum = '-def-num-';
const defNumRef = '-def-num-ref-';
const tabNum = '-tab-num-';
const tabNumRef = '-tab-num-ref-';
const secNum = '-sec-num-';
const secNumRef = '-sec-num-ref-';
const imgNum = '-img-num-';
const imgNumRef = '-img-num-ref-';
const chapNumRef = '-chap-num-ref-';
const toReplace = [defNum, defNumRef, tabNum, tabNumRef, secNum, secNumRef, chapNumRef];

const replaceReferencePlaceholder = (
  mdFile: MdFile,
  oldLink: string,
  linkText: string,
  href: string,
  placeholder: string,
  map: any,
  findId: (href: string) => string,
) => {
  if (linkText.includes(placeholder)) {
    let id = findId(href);
    let number = map[id];
    let newLinkText = linkText.replace(placeholder, number);
    let newLink = `[${newLinkText}](${href})`;
    mdFile.md = mdFile.md.replace(oldLink, newLink);
  }
};

const getIdFromHeaderLine = (line: string) => {
  let id = line.split(' ').pop();
  return id.substring(2, id.length - 1);
}

const numerationSystem = () => {
  // init md files array and sectionNumbers mapping
  let mdFilesToCompile: MdFile[] = [];
  let mdFilesNotToCompile: MdFile[] = [];
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
    const filePath = `${filePathIn}/${route.id}.md`;
    const md = fs.readFileSync(filePath, 'utf8');
    let isToFix = toReplace.some((item) => md.includes(item));
    let mdFile: MdFile = { routeId: route.id, md };
    if (isToFix) {
      mdFilesToCompile.push(mdFile);
    } else {
      mdFilesNotToCompile.push(mdFile);
    }
  }

  let definitionsMap = [];
  let defCounter = 0;
  let tablesMap = [];
  let tablesCounter = 0;
  let sectionLevelCounter = {}; // level -> sectionNumber
  let sectionsMap = []; // subsectionId -> subsectionNumber
  let imgMap = [];
  let imgCounter = 0;

  // first we replace the numbersplaceholders in the headings
  // and we fill the mappings
  for (let mdFile of mdFilesToCompile) {
    // replace definitions numbers placeholders
    // and fill the definitionsMap
    let lines = mdFile.md.split('\n');
    let prevLevel = 1;
    let sectionNumber = chaptersMap[mdFile.routeId];
    sectionLevelCounter = {
      1: sectionNumber,
      2: 0,
      3: 0,
      4: 0,
      5: 0,
    };
    for (let i = 0; i < lines.length; i++) {
      let line = lines[i];
      if (line.startsWith('######')) {
        if (line.includes(defNum)) {
          defCounter++;
          let id = getIdFromHeaderLine(line)
          definitionsMap[id] = defCounter;
          let newLine = line.replace(defNum, defCounter.toString()+".");
          lines[i] = newLine;
        }
        if (line.includes(tabNum)) {
          tablesCounter++;
          let id = getIdFromHeaderLine(line)
          tablesMap[id] = tablesCounter;
          let newLine = line.replace(tabNum, tablesCounter.toString()+".");
          lines[i] = newLine;
        }
        if (line.includes(imgNum)) {
          imgCounter++;
          let id = getIdFromHeaderLine(line)
          imgMap[id] = imgCounter;
          let newLine = line.replace(imgNum, imgCounter.toString()+".");
          lines[i] = newLine;
        }
      } else if (line.startsWith('##')) {
        if (line.includes(secNum)) {
          // split the line by spaces and take last element, it will be like this: {#id-ext_storage_read}
          let subsectionId = getIdFromHeaderLine(line)
          let level = +line.split(' ')[0].length;
          if (level > prevLevel) {
            sectionLevelCounter[level] = 0;
          }
          sectionLevelCounter[level]++;
          let sectionNumber = "";
          for (let i = 1; i <= level; i++) {
            sectionNumber += sectionLevelCounter[i] + ".";
          }
          sectionsMap[subsectionId] = sectionNumber;
          let newLine = line.replace(secNum, sectionNumber);
          lines[i] = newLine;
          prevLevel = level;
        }
      }
    }
    mdFile.md = lines.join('\n');
  }

  const defaultFindId = (href: string) => href.split('#')[1];
  // now that we have the mappings, we can replace the references
  for (let mdFile of mdFilesToCompile) {
    // find all the links, they are in the format [XXX -placeholder-](YYY*ZZZ)
    // so inside [] we have two strings separated by a space, and inside () we have just one string
    // match exactly links that have a placeholder
    let links = mdFile.md.match(/\[[^\]]+\]\([^\)]+\)/g);
    if (links) {
      for (let link of links) {
        let linkText = link.split(']')[0].substring(1);
        let href = link.split(']')[1].split('(')[1].split(')')[0];
        // replace references to definitions
        replaceReferencePlaceholder(mdFile, link, linkText, href, defNumRef, definitionsMap, defaultFindId);
        replaceReferencePlaceholder(mdFile, link, linkText, href, tabNumRef, tablesMap, defaultFindId);
        replaceReferencePlaceholder(mdFile, link, linkText, href, secNumRef, sectionsMap, defaultFindId);
        replaceReferencePlaceholder(mdFile, link, linkText, href, chapNumRef, chaptersMap, (href) => href);
        replaceReferencePlaceholder(mdFile, link, linkText, href, imgNumRef, imgMap, defaultFindId);
      }
    }
  }

  // now we can write the files
  for (let mdFile of mdFilesToCompile) {
    fs.writeFileSync(`${filePathOut}/${mdFile.routeId}.md`, mdFile.md);
  }
  for (let mdFile of mdFilesNotToCompile) {
    fs.writeFileSync(`${filePathOut}/${mdFile.routeId}.md`, mdFile.md);
  }
}

numerationSystem();
