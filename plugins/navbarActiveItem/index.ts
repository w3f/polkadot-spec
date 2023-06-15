import safePluginExecution from "../safePluginExecution";

const navbarActiveItem = () => {
  const script = () => {
    const breadcrumbs = document.getElementsByClassName('breadcrumbs')[0];
    if (breadcrumbs) {
      const chapter = breadcrumbs.children[1].children[0];
      const chapterSpan = chapter.tagName === 'A' ? chapter.children[0] : chapter;
      const chapterName = chapterSpan.innerHTML;
      const navbar = document.getElementsByClassName('navbar__items--right')[0];
      const links = navbar.querySelectorAll('a[aria-current="page"]');
      const activeLinkClass = 'navbar__link--active';
      links.forEach(link => {
        if (link.innerHTML != chapterName) {
          link.classList.remove(activeLinkClass);
        } else {
          if (!link.classList.contains(activeLinkClass)) {
            link.classList.add(activeLinkClass);
          }
        }
      });
    }
  };

  return {
    name: 'navbarActiveItem',
    injectHtmlTags() {
      return {
        postBodyTags: [{
          tagName: 'script',
          innerHTML: `
            (${safePluginExecution.toString()})(${script.toString()}, ${0})
          `
        }],
      };
    },
  };
};

export = navbarActiveItem;
  