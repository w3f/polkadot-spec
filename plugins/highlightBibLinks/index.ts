import safePluginExecution from "../safePluginExecution";

const highlightBibLinks = () => {
  const timeoutMs = 500;

  const script = () => {
    const divs = document.getElementsByClassName("csl-right-inline");
    for (let i = 0; i < divs.length; i++) {
      const div = divs[i];
      let text = div.innerHTML;
      const regex = /(?<!href="|<a href=")(https?:\/\/[^\s]+)(?<!:)/g;
      text = text.replace(regex, '<a href="$1" target="_blank">$1</a>');
      div.innerHTML = text;
    }
  };

  return {
    name: 'highlightBibLinks',
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

export = highlightBibLinks;
