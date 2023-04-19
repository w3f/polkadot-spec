const injectCss = () => {
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

        const injectCssClasses = () => {
            const div = document.getElementsByClassName("theme-doc-markdown markdown");
            let children = div[0].children;
            if (
                children[0].children[0].tagName === "H1" && 
                children[0].children[0].innerHTML.toLowerCase().includes("glossary")
            ) {
                for (let i = 0; i < children.length; i++) {
                    if (children[i].tagName === "P") {
                        children[i].classList.add("glossary-term");
                    }
                    if (children[i].tagName === "UL") {
                        children[i].classList.add("glossary-definition");
                    }
                }
            }
        };

        let prevPageUrl = "";
        let pageUrl = "";
        
        const runScript = () => {
            pageUrl = window.location.href.split("#")[0];
            if (pageUrl !== prevPageUrl) {
                prevPageUrl = pageUrl;
                setTimeout(injectCssClasses, 500);
            }
        }

        window.addEventListener("load", runScript);
        window.addEventListener('locationchange', runScript);
    };

    return {
      name: 'injectCss',
      injectHtmlTags() {
        return {
          postBodyTags: [{ tagName: 'script', innerHTML: `(${script.toString()})()` }],
        };
      },
    };
  };
  
  export = injectCss;
  