// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');
const math = require('remark-math');
const katex = require('rehype-katex');
const path = require('path');

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Polkadot Protocol Specification',
  tagline: 'The Polkadot Protocol Specification',
  favicon: 'img/polkadot-logo.png',

  // Set the production url of your site here
  url: 'https://your-docusaurus-test-site.com',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '/',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'Polkadot', // Usually your GitHub org/user name.
  projectName: 'docusaurus', // Usually your repo name.

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  // Even if you don't use internalization, you can use this field to set useful
  // metadata like html lang. For example, if your site is Chinese, you may want
  // to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  plugins: [
    path.resolve(__dirname, 'plugins', 'resizeSvg', 'index.js'),
  ],

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          remarkPlugins: [math],
          rehypePlugins: [katex],
          sidebarPath: require.resolve('./sidebars.js'),
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl:
            'https://github.com/0xCaso/polkadot-spec/blob/main//src',
          routeBasePath: '/', // Serve the docs at the site's root
          admonitions: {
            tag: ':::',
            keywords: ['definition'],
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
      // Replace with your project's social card
      image: 'img/docusaurus-social-card.jpg',
      docs: {
        sidebar: {
          hideable: true,
        },
      },
      navbar: {
        title: 'Polkadot Protocol Specification',
        logo: {
          alt: 'Polkadot Logo',
          src: 'img/polkadot-logo.png',
        },
        items: [
          {
            href: 'https://github.com/w3f/polkadot-spec',
            label: 'GitHub',
            position: 'right',
          },
        ],
      },
      footer: {
        copyright: `© ${new Date().getFullYear()} Web3 Foundation`,
        logo: {
          src: "img/Polkadot_Logo_Horizontal_White.svg",
        },
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
    }),
};

module.exports = config;
