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
In the `test/` directory we include tests for the following components, using the Rust, Golang and C++ implementations:

- SCALE Codec
- State Trie
- Polkadot Runtime Environment API (PDRE API)

The goal is to make sure that the different implementations behave the same and produce the identical output.

### Local Container (CircleCi)
The easiest way to run those tests is by using `docker` via the [local-ci tool](https://circleci.com/docs/2.0/local-cli/). No API tokens are required for running the suite.

```
git clone https://github.com/w3f/polkadot-spec.git
cd polkadot-spec/
circleci local execute -c .circleci/config.yml --job runTests
```

### Manual install
#### Installing toolchains and dependencies
Install the required software in order to run all the tests.

**Note:** The test suite requires CMake version 3.16 or higher and gcc/g++ version 8. It is not recommended to run those test on the main workstation, since changing gcc/g++ versions can lead to issues.

```
apt update && apt install -y --no-install-recommends \
  build-essential \
  make \
  pkg-config \
  libssl-dev \
  clang \
  libclang-dev \
  wget \
  gcc-8 \
  g++-8 \
  golang \
  julia \
  python

# Install CMake 3.16.0
wget https://github.com/Kitware/CMake/releases/download/v3.16.0-rc4/cmake-3.16.0-rc4-Linux-x86_64.sh
chmod +x cmake-3.16.0-rc4-Linux-x86_64.sh
./cmake-3.16.0-rc4-Linux-x86_64.sh --skip-license --prefix=/usr/local

# Install Rust toolchain required for Wasm
curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly
rustup target add wasm32-unknown-unknown --toolchain nightly
cargo install --git https://github.com/alexcrichton/wasm-gc

# Set default gcc and g++ binaries to version 8
ln -sf /usr/bin/gcc-8 /usr/bin/gcc
ln -sf /usr/bin/g++-8 /usr/bin/g++
```

#### Running tests
By running `./run_tests.sh` the automated tests get executed. With `./run_tests.sh verbose` the CLI parameters including the outputs can be displayed. Do note that this script must be run from this repos root directory, since it uses relative paths.

## Structure
Inside the testing directory, the tests are executed in the following way:

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
           | rust_tester      |                +---------------------------+
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
           | go_tester
           |
           |
           +-----------------> ...
             cpp_tester

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

`rust_tester pdre-api --function test_blake2_128 --input "Horizontal"`

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