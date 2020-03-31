# Polkadot Protocol Specification Conformance Tests

[![Gitlab CI](https://gitlab.w3f.tech/florian/spectest/badges/master/pipeline.svg)](https://gitlab.w3f.tech/florian/spectest/pipelines/latest)

__WORK IN PROGRESS__

## About this repository

This is an experimental fork with a prove of concept implementation of the test harness under Nix.

The ```default.nix``` and ```shell.nix``` assumes that nixpkgs is ovelayed with a recent version of w3fpkgs. 

Alternativly there is a ```release.nix``` that uses a pinned version of w3fpkgs ```release.nix``` and ```release-shell.nix```  to maximise the cache hits on the w3fpkgs cachix binary cache.

## Testing
The test suites currenlty check the following components from different implementations such as Rust, C++ and Golang:

- SCALE Codec
- State Trie
- Polkadot Runtime Environment API (PDRE API)

The goal is to make sure that the different implementations behave the same and produce the identical output.

#### Running tests
By running `nix-shell --run ./runtests.jl` the automated tests get executed. With `nix-shell --run "./runtests.jl verbose"` the CLI parameters including the outputs can be displayed. Do note that this script must be run from this repos root directory, since it uses relative paths.

## Structure
The tests are executed in the following way:

```
runtests.jl
|-- scale_codec_tests.jl
|-- state_trie_tests.jl
|-- pdre_api_tests.jl
```

Each of those tests defines how the final executable tests are called and pass data to it. The function names, testing data and results can be found in the *test/fixtures* directory.

### SCALE Codec

*...*

### State Trie

*...*

### PDRE API

Those testers call functions that call the PDRE API. Currently, NOT all PDRE APIs are fully implemented. Some "expected results" will be adjusted.

```
+--------------------+
| pdre_api_tests.jl  |
|                    |
+----------+---------+
           |                  +----------------+
           +----------------->+Wasm Executor   |    *call runtime function*
           | rust-tester      |                +---------------------------+
           |                  |                |                           |
           |                  |                |                           v
           |                  |  +-------------+                 +---------+---------+
           |                  |  |Polkadot     |    *call API*   |Wasm Runtime blob  |
           |                  |  |Runtme       +<----------------+                   |
           |                  |  |Environment  |                 |                   |
           |                  |  |             |                 |                   |
           |                  +--+-------------+                 +-------------------+
           |
           |
           +-----------------> ...
           | go-tester
           |
           |
           +-----------------> ...
             cpp-tester

```

Each tester will use the custom Polkadot Runtime to call functions on the Wasm blob, which in return call the PDRE API. The return values are then returned to the tester which will optionally print those values and compare them against the expected results.

Relevant files:

|Directory/File                     |Description                                        |
|-----------------------------------|---------------------------------------------------|
|*test/pdre_api_tests.jl*           |Runs the different testers and passes data to it   |
|*test/fixtures/pdre_api_dataset.jl*|Contains names of testers, functions and input data|
|*test/fixtures/pdre_api_result.jl* |Contains the outputs/results of the tester         |

The tests are executed in the following way:

`<tester> pdre-api --function <function> --input <data>`

Example:

`rust-tester pdre-api --function test_blake2_128 --input "Horizontal"`

Each function gets tested with multiple inputs and then goes on to the next function.

In the Julia scripts, the functions (module *PdreApiTestFixtures*) are grouped together depending on the format of the inputs (module *PdreApiTestData*). Their outputs are compared with the corresponding list (module *PdreApiExpectedResults*). The sequence of those entries must be paid attention to.

This table shows the relationship between the lists.

|PdreApiTestFixtures     |PdreApiTestData             |PdreApiExpectedResults  |
|------------------------|----------------------------|------------------------|
|fn_crypto_hashes        |value_data                  |res_crypto_hashes       |
|fn_crypto_keys          |value_data                  |                        |
|fn_general_kv           |key_value_data              |res_storage_kv          |
|fn_storage_kv_offset    |key_value_data              |res_storage_kv_offset   |
|fn_storage_2x_kv        |prefix_key_value_data       |res_storage_2x_kv       |
|fn_storage_compare_set  |prefix_key_value_data       |res_storage_compare_set |
|fn_storage_prefix       |prefix_key_value_data       |                        |
|fn_storage_child_kv     |child_key_value_data        |res_storage_child       |
|fn_storage_child_2x_kv  |prefix_child_key_value_data |res_child_storage_root  |
|fn_storage_prefix_child |prefix_child_key_value_data |                        |
|fn_network              |                            |                        |

