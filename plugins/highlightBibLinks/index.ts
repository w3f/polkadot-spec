const highlightBibLinks = () => {
    const script = () => {
        (function() {
            const pushState = history.pushState;
            const replaceState = history.replaceState;
        
            history.pushState = function() {
                pushState.apply(history, arguments);
                window.dispatchEvent(new Event('pushstate'));
                window.dispatchEvent(new Event('locationchange'));
            };
        
            history.replaceState = function() {
                replaceState.apply(history, arguments);
                window.dispatchEvent(new Event('replacestate'));
                window.dispatchEvent(new Event('locationchange'));
            };
        
            window.addEventListener('popstate', function() {
                window.dispatchEvent(new Event('locationchange'))
            });
        })();

        const transformLinks = () => {
            const divs = document.getElementsByClassName("csl-right-inline");
            for (let i = 0; i < divs.length; i++) {
                const div = divs[i];
                let text = div.innerHTML;
                // find all links https and http that are not already inside a <a> tag or href="..."
                // the link could be https://datatracker.ietf.org/doc/html/rfc7693:, we want to exclude the colon
                const regex = /(?<!href="|<a href=")(https?:\/\/[^\s]+)(?<!:)/g;
                text = text.replace(regex, '<a href="$1" target="_blank">$1</a>');
                div.innerHTML = text;
            }
        };

        let prevPageUrl = "";
        let pageUrl = "";
        
        const runScript = () => {
            pageUrl = window.location.href.split("#")[0];
            if (pageUrl !== prevPageUrl) {
                prevPageUrl = pageUrl;
                setTimeout(transformLinks, 1000);
            }
        }

        window.addEventListener("load", runScript);
        window.addEventListener('locationchange', runScript);
    };
  
    return {
      name: 'linkUrls-plugin',
      injectHtmlTags() {
        return {
          postBodyTags: [{ tagName: 'script', innerHTML: `(${script.toString()})()` }],
        };
      },
    };
  };
  
  export = highlightBibLinks;
  