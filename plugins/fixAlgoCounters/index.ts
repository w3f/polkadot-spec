import safePluginExecution from "../safePluginExecution";

const fixAlgoCounters = () => {
  const timeoutMs = 500;

  const script = () => {
    const spans = document.getElementsByClassName("ps-keyword");
    for (let i = 0; i < spans.length; i++) {
      const span = spans[i];
      let text = span.innerHTML;
      const regex = /(\d+)/g;
      text = text.replace(regex, '');
      span.innerHTML = text;
    }
  };

  return {
    name: 'fixAlgoCounters',
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

export = fixAlgoCounters;
