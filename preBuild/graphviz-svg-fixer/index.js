"use strict";
exports.__esModule = true;
var fs = require("fs");
var cheerio = require("cheerio");
var svgPath = "static/img/kaitai_render";
var mdPath = "src/docs";
var graphvizSvgFixer = function () {
    var svgNames = fs.readdirSync(svgPath);
    var mdFileNames = fs.readdirSync(mdPath);
    var svgsMap = {};
    for (var _i = 0, mdFileNames_1 = mdFileNames; _i < mdFileNames_1.length; _i++) {
        var mdFileName = mdFileNames_1[_i];
        var mdFile = fs.readFileSync(mdPath + "/" + mdFileName, "utf8");
        var paths = mdFile.matchAll(new RegExp(svgPath + "/.*.svg", "g"));
        for (var _a = 0, _b = Array.from(paths); _a < _b.length; _a++) {
            var path = _b[_a];
            var svg = path[0].split("/").pop().split(".")[0];
            svgsMap[svg] = mdFileName.split(".")[0];
        }
    }
    var _loop_1 = function (svgName) {
        var svgFile = fs.readFileSync(svgPath + "/" + svgName, "utf8");
        var $ = cheerio.load(svgFile, { xmlMode: true });
        $('svg').each(function (_, svg) {
            $(svg).find('g > g.node').each(function (_, node) {
                if ($(node).children().length == 2) {
                    var text = $(node).find('text');
                    var cropped_text_1 = text.text().split('__')[0];
                    var cropped_text_array = cropped_text_1.split('_');
                    var CroppedText = '';
                    for (var i = 0; i < cropped_text_array.length; i++) {
                        CroppedText +=
                            cropped_text_array[i].charAt(0).toUpperCase() +
                                cropped_text_array[i].slice(1);
                    }
                    var croppedDashText = cropped_text_1.replace(/_/g, '-');
                    if (svgsMap[cropped_text_1] != undefined) {
                        var externalLink = "\n              <a \n                xlink:href=\"".concat(svgsMap[cropped_text_1], "#img-").concat(croppedDashText, "\" \n                xlink:title=\"").concat(CroppedText, "\"\n              >\n                ").concat(CroppedText, "\n              </a>\n            ");
                        text.html(externalLink);
                    }
                    else {
                        // delete the node
                        $(node).remove();
                        // delete the associated edges
                        $(svg).find('g > g.edge').each(function (_, edge) {
                            if ($(edge).find('title').text().includes(cropped_text_1)) {
                                $(edge).remove();
                            }
                        });
                    }
                }
            });
        });
        fs.writeFileSync(svgPath + "/" + svgName, $.html());
    };
    // now edit all the svg files as we did in the commented fuction
    for (var _c = 0, svgNames_1 = svgNames; _c < svgNames_1.length; _c++) {
        var svgName = svgNames_1[_c];
        _loop_1(svgName);
    }
};
graphvizSvgFixer();
