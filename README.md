# Polkadot Protocol Specification and Conformance Tests

[![Specification Publication](https://github.com/w3f/polkadot-spec/workflows/Specification%20Publication/badge.svg)](https://github.com/w3f/polkadot-spec/actions?query=workflow%3A%22Specification+Publication%22)
[![Conformance Testsuite](https://github.com/w3f/polkadot-spec/workflows/Conformance%20Testsuite/badge.svg)](https://github.com/w3f/polkadot-spec/actions?query=workflow%3A%22Conformance+Testsuite%22)

In this repo you will find:

- The official [Polkadot Host Specification](./polkadot-host-spec/)
- The official [Polkadot Conformance Testsuite](./test/)
- Various other files used by the Polkadot spec team

## Polkadot Host Specification

Here your can find the latest version of the [Polkadot Host Specification](./polkadot-host-spec/polkadot_host_spec.pdf)

Please refer to the [Change Log](./polkadot-host-spec/pdre_change_log.org) and [PDF Diff](./polkadot-host-spec/polkadot_host_spec-diffed-updates.pdf) to review the history of changes to the specification.

For more details please refer [README.md](./polkadot-host-spec/README.md) to the specification.

## Polkadot Protocol Conformance Testsuite

The `test/` directory contains tests of different components for the different implementations of the Polkadot protocol.

This ensures that the different implementations behave the same and produce identical output, which is the necessary basis for the interoperability of all Polkadot clients.

For more details plese see the [README.md](./test/README.md) of the testsuite.

## Genesis files

This repository contains genesis parameters for different networks in the `genesis-state/` directory.
- The `alexander` test network
- The `kusama` test network
