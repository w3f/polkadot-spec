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
                var blacklist, routes, htmlFilesToFix, allSvgFiles, _i, routes_1, route, filePath, html, htmlFile;
                return __generator(this, function (_a) {
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
                    (function () {
                        return __awaiter(this, void 0, void 0, function () {
                            var _i, htmlFilesToFix_1, htmlFile, html, $, prev, next;
                            return __generator(this, function (_a) {
                                for (_i = 0, htmlFilesToFix_1 = htmlFilesToFix; _i < htmlFilesToFix_1.length; _i++) {
                                    htmlFile = htmlFilesToFix_1[_i];
                                    html = fs.readFileSync("".concat(props.outDir, "/").concat(htmlFile.route, "/index.html"));
                                    $ = cheerio.load(html);
                                    prev = $.html();
                                    $('svg.graphviz').remove();
                                    next = $.html();
                                    console.log(prev == next);
                                    fs.writeFileSync("".concat(props.outDir, "/").concat(htmlFile.route, "/index.html"), $.html());
                                }
                                return [2 /*return*/];
                            });
                        });
                    })();
                    return [2 /*return*/];
                });
            });
        }
    };
}
exports["default"] = graphvizSvgFixer;
;
