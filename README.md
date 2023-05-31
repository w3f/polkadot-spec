# Polkadot Protocol Specification

Polkadot is a replicated sharded state machine designed to resolve the scalability and interoperability among blockchains. This repository contains the official specification for the Polkadot Protocol.
 
The latest releases of the *Polkadot Protocol Specification* can be found on [spec.polkadot.network](https://spec.polkadot.network) or on our [GitHub Releases page](https://github.com/w3f/polkadot-spec/releases).

This website is built using [Docusaurus 2](https://docusaurus.io/), a modern static website generator.

## Local Development

```bash
npm i
npm run build # or build_with_kaitai to also rebuild kaitai SVG files
npm run serve
```

This command starts a local development server and opens up a browser window. Most changes are reflected live without having to restart the server.

## Contributing

You can find the markdown files inside the [`src/docs`](src/docs) folder.

When building, the scripts inside [`preBuild`](preBuild) will generate a `docs` folder, from which Docusaurus will render the website. Then, the rendered content will be modified by the [`plugins`](plugins) in the browser.

### LaTeX

You can use LaTeX inside the markdown files using the following syntax:
```md
$ LaTeX here $
```
or
```md
$$
LaTeX here 
$$
```

### Numeration System

Inside [`preBuild`](preBuild), you can find the script [`numerationSystem`](preBuild/numerationSystem/index.ts). This will assign to several entities a number and substitute the placeholders inside the markdown files. This is done to avoid having to manually update the numbers when adding new entities.

This is the structure of the spec:
```md
- Macro Chapter X
    1. Chapter A
        - Section 1.1
            ... subsections
        - Section 1.2
    2. Chapter B
        - Section 2.1
            ... subsections
        - Section 2.2
- Macro Chapter Y
    etc.
```
Example:
```md
- Polkadot Host
    1. Overview
        1.1 Light Client
        ...
    2. State and Transitions
        ...
```

The entities involved are:
- Chapters
- Sections
- Definitions
- Algorithms
- Tables
- Images

Those defined as "Macro Chapters" will not be numbered.

#### Chapters
To write a new chapter, use the following syntax:
```md
---
title: -chap-num- Chapter Title
---
<!-- Chapter content here -->
```
The placeholder `-chap-num-` will be replaced by the number assigned by [`numerationSystem`](preBuild/numerationSystem/index.ts).

If you add a chapter (or "Macro Chapter"), you must also add it to the [`sidebars.js`](sidebars.js) file and adjust the numbers of the other chapters.

#### Sections
To write a new section, use the following syntax:
```md
## -sec-num- Section name {#id-section-name}
```
- Use a markdown header from H2 to H5 included, so the maximum depth is `a.b.c.d.e` (H2 is `a.b`).
- Put the placeholder `-sec-num-` in the header, which will be replaced;
- Add an id to the header, which will be used to reference the section.

#### Definitions

To write a definition:
```md
###### Definition -def-num- Runtime Pointer {#defn-runtime-pointer}
```
- Use a markdown H6 header (######);
- Put the placeholder `-def-num-` in the header;
- Add an id to the header.

Then, you should include the definition content inside the custom admonition `:::definition` (you can find all the custom admonitions inside [`src/theme/Admonition/Types.js`](src/theme/Admonition/Types.js)).

So the final result will be the following:
```md
###### Definition -def-num- Runtime Pointer {#defn-runtime-pointer}
:::definition <!-- Open admonition -->

Definition content here

::: <!-- Close admonition -->
```

#### Algorithms

To define an algorithm, use the same syntax as for definitions but with the placeholder `-algo-num-`:
```md
###### Algorithm -algo-num- Aggregate-Key {#algo-aggregate-key}
```
At the top of the page, you must include the [`Pseudocode`](src/components/Pseudocode.jsx) component and the LaTeX algorithm you want to render:
```md
---
title: -chap-num- States and Transitions
---
import Pseudocode from '@site/src/components/Pseudocode';
import aggregateKey from '!!raw-loader!@site/src/algorithms/aggregateKey.tex';
```
After this, you can build the algorithm using the admonition `:::algorithm`, and using the [`Pseudocode`](src/components/Pseudocode.jsx) component (refer to the file to know more about its `props`). This will be the final result:
```md
---
title: -chap-num- States and Transitions
---
import Pseudocode from '@site/src/components/Pseudocode';
import aggregateKey from '!!raw-loader!@site/src/algorithms/aggregateKey.tex';

<!-- Page content here -->

###### Algorithm -algo-num- Aggregate-Key {#algo-aggregate-key}
:::algorithm
<Pseudocode
    content={aggregateKey}
    algID="aggregateKey"
    options={{ "lineNumber": true }}
/>

<!-- Algorithm description here -->
:::
```

#### Tables and Images

To define a table or an image, use the same syntax as for definitions and algorithms (always using an H6 header) but with the placeholder `-tab-num-` or `-img-num-`:
```md
###### Table -tab-num- Name {#tab-name}
```
or
```md
###### Image -img-num- Name {#img-name}
```
For these two entities you won't need to use any component or admonition.

#### References

To reference any of the entities from anywhere in the website, you have to use the following syntax:
```md
[Entity -xxx-num-ref-](entity-page#entity-id)
```
- Use a markdown link;
- Put the placeholder `-xxx-num-ref-` in the text link, which will be replaced (`xxx` depends on the entity, for example `-def-num-ref-` for definitions);
- The link should point to the header id of the definition, with the page name as a prefix (if entity-page.md is a page, ".md" must be omitted).

### Bibliography

The cited works are defined inside [`src/bibliography.bib`](src/bibliography.bib). To cite a work, use the following syntax:
```md
[@work-id]
```
Automatically, the bibliography will be generated at the end of the page.

### Broken Links

During the `preBuild`, the external links in the markdown files will be checked.<br/>
After the `build`, the internal links will be checked.<br/>
If any link is broken, the console will show a warning.<br/>

Refer to [`checkBrokenInternalLinks/index.ts`](plugins/checkBrokenInternalLinks/index.ts) and [`checkBrokenExternalLinks/index.ts`](preBuild/checkBrokenExternalLinks/index.ts).

## License

Any code in this repository is licensed under the [GPL 3.0](https://www.gnu.org/licenses/gpl-3.0.en.html), and any documentation or specification is licensed under the [CC BY-SA 2.0](https://creativecommons.org/licenses/by-sa/2.0/).