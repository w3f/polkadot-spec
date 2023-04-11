"use strict";
exports.__esModule = true;
var fs = require("fs");
var sidebarRoutes = require('../sidebarRoutes');
var filePathIn = 'src/docs';
var filePathOut = 'docs';
var defNum = '-def-num-';
var defNumRef = '-def-num-ref-';
var tabNum = '-tab-num-';
var tabNumRef = '-tab-num-ref-';
var secNum = '-sec-num-';
var secNumRef = '-sec-num-ref-';
var chapNumRef = '-chap-num-ref-';
var toReplace = [defNum, defNumRef, tabNum, tabNumRef, secNum, secNumRef, chapNumRef];
var replaceReferencePlaceholder = function (mdFile, oldLink, linkText, href, placeholder, map, findId) {
    if (linkText.includes(placeholder)) {
        var id = findId(href);
        var number = map[id];
        var newLinkText = linkText.replace(placeholder, number);
        var newLink = "[".concat(newLinkText, "](").concat(href, ")");
        mdFile.md = mdFile.md.replace(oldLink, newLink);
    }
};
var getIdFromHeaderLine = function (line) {
    var id = line.split(' ').pop();
    return id.substring(2, id.length - 1);
};
var numerationSystem = function () {
    // init md files array and sectionNumbers mapping
    var mdFilesToCompile = [];
    var mdFilesNotToCompile = [];
    var chaptersMap = []; // routeId -> sectionNumber
    var chaptersCounter = 1;
    var appendixsCounter = "A";
    var _loop_1 = function (route) {
        // we don't want to include the main chapters and index in the numbering
        if (route.level != 0 || route.label.includes('Appendix')) {
            if (route.label.includes('Appendix')) {
                chaptersMap[route.id] = appendixsCounter;
                appendixsCounter = String.fromCharCode(appendixsCounter.charCodeAt(0) + 1);
            }
            else {
                chaptersMap[route.id] = chaptersCounter;
                chaptersCounter++;
            }
        }
        var filePath = "".concat(filePathIn, "/").concat(route.id, ".md");
        var md = fs.readFileSync(filePath, 'utf8');
        var isToFix = toReplace.some(function (item) { return md.includes(item); });
        var mdFile = { routeId: route.id, md: md };
        if (isToFix) {
            mdFilesToCompile.push(mdFile);
        }
        else {
            mdFilesNotToCompile.push(mdFile);
        }
    };
    for (var _i = 0, sidebarRoutes_1 = sidebarRoutes; _i < sidebarRoutes_1.length; _i++) {
        var route = sidebarRoutes_1[_i];
        _loop_1(route);
    }
    var definitionsMap = [];
    var defCounter = 0;
    var tablesMap = [];
    var tablesCounter = 0;
    var sectionLevelCounter = {}; // level -> sectionNumber
    var sectionsMap = []; // subsectionId -> subsectionNumber
    // first we replace the numbersplaceholders in the headings
    // and we fill the mappings
    for (var _a = 0, mdFilesToCompile_1 = mdFilesToCompile; _a < mdFilesToCompile_1.length; _a++) {
        var mdFile = mdFilesToCompile_1[_a];
        // replace definitions numbers placeholders
        // and fill the definitionsMap
        var lines = mdFile.md.split('\n');
        var prevLevel = 1;
        var sectionNumber = chaptersMap[mdFile.routeId];
        sectionLevelCounter = {
            1: sectionNumber,
            2: 0,
            3: 0,
            4: 0,
            5: 0
        };
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i];
            if (line.startsWith('######')) {
                if (line.includes(defNum)) {
                    defCounter++;
                    var id = getIdFromHeaderLine(line);
                    definitionsMap[id] = defCounter;
                    var newLine = line.replace(defNum, defCounter.toString() + ".");
                    lines[i] = newLine;
                }
                if (line.includes(tabNum)) {
                    tablesCounter++;
                    var id = getIdFromHeaderLine(line);
                    tablesMap[id] = tablesCounter;
                    var newLine = line.replace(tabNum, tablesCounter.toString() + ".");
                    lines[i] = newLine;
                }
            }
            else if (line.startsWith('##')) {
                if (line.includes(secNum)) {
                    // split the line by spaces and take last element, it will be like this: {#id-ext_storage_read}
                    var subsectionId = getIdFromHeaderLine(line);
                    var level = +line.split(' ')[0].length;
                    if (level > prevLevel) {
                        sectionLevelCounter[level] = 0;
                    }
                    sectionLevelCounter[level]++;
                    var sectionNumber_1 = "";
                    for (var i_1 = 1; i_1 <= level; i_1++) {
                        sectionNumber_1 += sectionLevelCounter[i_1] + ".";
                    }
                    sectionsMap[subsectionId] = sectionNumber_1;
                    var newLine = line.replace(secNum, sectionNumber_1);
                    lines[i] = newLine;
                    prevLevel = level;
                }
            }
        }
        mdFile.md = lines.join('\n');
    }
    var defaultFindId = function (href) { return href.split('#')[1]; };
    // now that we have the mappings, we can replace the references
    for (var _b = 0, mdFilesToCompile_2 = mdFilesToCompile; _b < mdFilesToCompile_2.length; _b++) {
        var mdFile = mdFilesToCompile_2[_b];
        // find all the links, they are in the format [XXX -placeholder-](YYY*ZZZ)
        // so inside [] we have two strings separated by a space, and inside () we have just one string
        // match exactly links that have a placeholder
        var links = mdFile.md.match(/\[[^\]]+\]\([^\)]+\)/g);
        if (links) {
            for (var _c = 0, links_1 = links; _c < links_1.length; _c++) {
                var link = links_1[_c];
                var linkText = link.split(']')[0].substring(1);
                var href = link.split(']')[1].split('(')[1].split(')')[0];
                // replace references to definitions
                replaceReferencePlaceholder(mdFile, link, linkText, href, defNumRef, definitionsMap, defaultFindId);
                replaceReferencePlaceholder(mdFile, link, linkText, href, tabNumRef, tablesMap, defaultFindId);
                replaceReferencePlaceholder(mdFile, link, linkText, href, secNumRef, sectionsMap, defaultFindId);
                replaceReferencePlaceholder(mdFile, link, linkText, href, chapNumRef, chaptersMap, function (href) { return href; });
            }
        }
    }
    // now we can write the files
    for (var _d = 0, mdFilesToCompile_3 = mdFilesToCompile; _d < mdFilesToCompile_3.length; _d++) {
        var mdFile = mdFilesToCompile_3[_d];
        fs.writeFileSync("".concat(filePathOut, "/").concat(mdFile.routeId, ".md"), mdFile.md);
    }
    for (var _e = 0, mdFilesNotToCompile_1 = mdFilesNotToCompile; _e < mdFilesNotToCompile_1.length; _e++) {
        var mdFile = mdFilesNotToCompile_1[_e];
        fs.writeFileSync("".concat(filePathOut, "/").concat(mdFile.routeId, ".md"), mdFile.md);
    }
};
numerationSystem();
