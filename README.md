[![CircleCI](https://circleci.com/gh/w3f/polkadot-re-tests.svg?style=svg)](https://circleci.com/gh/w3f/polkadot-re-tests)

#  Polkadot Protocol Specification and Conformance Tests
In this repo you will find:

- Polkadot Runtime Environment Spec
- Specification Conformance Tests for various implementation of Polkadot Runtime Enviornment
- Tests

## Polkadot Runtime Environment Specification
Here your can find the latest version of [Polkadot Runtime Environment Specification](./runtime-environment-spec/polkadot_re_spec.pdf)

Please refer to [Change log](./runtime-environment-spec/pdre_change_log.org) to review the history of changes to the spec.

## Testing
In the `test/` directory we include tests for the following components:

- SCALE Codec
- State Trie
- Polkadot Runtime Environment API (PDRE API)

The goal is to make sure that the different implementations (from foreign languges and projects) behave the same and produce the identical output.

### Running tests
First, make sure that Julia is installed and download the required third party components:

```
apt install -y julia
git submodule update --init --recursive
```

By running `./run_tests.sh` the automated tests get executed. With `./run_tests.sh verbose` the CLI call with parameters including the outputs can be displayed. Do note that this script should be run from this repos root directory, since there are some directory dependend relative paths used.

### Implementing tests and components
Inside the testing directory, the tests are executed in the following way:

```
runtests.jl
|-> scale_codec_tests.jl
|-> state_trie_tests.jl
|-> pdre_api_tests.jl
```

Each of those tests defines how the final executable tests are called and pass data to it. The testing data, results and additional info can be found in the *test/fixtures* directory.

#### SCALE Codec

*...*

#### State Trie

*...*

#### PDRE API

Those testers call functions that test the PDRE API.

|Directory/File                      | Description                                         |
|------------------------------------|-----------------------------------------------------|
|*test/pdre_api_tests.jl*            | Runs the different testers and passes data to it.   |
|*test/fixtures/pdre_api_dataset.jl* | Contains names of testers, functions and input data |
|*test/fixtures/pdre_api_result.jl*  | Contains the outputs/results of the tester          |

The tests are executed in the following way:

`<tester> pdre-api --function <function> --input <data>`

Example:

`rust_tester pdre-api --function test_blake2_128 --input "Horizontal"`

Each function gets tested with multiple inputs and then goes on to the next function. The functions are grouped depending on the format of the inputs. Those correspond in the same order with the listed outputs.

|PdreApiTestFixtures    |PdreApiTestData            |PdreApiExpectedResults|
|-----------------------|---------------------------|----------------------|
|fn_crypto_hashes       |value_data                 |res_crypto_hashes     |
|fn_crypto_keys         |value_data                 |                      |
|fn_storage_kv          |key_value_data             |res_storage_kv        |
|fn_storage_prefix      |prefix_key_value_data      |                      |
|fn_storage_child       |child_data_key_value_data  |res_storage_child     |
|fn_storage_prefix_child|prefix_child_key_value_data|                      |
|fn_network             |                           |                      |
