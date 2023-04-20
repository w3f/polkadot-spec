const fixAlgoCounters = () => {
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

        const fixCounters = () => {
            const spans = document.getElementsByClassName("ps-keyword");
            for (let i = 0; i < spans.length; i++) {
                const span = spans[i];
                let text = span.innerHTML;
                const regex = /(\d+)/g;
                text = text.replace(regex, '');
                span.innerHTML = text;
            }
        };

        let prevPageUrl = "";
        let pageUrl = "";
        
        const runScript = () => {
            pageUrl = window.location.href.split("#")[0];
            if (pageUrl !== prevPageUrl) {
                prevPageUrl = pageUrl;
                setTimeout(fixCounters, 500);
            }
        }

        window.addEventListener("load", runScript);
        window.addEventListener('locationchange', runScript);
    };
  
    return {
      name: 'fixAlgoCounters',
      injectHtmlTags() {
        return {
          postBodyTags: [{ tagName: 'script', innerHTML: `(${script.toString()})()` }],
        };
      },
    };
  };
  
  export = fixAlgoCounters;
  