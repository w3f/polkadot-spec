import safePluginExecution from "../safePluginExecution";

const resizeSvg = () => {
  const timeoutMs = 500;

  const script = () => {
    const svgList = document.querySelectorAll('svg.graphviz');
    svgList.forEach(svg => {
      if (svg.classList.contains('fixed')) return;
      // remove the path which is svg > g > path
      const childElement = svg.firstElementChild;
      const pathTag = childElement.querySelector('path');
      if (pathTag) {
        pathTag.remove();
      }

      // adjust the viewbox
      const { xMin, xMax, yMin, yMax } = Array.from(svg.children).reduce(
        (acc, el) => {
          const { x, y, width, height } = (el as any).getBBox();
          if (!acc.xMin || x < acc.xMin) acc.xMin = x;
          if (!acc.xMax || x + width > acc.xMax) acc.xMax = x + width;
          if (!acc.yMin || y < acc.yMin) acc.yMin = y;
          if (!acc.yMax || y + height > acc.yMax) acc.yMax = y + height;
          return acc;
        },
        { xMin: 0, xMax: 0, yMin: 0, yMax: 0 } as { xMin: number, xMax: number, yMin: number, yMax: number }
      );


      const viewbox = `${xMin} ${yMin} ${xMax - xMin} ${yMax - yMin}`;

      svg.setAttribute('viewBox', viewbox);
      svg.classList.add('fixed');
    });
  }

  return {
    name: 'resizeSvg',
    injectHtmlTags() {
      return {
        postBodyTags: [{
          tagName: 'script',
          innerHTML: `
						(${safePluginExecution.toString()})(${script.toString()}, ${timeoutMs})
					`
        }],
      };
    },
  };
};

export = resizeSvg;
