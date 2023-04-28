const redirectOldLinks = () => {
  const script = () => {
    const filePath = '/entitiesMap.json';
    const websiteBaseUrl = 'https://spec.polkadot.network/';
    fetch(filePath).then((response) => 
        response.text().then((text) => {
            const entitiesMap = JSON.parse(text);
            const url = window.location.href;
            if (url.startsWith(`${websiteBaseUrl}#`)) {
                let id = url.split("#")[1];
                let routeId = entitiesMap[id];
                if (routeId) {
                    window.location.replace(`${websiteBaseUrl}${routeId}#${id}`);
                }
            }
        })
    );
  };

  return {
    name: 'redirectOldLinks',
    injectHtmlTags() {
      return {
        postBodyTags: [{
          tagName: 'script',
          innerHTML: `
            (${script.toString()})()
          `
        }],
      };
    },
  };
};

export = redirectOldLinks;
