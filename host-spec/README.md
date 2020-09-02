# Polkadot Host Specification

Here your can find the latest version of the ![Polkadot Host Specification](./polkadot-host-spec.pdf)

Please refer to the ![Change log](./CHANGELOG.org) to review the history of changes to the host specifiaction in the past.

Official releases of the specification can be found in [the release section](https://github.com/w3f/polkadot-spec/releases) of this repository.

## Editing

The specification is edited with [TeXmacs](https://www.texmacs.org/) with an additional style package `algorithmacs-style.ts` (from https://github.com/w3f/algorithmacs) that must be copied or
linked to your personal style package directory `$HOME/.TeXmacs/packages`.

Any other formats, like the `.tex` and `.pdf` files are exported from TeXmacs.

## Command line build and diff support

There is a Makefile to simplify the generation of PDFs and diff PDFs. This feature requieres `xvfb` to be installed. To build the `polkadot-host-spec.pdf` just use `make` or `make build`. To generate `polkadot-host-spec.diff.pdf` use `make diff REV=<revision>` where `<revision>` can be any previous revision to which to compare, i.e. a branch, tag or commit.
