const safePluginExecution = (callback: () => void, timeout_ms: number) => {
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
    // this is a custom event created inside the addLocationChangeEvent plugin
    window.addEventListener('locationchange', runScript);
};

export default safePluginExecution;
  