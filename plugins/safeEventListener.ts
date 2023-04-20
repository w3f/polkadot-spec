const safeEventListener = (callback: () => void, timeout_ms: number) => {
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

    let prevPageUrl = "";
    let pageUrl = "";
    
    const runScript = () => {
        pageUrl = window.location.href.split("#")[0];
        if (pageUrl !== prevPageUrl) {
            prevPageUrl = pageUrl;
            setTimeout(callback, timeout_ms);
        }
    }

    window.addEventListener("load", runScript);
    window.addEventListener('locationchange', runScript);
};

export default safeEventListener;
  