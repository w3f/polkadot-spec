module.exports = function () {
    return {
        name: 'docusaurus-plugin',
        injectHtmlTags() {
            return {
                postBodyTags: [`
                    <script>
                        ;(function() {
                            var pushState = history.pushState;
                            var replaceState = history.replaceState;
                        
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

                        const script = () => {
                            const svgList = document.querySelectorAll('svg.graphviz');
                            svgList.forEach(svg => {
                                // remove the path which is svg > g > path
                                const childElement = svg.firstElementChild;
                                const pathTag = childElement.querySelector('path');
                                if (pathTag) {
                                    pathTag.remove();
                                }
                            
                                // adjust the viewbox
                                const { xMin, xMax, yMin, yMax } = [...svg.children].reduce((acc, el) => {
                                    const { x, y, width, height } = el.getBBox();
                                    if (!acc.xMin || x < acc.xMin) acc.xMin = x;
                                    if (!acc.xMax || x + width > acc.xMax) acc.xMax = x + width;
                                    if (!acc.yMin || y < acc.yMin) acc.yMin = y;
                                    if (!acc.yMax || y + height > acc.yMax) acc.yMax = y + height;
                                    return acc;
                                }, {});

                                const a = xMin;
                                const b = yMin;
                                const c = xMax - xMin;
                                const d = yMax - yMin;

                                const viewbox = a + " " + b + " " + c + " " + d;
                            
                                svg.setAttribute('viewBox', viewbox);
                            });
                        }

                        let prevPageUrl = "";

                        window.addEventListener("load", (event) => {
                            prevPageUrl = window.location.href.split("#")[0];
                            script();
                        });
                        
                        window.addEventListener('locationchange', function(){
                            let pageUrl = window.location.href.split("#")[0];
                            if (pageUrl !== prevPageUrl) {
                                setTimeout(script, 1000);
                                prevPageUrl = pageUrl;
                            }
                        })
                    </script>`
                ],
            };
        },
    };
};
