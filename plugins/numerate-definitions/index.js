"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (g && (g = 0, op[0] && (_ = 0)), _) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
exports.__esModule = true;
var fs = require("fs");
var cheerio = require("cheerio");
function numerateDefinitions(context) {
    return {
        name: 'numerate-definitions',
        postBuild: function (props) {
            return __awaiter(this, void 0, void 0, function () {
                var sidebar, sidebarItems, sidebarRoutes, _i, sidebarItems_1, item, _a, _b, subItem, htmlFilesToFix, _c, sidebarRoutes_1, route, filePath, html, htmlFile, definitionsMap, defCounter, _d, htmlFilesToFix_1, htmlFile, $, h6s, _e, h6s_1, h6, h6Text, id, newH6Text, _f, htmlFilesToFix_2, htmlFile, $, a, _g, a_1, aItem, aText, href, defId, defNumber, newAText;
                return __generator(this, function (_h) {
                    sidebar = require("".concat(props.siteDir, "/sidebars.js"));
                    sidebarItems = sidebar.tutorialSidebar;
                    sidebarRoutes = [];
                    for (_i = 0, sidebarItems_1 = sidebarItems; _i < sidebarItems_1.length; _i++) {
                        item = sidebarItems_1[_i];
                        if (item.type === 'doc') {
                            sidebarRoutes.push(item.id);
                        }
                        else if (item.type === 'category') {
                            sidebarRoutes.push(item.link.id);
                            for (_a = 0, _b = item.items; _a < _b.length; _a++) {
                                subItem = _b[_a];
                                sidebarRoutes.push(subItem.id);
                            }
                        }
                    }
                    htmlFilesToFix = [];
                    for (_c = 0, sidebarRoutes_1 = sidebarRoutes; _c < sidebarRoutes_1.length; _c++) {
                        route = sidebarRoutes_1[_c];
                        filePath = "".concat(props.outDir, "/").concat(route, "/index.html");
                        html = fs.readFileSync(filePath, 'utf8');
                        if (html.includes('-def-num-')) {
                            htmlFile = { route: route, html: html };
                            htmlFilesToFix.push(htmlFile);
                        }
                    }
                    definitionsMap = [];
                    defCounter = 1;
                    for (_d = 0, htmlFilesToFix_1 = htmlFilesToFix; _d < htmlFilesToFix_1.length; _d++) {
                        htmlFile = htmlFilesToFix_1[_d];
                        $ = cheerio.load(htmlFile.html);
                        h6s = $('h6');
                        for (_e = 0, h6s_1 = h6s; _e < h6s_1.length; _e++) {
                            h6 = h6s_1[_e];
                            h6Text = $(h6).text();
                            if (h6Text.includes('-def-num-')) {
                                id = $(h6).attr('id');
                                definitionsMap[id] = defCounter;
                                newH6Text = h6Text.replace('-def-num-', defCounter.toString() + ".");
                                $(h6).text(newH6Text);
                                defCounter++;
                            }
                        }
                        htmlFile.html = $.html();
                    }
                    for (_f = 0, htmlFilesToFix_2 = htmlFilesToFix; _f < htmlFilesToFix_2.length; _f++) {
                        htmlFile = htmlFilesToFix_2[_f];
                        $ = cheerio.load(htmlFile.html);
                        a = $('a');
                        for (_g = 0, a_1 = a; _g < a_1.length; _g++) {
                            aItem = a_1[_g];
                            aText = $(aItem).text();
                            if (aText.includes('-def-num-ref-')) {
                                href = $(aItem).attr('href');
                                defId = href.split('#')[1];
                                defNumber = definitionsMap[defId];
                                newAText = aText.replace('-def-num-ref-', defNumber);
                                $(aItem).text(newAText);
                            }
                        }
                        fs.writeFileSync("".concat(props.outDir, "/").concat(htmlFile.route, "/index.html"), $.html());
                    }
                    return [2 /*return*/];
                });
            });
        }
    };
}
exports["default"] = numerateDefinitions;
;
