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
function graphvizSvgFixer(context) {
    return {
        name: 'graphviz-svg-fixer',
        postBuild: function (props) {
            return __awaiter(this, void 0, void 0, function () {
                var blacklist, routes, htmlFilesToFix, allSvgFiles, _i, routes_1, route, filePath, html, htmlFile, htmlIndex, htmlFile, $_1, svgFiles, _a, svgFiles_1, svgFile, svgFileObj, _b, allSvgFiles_1, svgFile, $_2, prev_1, nodes, _c, nodes_1, node, text, cropped_text, cropped_text_array, CroppedText, i_1, croppedDashText, svgFound, i, svgFileToLink, main_cluster, clusterTitle, external_page, link, _d, htmlFilesToFix_1, htmlFile, $_3, links, _e, links_1, link, $, prev;
                return __generator(this, function (_f) {
                    blacklist = [
                        '/404.html',
                        '/',
                    ];
                    routes = props.routesPaths.filter(function (route) {
                        return !blacklist.includes(route) &&
                            !route.startsWith('/__docusaurus');
                    });
                    htmlFilesToFix = [];
                    allSvgFiles = [];
                    for (_i = 0, routes_1 = routes; _i < routes_1.length; _i++) {
                        route = routes_1[_i];
                        filePath = "".concat(props.outDir).concat(route, "/index.html");
                        html = fs.readFileSync(filePath, 'utf8');
                        if (html.includes('graphviz')) {
                            htmlFile = { route: route.slice(1), html: html };
                            htmlFilesToFix.push(htmlFile);
                        }
                    }
                    htmlIndex = 0;
                    while (htmlIndex < htmlFilesToFix.length) {
                        htmlFile = htmlFilesToFix[htmlIndex];
                        $_1 = cheerio.load(htmlFile.html);
                        svgFiles = $_1('svg.graphviz');
                        for (_a = 0, svgFiles_1 = svgFiles; _a < svgFiles_1.length; _a++) {
                            svgFile = svgFiles_1[_a];
                            svgFileObj = { route: htmlFile.route, svg: $_1(svgFile), htmlIndex: htmlIndex };
                            allSvgFiles.push(svgFileObj);
                        }
                        htmlIndex++;
                    }
                    // for each svg file
                    for (_b = 0, allSvgFiles_1 = allSvgFiles; _b < allSvgFiles_1.length; _b++) {
                        svgFile = allSvgFiles_1[_b];
                        $_2 = cheerio.load(htmlFilesToFix[svgFile.htmlIndex].html);
                        prev_1 = $_2.root().html();
                        ;
                        nodes = $_2(svgFile.svg).find('g > g.node');
                        for (_c = 0, nodes_1 = nodes; _c < nodes_1.length; _c++) {
                            node = nodes_1[_c];
                            if ($_2(node).children().length == 2) {
                                text = $_2(node).find('text');
                                cropped_text = text.text().split('__')[0];
                                cropped_text_array = cropped_text.split('_');
                                CroppedText = '';
                                for (i_1 = 0; i_1 < cropped_text_array.length; i_1++) {
                                    CroppedText += cropped_text_array[i_1].charAt(0).toUpperCase() + cropped_text_array[i_1].slice(1);
                                }
                                croppedDashText = cropped_text.replace(/_/g, '-');
                                svgFound = false;
                                i = 0;
                                while (!svgFound && i < allSvgFiles.length) {
                                    svgFileToLink = allSvgFiles[i];
                                    if (svgFileToLink != svgFile) {
                                        main_cluster = $_2(svgFileToLink.svg).find('g > g.cluster')[0];
                                        clusterTitle = $_2(main_cluster).find('title').text().split('__')[1];
                                        if (cropped_text == clusterTitle) {
                                            // we found the cluster to link
                                            // encapsulate the text node in a link, like this:
                                            // <a xlink:href="(external-page)#img-cropped-text" xlink:title="CroppedText">
                                            //   <text ... >CroppedText</text>
                                            // </a>
                                            $_2(text).text(CroppedText);
                                            external_page = svgFileToLink.route == svgFile.route ? '' : svgFileToLink.route;
                                            link = $_2("<a xlink:href=\"".concat(external_page, "#img-").concat(croppedDashText, "\" xlink:title=\"").concat(CroppedText, "\"></a>"));
                                            $_2(text).wrap(link);
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
                        htmlFilesToFix[svgFile.htmlIndex].html = $_2.root().html();
                        ;
                        console.log(prev_1 == htmlFilesToFix[svgFile.htmlIndex].html);
                    }
                    // write the html files in the filesystem
                    for (_d = 0, htmlFilesToFix_1 = htmlFilesToFix; _d < htmlFilesToFix_1.length; _d++) {
                        htmlFile = htmlFilesToFix_1[_d];
                        console.log(htmlFile.route);
                        fs.writeFileSync("".concat(props.outDir, "/").concat(htmlFile.route, "/index.html"), htmlFile.html);
                        $_3 = cheerio.load(htmlFile.html);
                        links = $_3('a[xlink\\:href]');
                        for (_e = 0, links_1 = links; _e < links_1.length; _e++) {
                            link = links_1[_e];
                            console.log($_3(link).attr('xlink:href'));
                        }
                    }
                    $ = cheerio.load('<h2 class="title">Hello world</h2>');
                    prev = $.root().html();
                    $('h2.title').text('Hello there!');
                    $('h2').addClass('welcome');
                    console.log(prev == $.root().html());
                    console.log($.html());
                    return [2 /*return*/];
                });
            });
        }
    };
}
exports["default"] = graphvizSvgFixer;
;
