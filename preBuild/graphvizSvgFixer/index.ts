import * as fs from 'fs';
import * as cheerio from 'cheerio';
const svgPath = "static/img/kaitai_render"
const mdPath = "src/docs"

const graphvizSvgFixer = () => {
  let svgNames = fs.readdirSync(svgPath);
  let mdFileNames = fs.readdirSync(mdPath);
  let svgsMap: any = {};

  for (let mdFileName of mdFileNames) {
    let mdFile = fs.readFileSync(mdPath + "/" + mdFileName, "utf8");
    let paths = mdFile.matchAll(new RegExp(svgPath + "/.*.svg", "g"));
    for (let path of Array.from(paths)) {
      let svg = path[0].split("/").pop().split(".")[0];
      svgsMap[svg] = mdFileName.split(".")[0];
    }
  }

  // now edit all the svg files as we did in the commented fuction
  for (let svgName of svgNames) {
    let svgFile = fs.readFileSync(svgPath + "/" + svgName, "utf8");
    const $ = cheerio.load(svgFile, { xmlMode: true });
    $('svg').each((_, svg) => {
      $(svg).find('g > g.node').each((_, node) => {
        if ($(node).children().length == 2) {
          let text = $(node).find('text');
          let cropped_text = text.text().split('__')[0];
          let cropped_text_array = cropped_text.split('_');
          let CroppedText = '';
          for (let i = 0; i < cropped_text_array.length; i++) {
            CroppedText += 
              cropped_text_array[i].charAt(0).toUpperCase() +
              cropped_text_array[i].slice(1);
          }
          const croppedDashText = cropped_text.replace(/_/g, '-');
          if (svgsMap[cropped_text] != undefined) {
            let externalLink = `
              <a 
                xlink:href="${svgsMap[cropped_text]}#img-${croppedDashText}" 
                xlink:title="${CroppedText}"
              >
                ${CroppedText}
              </a>
            `;
            text.html(externalLink);
          } else {
            // delete the node
            $(node).remove();
            // delete the associated edges
            $(svg).find('g > g.edge').each((_, edge) => {
              if ($(edge).find('title').text().includes(cropped_text)) {
                $(edge).remove();
              }
            });
          }
        }
      });
      
      let svgString = $.html(svg);
      // replace transparent background with white
      svgString = svgString.replace(
        /fill="none" stroke="black" stroke-dasharray="1,5"/g,
        'fill="white" stroke="black" stroke-dasharray="1,5"'
      );
      // replace green headings background with pink
      svgString = svgString.replace(/#e0ffe0/g, '#e6007a4f');
      svgString = svgString.replace(/#f0f2e4/g, '#e6007a4f');
      $(svg).replaceWith(svgString);
    });
    fs.writeFileSync(svgPath + "/" + svgName, $.html());
  }
}

graphvizSvgFixer();