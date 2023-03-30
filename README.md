# Website

This website is built using [Docusaurus 2](https://docusaurus.io/), a modern static website generator.

### Local Development

```bash
npm i
npm run build_no_kaitai # or just build to also rebuild kaitai SVG files
npm run serve
```

This command starts a local development server and opens up a browser window. Most changes are reflected live without having to restart the server.

**NOTE**: To see the results of the plugins, for now you need to clean the `/build/assets/js` folder after the build.

### Build

```
$ yarn build
```

This command generates static content into the `build` directory and can be served using any static contents hosting service.

### Deployment

Using SSH:

```
$ USE_SSH=true yarn deploy
```

Not using SSH:

```
$ GIT_USER=<Your GitHub username> yarn deploy
```

If you are using GitHub pages for hosting, this command is a convenient way to build the website and push to the `gh-pages` branch.
