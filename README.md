# Polkadot Protocol Specification

- [Introduction](#introduction)
- [Process](#process)
- [Local Development](#local-development)
- [Formatting](#formatting)
  - [LaTeX](#latex)
  - [Numeration System](#numeration-system)
  - [Chapters](#chapters)
  - [Sections](#sections)
  - [Definitions](#definitions)
  - [Algorithms](#algorithms)
  - [Tables and Images](#tables-and-images)
  - [References](#references) 
  - [Bibliography](#bibliography)
  - [Broken Links](#broken-links)
- [License](#license) 

## Introduction 

This repository contains the official specification for the [Polkadot Protocol](https://polkadot.network/). The latest releases of the *Polkadot Protocol Specification* can be found on [spec.polkadot.network](https://spec.polkadot.network) or our [GitHub Releases page](https://github.com/w3f/polkadot-spec/releases).

## Process

Everyone, but specifically implementers and members of the [Technical Fellowship](https://wiki.polkadot.network/docs/learn-polkadot-opengov#the-technical-fellowship), are welcome to open PRs to this repo and contribute to the specification. A PR is merged as soon as two members of the Spec Committee accept the PR.  

### Spec Committee

The Spec Committee consists of Researchers, Researcher Engineers, and Implementers of the Polkadot Protocol that actively contribute (= opening/contributing to PRs or issues regarding the spec) to the specification. For now and compared to the [Technical Fellowship](https://github.com/polkadot-fellows/manifesto), the Spec Committee's responsibility is clearly defined as maintaining the specification of the protocol. In case of inactivity for three months, members will be removed again. 

Web3 Foundation
- [Bhargav Bhatt](https://github.com/bhargavbh)
- [David Hawig](https://github.com/Noc2)
- [Seyed Lavasani](https://github.com/drskalman)

Quadrivium
- [Kamil Salakhiev](https://github.com/kamilsa)

Smoldot
- [Pierre Krieger](https://github.com/tomaka)

Parity 
- [Fateme Shirazi](https://github.com/FatemeShirazi)

## Local Development

To clone, build and serve the website locally, run the following commands:

```bash
git clone --recurse-submodules https://github.com/w3f/polkadot-spec
cd polkadot-spec
git submodule update --remote
cd website
npm i
npm run build # or build_with_kaitai to also rebuild kaitai SVG files
npm run serve
```

If you already have the repo cloned, remember to update it and the submodule before making any changes:

```bash
git pull
git submodule update --remote
```

Because of the "complex" build, you can't see the changes in real time if you directly edit the `docs` folder. There are two workarounds:
- use a Markdown plugin or editor (e.g., the extension [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one) for VSCode) to see the changes in real time. You won't be able to see the placeholders rendered and other elements, but you'll be able to render the markdown and latex;
  
- build the website the first time, then run `npm run start` instead of `npm run serve,` and edit the files inside the `website/docs` folder. This will allow you to see the changes in real time, but you have to remember to bring the changes inside the `docs` folder before committing. Also, in this way, you can't put the placeholders and other elements inside the markdown files of `website/docs` as they wouldn't be rendered.

You can find the markdown files inside the [`docs`](docs) folder.

When building, the scripts inside [`preBuild`](https://github.com/w3f/polkadot-spec-website/tree/main/preBuild) will generate a `docs` folder, from which Docusaurus will render the website. Then, the rendered content will be modified by the [`plugins`](https://github.com/w3f/polkadot-spec-website/tree/main/plugins) in the browser.

## Formatting 

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

Inside [`preBuild`](https://github.com/w3f/polkadot-spec-website/tree/main/preBuild), you can find the script [`numerationSystem`](https://github.com/w3f/polkadot-spec-website/tree/main/preBuild/numerationSystem/index.ts). This will assign to several entities a number and substitute the placeholders inside the markdown files. This is done to avoid having to manually update the numbers when adding new entities.

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
The placeholder `-chap-num-` will be replaced by the number assigned by [`numerationSystem`](https://github.com/w3f/polkadot-spec-website/tree/main/preBuild/numerationSystem/index.ts).

If you add a chapter (or "Macro Chapter"), you must also add it to the [`sidebars.js`](https://github.com/w3f/polkadot-spec-website/tree/main/sidebars.js) file and adjust the numbers of the other chapters.

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

Then, you should include the definition content inside the custom admonition `:::definition` (you can find all the custom admonitions inside [`src/theme/Admonition/Types.js`](https://github.com/w3f/polkadot-spec-website/tree/main/src/theme/Admonition/Types.js)).

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
At the top of the page, you must include the [`Pseudocode`](https://github.com/w3f/polkadot-spec-website/tree/main/src/components/Pseudocode.jsx) component and the LaTeX algorithm you want to render:
```md
---
title: -chap-num- States and Transitions
---
import Pseudocode from '@site/src/components/Pseudocode';
import aggregateKey from '!!raw-loader!@site/src/algorithms/aggregateKey.tex';
```
After this, you can build the algorithm using the admonition `:::algorithm`, and using the [`Pseudocode`](https://github.com/w3f/polkadot-spec-website/tree/main/src/components/Pseudocode.jsx) component (refer to the file to know more about its `props`). This will be the final result:
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
For these two entities, you won't need to use any component or admonition.

#### References

To reference any of the entities from anywhere in the website, you have to use the following syntax:
```md
[Entity -xxx-num-ref-](entity-page#entity-id)
```
- Use a markdown link;
- Put the placeholder `-xxx-num-ref-` in the text link, which will be replaced (`xxx` depends on the entity, for example `-def-num-ref-` for definitions);
- The link should point to the header id of the definition, with the page name as a prefix (if entity-page.md is a page, ".md" must be omitted).

### Bibliography

The cited works are defined inside [`bibliography.bib`](bibliography.bib). To cite a work, use the following syntax:
```md
[@work-id]
```
Automatically, the bibliography will be generated at the end of the page.

### Broken Links

During the `preBuild,` the external links in the markdown files will be checked.<br/>
After the `build,` the internal links will be checked.<br/>
If any link is broken, the console will show a warning.<br/>

Refer to [`checkBrokenInternalLinks/index.ts`](https://github.com/w3f/polkadot-spec-website/tree/main/plugins/checkBrokenInternalLinks/index.ts) and [`checkBrokenExternalLinks/index.ts`](https://github.com/w3f/polkadot-spec-website/tree/main/preBuild/checkBrokenExternalLinks/index.ts).

## Resources

Docusaurus docs: https://docusaurus.io/docs/category/guides

Kaitai docs: https://doc.kaitai.io/user_guide.html

## License

Any code in this repository is licensed under the [GPL 3.0](https://www.gnu.org/licenses/gpl-3.0.en.html), and any documentation or specification is licensed under the [CC BY-SA 2.0](https://creativecommons.org/licenses/by-sa/2.0/).
