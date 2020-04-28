#  Polkadot Protocol Specification and Conformance Tests

![Specification Publication](https://github.com/w3f/polkadot-spec/workflows/Specification%20Publication/badge.svg)
![Specification Testsuite on Ubuntu](https://github.com/w3f/polkadot-spec/workflows/Specification%20Testsuite%20on%20Ubuntu/badge.svg)
![Specification Testsuite on Nix](https://github.com/w3f/polkadot-spec/workflows/Specification%20Testsuite%20on%20Nix/badge.svg)

In this repo you will find:

- Polkadot Runtime Environment Spec
- Specification Conformance Tests for various implementation of Polkadot Runtime Enviornment
- Tests

## Polkadot Runtime Environment Specification

Here your can find the latest version of [Polkadot Runtime Environment Specification](./runtime-environment-spec/polkadot_re_spec.pdf)

Please refer to [Change log](./runtime-environment-spec/pdre_change_log.org) to review the history of changes to the spec.

## Testing

The `test/` directory contains tests for different components from different implementations such as Rust, C++ and Golang:

- SCALE Codec
- State Trie
- Polkadot Host API

This ensures that the different implementations behave the same and produce the identical output. See [test/README.md](./test/README.md) for more.

## Genesis files

This repository contains genesis parameters for different networks in the `genesis-state/` directory.
- The `alexander` test network
- The `kusama` test network
