const fs = require('fs');

const checkBrokenInternalLinks = () => {
  return {
    name: 'checkBrokenInternalLinks',
    async postBuild({routesPaths = [], outDir}) {
        let brokenLinks = [];
        routesPaths.map((route) => {
            let ignoreRoutes = ['404.html', '__docusaurus', 'search'];
            if (route === '/' || ignoreRoutes.some((ignoreRoute) => route.includes(ignoreRoute))) return;
            let htmlFile = fs.readFileSync(`${outDir}${route}.html`, 'utf8');
            let aTags = htmlFile.match(/<a[^>]*>([^<]+)<\/a>/g);
            if (aTags) {
                aTags.map((aTag) => {
                    if (aTag.includes('undefined')) {
                        brokenLinks.push({
                            route,
                            aTag,
                        });
                    }
                });
            }
        });
        if (brokenLinks.length > 0) {
            console.warn('\x1b[31m%s\x1b[0m', '-----------------------------------------');
            console.warn(`\x1b[31m%s\x1b[0m`, `The following internal links are broken:`);
            brokenLinks.map((brokenLink) => {
                console.warn(`\x1b[31m%s\x1b[0m`, `${brokenLink.route} | ${brokenLink.aTag}`);
            });
            console.warn('\x1b[31m%s\x1b[0m', '-----------------------------------------');
        }
      },
  };
};

export = checkBrokenInternalLinks;
