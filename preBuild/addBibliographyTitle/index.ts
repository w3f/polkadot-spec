import * as fs from 'fs';
const mdPath = "docs";

const addBibliographyTitle = () => {
    const mdFileNames = fs.readdirSync(mdPath).filter((fileName) => {
        return !fs.statSync(mdPath + "/" + fileName).isDirectory();
    });
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