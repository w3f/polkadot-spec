# Polkadot Protocol Specification

[![License](https://img.shields.io/github/license/w3f/polkadot-spec.svg)](https://github.com/w3f/polkadot-spec/blob/main/LICENSE)
[![Latest Release](https://img.shields.io/github/release/w3f/polkadot-spec.svg)](https://github.com/w3f/polkadot-spec/releases/latest)
[![Continues Integration](https://github.com/w3f/polkadot-spec/workflows/Specification%20Publication/badge.svg)](https://github.com/w3f/polkadot-spec/actions?query=workflow%3A%22Specification+Publication%22)

Polkadot is a replicated sharded state machine designed to resolve the scalability and interoperability among blockchains. This repository contains the official specification for the Polkadot Protocol.
 
## Polkadot Host and Runtime Specification

The latest releases of the *Polkadot Host and Runtime Specification* can be found on our [GitHub Releases page](https://github.com/w3f/polkadot-spec/releases).

## Dependencies

The Polkadot specification is written in [Asciidoctor](https://asciidoctor.org/).
A handful of dependencies are required to successfully generate a final release,
depending on the desired target.

### Ruby

```bash
sudo apt-get install rubygems
sudo apt-get install ruby-dev
```

### AsciiDoctor

```bash
sudo gem install asciidoctor
# Optional: for multi-page HTML generation (recommended)
sudo gem install asciidoctor-multipage
# Optional: for PDF generation
sudo gem install asciidoctor-pdf
sudo gem install asciidoctor-mathematical
```

## Build

Generate the final HTML page(s) or PDF file.

### HTML

#### Multi-Page (recommended)

```bash
asciidoctor -r asciidoctor-multipage -b multipage_html5 -D out main.adoc
```

Where the resulting HTML pages can then be found in the `out/` directory.

#### Single-Page

```bash
asciidoctor main.adoc
```

### PDF (with math formulas enabled)

```bash
asciidoctor-pdf -r asciidoctor-mathematical -a mathematical-format=svg main.adoc
````
