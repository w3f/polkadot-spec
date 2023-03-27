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
var fixSvgDimensions = function ($, html) {
    // remove the path
    // now resize the svg viewbox
};
function graphvizSvgFixer(context) {
    return {
        name: 'graphviz-svg-fixer',
        postBuild: function (props) {
            return __awaiter(this, void 0, void 0, function () {
                var blacklist, routes, htmlFilesToFix, svgsMap, _i, routes_1, route, filePath, html, htmlFile, htmlIndex, htmlFile, $, svgElements, _a, svgElements_1, svgElement, cluster, clusterTitle, _loop_1, _b, htmlFilesToFix_1, htmlFile;
                return __generator(this, function (_c) {
                    blacklist = [
                        '/404.html',
                        '/',
                    ];
                    routes = props.routesPaths.filter(function (route) {
                        return !blacklist.includes(route) &&
                            !route.startsWith('/__docusaurus');
                    });
                    htmlFilesToFix = [];
                    svgsMap = [];
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
                        $ = cheerio.load(htmlFile.html);
                        svgElements = $('svg.graphviz');
                        for (_a = 0, svgElements_1 = svgElements; _a < svgElements_1.length; _a++) {
                            svgElement = svgElements_1[_a];
                            cluster = $(svgElement).find('g > g.cluster')[0];
                            clusterTitle = $(cluster).find('title').text().split("__")[1];
                            svgsMap[clusterTitle] = htmlFile.route;
                        }
                        htmlIndex++;
                    }
                    _loop_1 = function (htmlFile) {
                        var $ = cheerio.load(htmlFile.html);
                        // take all the svgs with selector
                        $('svg.graphviz').each(function (index, svg) {
                            // take all the g > g.node with at max 2 children
                            $(svg).find('g > g.node').each(function (index, node) {
                                if ($(node).children().length == 2) {
                                    var text = $(node).find('text');
                                    var cropped_text_1 = text.text().split('__')[0];
                                    var cropped_text_array = cropped_text_1.split('_');
                                    var CroppedText = '';
                                    for (var i = 0; i < cropped_text_array.length; i++) {
                                        CroppedText += cropped_text_array[i].charAt(0).toUpperCase() + cropped_text_array[i].slice(1);
                                    }
                                    var croppedDashText = cropped_text_1.replace(/_/g, '-');
                                    if (svgsMap[cropped_text_1] != undefined) {
                                        var externalLink = "\n                  <a xlink:href=\"".concat(svgsMap[cropped_text_1], ".html#img-").concat(croppedDashText, "\" xlink:title=\"").concat(CroppedText, "\">\n                    ").concat(CroppedText, "\n                  </a>\n                ");
                                        text.html(externalLink);
                                    }
                                    else {
                                        // delete the node
                                        $(node).remove();
                                        // delete the associated edges
                                        $(svg).find('g > g.edge').each(function (index, edge) {
                                            if ($(edge).find('title').text().includes(cropped_text_1)) {
                                                $(edge).remove();
                                            }
                                        });
                                    }
                                }
                            });
                            fixSvgDimensions($, svg);
                        });
                        // remove the path from the svg
                        $('svg > g > path').remove();
                        // adjust the viewbox for all the svg.graphviz
                        // the new one has to fit the dimensions of the svg > g.graph
                        var svgList = $('svg.graphviz');
                        for (var _d = 0, svgList_1 = svgList; _d < svgList_1.length; _d++) {
                            var svg = svgList_1[_d];
                            var _e = Array.from(svg.children).reduce(function (acc, el) {
                                var bbox = el.getBBox();
                                if (!acc.xMin || bbox.x < acc.xMin)
                                    acc.xMin = bbox.x;
                                if (!acc.xMax || bbox.x + bbox.width > acc.xMax)
                                    acc.xMax = bbox.x + bbox.width;
                                if (!acc.yMin || bbox.y < acc.yMin)
                                    acc.yMin = bbox.y;
                                if (!acc.yMax || bbox.y + bbox.height > acc.yMax)
                                    acc.yMax = bbox.y + bbox.height;
                                return acc;
                            }, {}), xMin = _e.xMin, xMax = _e.xMax, yMin = _e.yMin, yMax = _e.yMax;
                            var viewBox = "".concat(xMin, " ").concat(yMin, " ").concat(xMax - xMin, " ").concat(yMax - yMin);
                            $(svg).attr('viewBox', viewBox);
                        }
                        fs.writeFileSync("".concat(props.outDir, "/").concat(htmlFile.route, "/index.html"), $.html());
                    };
                    // for each html file
                    for (_b = 0, htmlFilesToFix_1 = htmlFilesToFix; _b < htmlFilesToFix_1.length; _b++) {
                        htmlFile = htmlFilesToFix_1[_b];
                        _loop_1(htmlFile);
                    }
                    return [2 /*return*/];
                });
            });
        }
    };
}
exports["default"] = graphvizSvgFixer;
;
