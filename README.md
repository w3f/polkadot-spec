# Polkadot Protocol Specification and Conformance Tests

[![Specification Publication](https://github.com/w3f/polkadot-spec/workflows/Specification%20Publication/badge.svg)](https://github.com/w3f/polkadot-spec/actions?query=workflow%3A%22Specification+Publication%22)
[![Conformance Testsuite](https://github.com/w3f/polkadot-spec/workflows/Conformance%20Testsuite/badge.svg)](https://github.com/w3f/polkadot-spec/actions?query=workflow%3A%22Conformance+Testsuite%22)
[![Integration Testsuite](https://github.com/w3f/polkadot-spec/workflows/Integration%20Testsuite/badge.svg)](https://github.com/w3f/polkadot-spec/actions?query=workflow%3A%22Integration+Testsuite%22)

Polkadot is a replicated sharded state machine designed to resolve the scalability and interoperability among blockchains. This repository serves as the point of reference for Polkadot Protocol. In this repo you will find:

- The official [Polkadot Host Specification](./host-spec/)
- The official [Polkadot Conformance Testsuite](./test/)
- A florishing [Polkadot Runtime Specification](./runtime-spec/)
- Various other files used by the Polkadot spec team

## Polkadot Host and Runtime Specification

The latest releases of the *Polkadot Host and Runtime Specification* can be found on our [GitHub Releases page](https://github.com/w3f/polkadot-spec/releases).

Each release also includes a PDF "diff" to the previous versions that highlights the history of changes to the specification.

For more details please refer to the respective *README.md* in the [host-spec](./host-spec/README.md) or [runtime-spec](./runtime-spec/README.md) subfolders.

## Polkadot Protocol Conformance Testsuite

The `test/` directory contains tests of different components for the different implementations of the Polkadot protocol.

This ensures that the different implementations behave the same and produce identical output, which is the necessary basis for the interoperability of all Polkadot clients.

For more details plese see the [README.md](./test/README.md) of the testsuite.

## Genesis and Runtime files

The latest genesis files can be retrieved from the official polkadot repository [here](https://github.com/paritytech/polkadot/tree/master/node/service/res).

All runtime releases can be found on the official [Polkadot Releases page](https://github.com/paritytech/polkadot/releases).
