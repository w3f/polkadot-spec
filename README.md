# Polkadot Protocol Specification

[![License](https://img.shields.io/github/license/w3f/polkadot-spec.svg)](https://github.com/w3f/polkadot-spec/blob/main/LICENSE)
[![Latest Release](https://img.shields.io/github/release/w3f/polkadot-spec.svg)](https://github.com/w3f/polkadot-spec/releases/latest)
[![Specification Publication](https://github.com/w3f/polkadot-spec/actions/workflows/asciidoctor.deb.yml/badge.svg)](https://github.com/w3f/polkadot-spec/actions/workflows/asciidoctor.deb.yml)
[![Cachix Cache](https://img.shields.io/badge/cachix-w3fpkgs-blue.svg)](https://w3fpkgs.cachix.org)
[![Nix Integration](https://github.com/w3f/polkadot-spec/actions/workflows/asciidoctor.nix.yml/badge.svg)](https://github.com/w3f/polkadot-spec/actions/workflows/asciidoctor.nix.yml)

Polkadot is a replicated sharded state machine designed to resolve the scalability and interoperability among blockchains. This repository contains the official specification for the Polkadot Protocol.
 
The latest releases of the *Polkadot Protocol Specification* can be found on [spec.polkadot.network](https://spec.polkadot.network) or on our [GitHub Releases page](https://github.com/w3f/polkadot-spec/releases).

The Polkadot specification is written in [AsciiDoc](https://docs.asciidoctor.org/asciidoc/latest) and currently compiled with [Asciidoctor](https://asciidoctor.org/).

## Contributing

Contributions are always welcome. For a quick primer on the AsciiDoc format, we recommend the [AsciiDoc Writers Guide](https://asciidoctor.org/docs/asciidoc-writers-guide).

## Dependencies

A handful of dependencies are required to successfully convert the spec into a publishable document. We provide a `Gemfile` that provides most dependecies. 

You will have to install `bundler` to use the `Gemfile`. On a Debian based system, it can be installed with:

```bash
sudo apt-get install ruby-dev
# On some systems this might be required
gem install bundler
```

Furthermore you will also need to have `graphviz` and the `kaitai-struct-compiler` installed.

Once `bundler` is available, you can install any missing dependencies for a html build via `bundle install`:

```bash
bundle install
```

To also install the dependencies needed for a pdf build, add the `--with pdf` flag: 

```bash
bundle install --with pdf
```

The pdf build requires various native dependencies to convert math to images with  `asciidoctor-mathematical`, please check the [official documentation](https://github.com/asciidoctor/asciidoctor-mathematical#installation=) for further details. Furthermore, the PDF is cleanup and compressed with `ghostscript`, so this will need to be installed as well.

## Build

To build the html version of the spec, just run `bundle exec make html`. This create will create a `polkadot-spec.html` in the same folder.

To build the pdf version of the spec, just run `bundle exec make pdf`, which will create a `polkadot-spec.pdf` in the same folder.

To export the Kaitai Struct definitions contained in the spec, just run `bundle exec make kaitai`, which will create the `.ksy` file(s) in the same folder.

We also provide full nix flake integration, e.g. you can run `nix build github:w3f/polkadot-spec` to build the latest html release.

## Test

To test some of the machine readable definition in the spec, just run `bundle exec make test`.

The test requires `curl`, `jq` and `xxd` to download required data via JSON RPC.
