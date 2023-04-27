const redirectOldLinks = () => {
  const script = () => {
    const filePath = '/h6EntitiesMap.json';
    fetch(filePath).then((response) => 
        response.text().then((text) => {
            const h6EntitiesMap = JSON.parse(text);
            const url = window.location.href;
            if (url.startsWith("https://spec.polkadot.network/#")) {
                let id = url.split("#")[1];
                let routeId = h6EntitiesMap[id];
                if (routeId) {
                    window.location.replace(`https://spec.polkadot.network/${routeId}#${id}`);
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
