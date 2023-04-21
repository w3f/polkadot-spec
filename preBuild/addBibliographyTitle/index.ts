import * as fs from 'fs';
const mdPath = "src/docs"

export interface HtmlFile {
  route: string;
  html: string;
}

const addBibliographyTitle = () => {
    let mdFileNames = fs.readdirSync(mdPath);
    for (let mdFileName of mdFileNames) {
        let mdFile = fs.readFileSync(mdPath + "/" + mdFileName, "utf8");
        if (mdFile.includes("[@")) {
            const title = "## Bibliography {#bibliography}";
            if (mdFile[mdFile.length - 1] === "\n") {
                mdFile += title;
            }
            else {
                mdFile += "\n" + title;
            }
        }
        fs.writeFileSync(mdPath + "/" + mdFileName, mdFile);
    }
}

addBibliographyTitle();