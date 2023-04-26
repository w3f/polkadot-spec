const fs = require('fs');

const files: string[] = fs.readdirSync('docs')
    .map(file => `docs/${file}`)
    .concat(fs.readdirSync('docs/Support Docs')
        .map(file => `docs/Support Docs/${file}`))
    .filter(file => file.endsWith('.md'));

const links: string[] = files.map(file => {
    let mdContent: string = fs.readFileSync(file, 'utf8');
    const regex: RegExp = /https:\/\/[^\s\])>]+/g;
    const matches: RegExpMatchArray | null = mdContent.match(regex);
    if (matches) {
        return matches;
    }
    return [];
}).flat();

(() => {
    let brokenLinks: string[] = [];
    let count: number = 0;
    links.forEach(link => {
        fetch(link)
            .then(res => {
                if (res.status >= 400) {
                    brokenLinks.push(link);
                }
                count++;
                if (count === links.length) {
                    if (brokenLinks.length > 0) {
                        console.warn('\x1b[31m%s\x1b[0m', '-----------------------------------------');
                        console.warn('\x1b[31m%s\x1b[0m', 'The following external links are broken:');
                        brokenLinks.forEach(link => {
                            console.warn('\x1b[31m%s\x1b[0m', link);
                        });
                        console.warn('\x1b[31m%s\x1b[0m', '-----------------------------------------');
                    }
                    process.exit(0);
                }
            });
    });
})();
