# Polkadot Protocol Specification Tests

This `test/` directory contains specification tests of the differen components of Polkadot, which are run against the different implementations (i.e in Rust, C++ and Golang).

Currently the testsuite contains the following tests:

- SCALE Codec Encoding (scale-codec)
- State Trie Hashing (stat-trie)
- Polkadot Host API (hostapi and hostapi-legacy)

This ensures that the different implementations behave in the same way and produce the identical output.

# Dependencies

The test suite depends on the following components

- _julia_ to run the testsuite
- _rust-nightly_ (with wasm target) to build substrate
- _cmake_ to build Kagome
- _go_ to build gossamer and adapters

## Through local CircleCI container (deprecated)

The easiest way to run those tests is by using `docker` via the [local-ci tool](https://circleci.com/docs/2.0/local-cli/). No API tokens are required for running the suite.

```bash
git clone https://github.com/w3f/polkadot-spec.git
cd polkadot-spec/
circleci local execute -c .circleci/config.yml --job runTests
```

## On system with aptitude 

Install the required software in order to run all the tests.

**Note:** The test suite requires CMake version 3.16 or higher and gcc/g++ version 8. It is not recommended to run those tests on the main workstation, since changing gcc/g++ versions can lead to issues.

```bash
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

# Install Rust and toolchains required for Wasm
curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly
rustup target add wasm32-unknown-unknown --toolchain nightly
cargo install --git https://github.com/alexcrichton/wasm-gc

# Set default gcc and g++ binaries to version 8
ln -sf /usr/bin/gcc-8 /usr/bin/gcc
ln -sf /usr/bin/g++-8 /usr/bin/g++
```

## On systems with nix

This is an experimental fork with a prove of concept implementation of the test harness under Nix.

The ```default.nix``` and ```shell.nix``` assumes that nixpkgs is ovelayed with a recent version of w3fpkgs. 

Alternativly there is a ```release.nix``` that uses a pinned version of w3fpkgs ```release.nix``` and ```release-shell.nix```  to maximise the cache hits on the w3fpkgs cachix binary cache.


# Running tests

By running `./check.jl` the automated tests get executed. With `./check.jl --verbose` the CLI parameters including the outputs can be displayed. Do note that this script must be run from this repos root directory, since it uses relative paths. Use `./check.jl --help` to learn how to run individual tests.

By running `nix-shell --run ./runtests.jl` the automated tests get executed. With `nix-shell --run "./runtests.jl verbose"` the CLI parameters including the outputs can be displayed. Do note that this script must be run from this repos root directory, since it uses relative paths.


# Structure

All fixtures are written in julia and can be found in the fixtures folder. Each subfolder contains a seperate fixtures. To add a new fixture it is enough to add a new subfolder containing a `include.jl` file. 


Each of those tests defines how the final executable tests are called and pass data to it. The function names, testing data and results can be found in each fixtures subfolder.

## Structure of Polkadot Host API tests

Those testers call functions that call the Polkadot Host API.

```text
+--------------------+
| hostapi/include.jl |
|                    |
+----------|---------+
           |                      +----------------+
           +--------------------->+Wasm Executor   |    *call runtime function*
           | substrate-adapter    |                +---------------------------+
           |                      |                |                           |
           |                      |                |                           v
           |                      |  +-------------+                 +---------|---------+
           |                      |  |Polkadot     |    *call API*   | wasm-adapter      |
           |                      |  |Runtme       +<----------------+                   |
           |                      |  |Environment  |                 |                   |
           |                      |  |             |                 |                   |
           |                      +--|-------------+                 +-------------------+
           |
           |
           +---------------------> ...
           | gossamer-adapter
           |
           |
           +---------------------> ...
             kagome-tester

```

Each tester will use the custom Polkadot Runtime to call functions on the Wasm blob, which in return call the Polkadot Host API. The return values are then returned to the tester which will optionally print those values and compare them against the expected results.

Each tester will use the custom Polkadot Runtime to call functions on the Wasm blob, which in return call the PDRE API. The return values are then returned to the tester which will optionally print those values and compare them against the expected results.

Relevant files:

|Directory/File                     |Description                                          |
|-----------------------------------|-----------------------------------------------------|
|*fixtures/HostAPITests.jl*         | Runs the different testers and passes data to it    |
|*fixtures/hostapi/include.jl*      | Runs the different testers and passes data to it    |
|*fixtures/hostapi/inputs.jl*       | Contains names of testers, functions and input data |
|*fixtures/hostapi/outputs.jl*      | Contains the outputs/results of the tester          |

The tests are executed in the following way:

`<adapter> pdre-api --function <function> --input <data>`

Example:

`substrate-adapter pdre-api --function test_blake2_128 --input "Horizontal"`

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
