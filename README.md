# Polkadot Protocol Specification

[![License](https://img.shields.io/github/license/w3f/polkadot-spec.svg)](https://github.com/w3f/polkadot-spec/blob/main/LICENSE)
[![Latest Release](https://img.shields.io/github/release/w3f/polkadot-spec.svg)](https://github.com/w3f/polkadot-spec/releases/latest)
[![Specification Publication](https://github.com/w3f/polkadot-spec/actions/workflows/asciidoctor.deb.yml/badge.svg)](https://github.com/w3f/polkadot-spec/actions/workflows/asciidoctor.deb.yml)
[![Cachix Cache](https://img.shields.io/badge/cachix-w3fpkgs-blue.svg)](https://w3fpkgs.cachix.org)
[![Nix Integration](https://github.com/w3f/polkadot-spec/actions/workflows/asciidoctor.nix.yml/badge.svg)](https://github.com/w3f/polkadot-spec/actions/workflows/asciidoctor.nix.yml)

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
asciidoctor-multipage -a docinfo=shared-header -D out index.adoc
```

Where the resulting HTML pages can then be found in the `out/` directory.

#### Single-Page

```bash
asciidoctor -a docinfo=shared index.adoc
```

### PDF (with math formulas enabled)

```bash
asciidoctor-pdf -r asciidoctor-mathematical -a mathematical-format=svg index.adoc
````
