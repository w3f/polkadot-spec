// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');
const math = require('remark-math');
const katex = require('rehype-katex');
const path = require('path');

// /** @type {import('@docusaurus/types').Config} */
async function createConfig() {
  const citation = (await import('rehype-citation')).default;
  return {
    title: 'Polkadot Protocol Specification',
    tagline: 'Enabling Implementers - Version 0.2.1',
    favicon: 'img/polkadot-logo.png',
    url: 'https://spec.polkadot.network/',
    baseUrl: '/',
    organizationName: 'w3f', // Usually your GitHub org/user name.
    projectName: 'polkadot-spec', // Usually your repo name.
    onBrokenLinks: 'throw',
    onBrokenMarkdownLinks: 'warn',
    trailingSlash: false,
    
    i18n: {
      defaultLocale: 'en',
      locales: ['en'],
    },

    plugins: [
      path.resolve(__dirname, 'plugins', 'addLocationChangeEvent', 'index.js'),
      path.resolve(__dirname, 'plugins', 'resizeSvg', 'index.js'),
      path.resolve(__dirname, 'plugins', 'highlightBibLinks', 'index.js'),
      path.resolve(__dirname, 'plugins', 'injectGlossaryCss', 'index.js'),
      path.resolve(__dirname, 'plugins', 'fixAlgoCounters', 'index.js'),
      path.resolve(__dirname, 'plugins', 'checkBrokenInternalLinks', 'index.js'),
      path.resolve(__dirname, 'plugins', 'redirectOldLinks', 'index.js'),
      path.resolve(__dirname, 'plugins', 'navbarActiveItem', 'index.js'),
    ],

    presets: [
      [
        'classic',
        /** @type {import('@docusaurus/preset-classic').Options} */
        ({
          docs: {
            remarkPlugins: [math],
            rehypePlugins: [katex, [citation, {
              "bibliography": "./src/bibliography.bib",
              "linkCitations": true,
              "csl": "vancouver"
            }]],
            sidebarPath: require.resolve('./sidebars.js'),
            // Please change this to your repo.
            // Remove this to remove the "edit this page" links.
            editUrl:
              'https://github.com/w3f/polkadot-spec/blob/main/src',
            routeBasePath: '/', // Serve the docs at the site's root
            admonitions: {
              tag: ':::',
              keywords: ['definition', 'algorithm'],
              extendDefaults: true,
            },
          },
          blog: false, // Optional: disable the blog plugin
          theme: {
            customCss: [
              require.resolve("./src/css/custom.css"),
              require.resolve("./src/css/socicon.css"),
            ],
          },
          debug: true,
        }),
      ],
    ],

    stylesheets: [
      {
        href: 'https://cdn.jsdelivr.net/npm/katex@0.13.24/dist/katex.min.css',
        type: 'text/css',
        integrity:
          'sha384-odtC+0UGzzFL/6PNoE8rX/SPcQDXBJ+uRepguP4QkPCm2LBxH3FA3y+fKSiJ+AmM',
        crossorigin: 'anonymous',
      },
      {
        href: "https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css",
      },
      {
        href: "https://cdn.jsdelivr.net/npm/pseudocode@latest/build/pseudocode.min.css"
      }
    ],
    
    themeConfig:
      /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
      ({
        docs: {
          // sidebar: {
          //   hideable: true,
          // },
        },
        navbar: {
          logo: {
            alt: 'Polkadot Logo',
            src: 'img/Polkadot_Logo_Horizontal_Pink-Black.svg',
          },
          items: [
            {
              type: 'doc',
              docId: 'part-polkadot-host',
              position: 'right',
              label: 'Host',
            },
            {
              type: 'doc',
              docId: 'part-polkadot-runtime',
              position: 'right',
              label: 'Runtime',
            },
            {
              href: 'https://github.com/w3f/polkadot-spec',
              label: 'GitHub',
              position: 'right',
            },
          ],
        },
        footer: {
          style: 'dark',
          links: [
            {
              title: 'More Info',
              items: [
                {
                  label: 'GitHub',
                  href: 'https://github.com/w3f/polkadot-spec',
                },
                {
                  label: 'Website',
                  href: 'https://web3.foundation/',
                },
                {
                  label: 'Privacy Policy',
                  to: 'Support%20Docs/privacy_policy',
                },
              ],
            }, 
            {
              title: 'Connect',
              items: [
                {
                  label: 'Twitter',
                  href: 'https://twitter.com/Web3foundation',
                },
              ],
            },
          ],
          copyright: `© ${new Date().getFullYear()} Web3 Foundation`,
        },
        prism: {
          theme: lightCodeTheme,
          darkTheme: darkCodeTheme,
          additionalLanguages: ['rust'],
        },
        colorMode: {
          defaultMode: 'light',
          disableSwitch: true,
          respectPrefersColorScheme: false,
        },
        algolia: {
          appId: '59CYO0AR6V',
          apiKey: '5a0d80d51f05e37544a013903fa202a0',
          indexName: 'spec-polkadot',
          contextualSearch: false,
          searchParameters: {},
          searchPagePath: false,
        },
      }),
  };
}

module.exports = createConfig;
