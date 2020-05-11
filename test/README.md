# Polkadot Conformance Testsuite

This `test/` directory contains specification tests of the different components of Polkadot, which are run against the different implementations (i.e in Rust, C++ and Golang) of Polkadot

Currently the testsuite contains the following tests:

- SCALE Codec Encoding (scale-codec)
- State Trie Hashing (stat-trie)
- Polkadot Host API (hostapi and hostapi-legacy)

This ensures that the different implementations behave in the same way and produce the identical output. 

# Dependencies

The test suite depends on the following components:

- _julia_ to run the testsuite
- _rust-nightly_ (with wasm target) to build substrate 
- _cmake_ to build kagome
- _go_ to build gossamer

While the official target of our testsuite are currently only debian-based systems, there is in general no reason for it to not be able to run on  any recent GNU/Linux or even UNIX-based OS, like OS X.

## General Build

Each of the API adapters has to be build (see [adapters subfolder](./adapters/)), before the testsuite can be run.

### Substrate API Adapter

Needs Rust Nightly with WASM toolchain (and potentially libclang?)

```
cargo build --release
```

### Kagome API Adapter

Needs CMake, GCC or Clang >= 8, Rust, Perl.

```
cmake -DCMAKE_BUILD_TYPE=Release -B build -S .
cmake --build build
```

### Gossamer API Adapter

Needs recent version of Go.

```
go build
```

## On Debian-based systems

### Install dependencies

Install the required software in order to run all the tests.

**Note:** The test suite requires CMake version 3.12 or higher and gcc/g++ or clang version 8. However it is not recommended to change your default gcc/g++ versions for your whole installation, as that can lead to issues down the road. Please use the environment variables `CC` and `CXX` to temporally change the used compiler instead.

For example on 18.04, something like this should get you started:

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

### Install recent CMake

This can be skipped on Ubunut 20.04, as a recent version of CMake can be installed through aptitude. See the official [cmake homepage](https://cmake.org/download) for a recent version:

```bash
wget https://github.com/Kitware/CMake/releases/download/v3.17.2/cmake-3.17.2-Linux-x86_64.sh
chmod +x cmake-3.17.2-Linux-x86_64.sh
./cmake-3.17.2-Linux-x86_64.sh --skip-license --prefix=/usr/local
```

### Install Rust

While kagome only needs a recent version of rust, substrate depends on nightly and the wasm32 toolchain to build its nostd wasm targets.

```
curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly --target wasm32-unknown-unknown
```

### Force a recent C/C++ compiler

This is only needed before you build kagome (adapter). GCC 9, Clang 8 or Clang 9 work as well. Change example accordingly:

```
export CC=gcc-8
export CXX=g++-8
```

# Running tests

By running `./runtests.jl` the automated tests get executed. With `./runtests.jl --verbose` the CLI parameters including the outputs can be displayed. Do note that this script must be run from this repos root directory, since it uses relative paths. Use `./runtests.jl --help` to learn how to run individual tests.

# Structure

All fixtures are written in julia and can be found in the fixtures folder. Each subfolder contains a seperate fixtures. To add a new fixture it is enough to add a new subfolder containing a `include.jl` file. 


Each of those tests defines how the final executable tests are called and pass data to it. The function names, testing data and results can be found in each fixtures subfolder.

## Structure of Polkadot Host API tests

Those adapters call functions that call the Polkadot Host API.

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
             kagome-adapter

```

Each adapter will use the custom Polkadot Runtime to call functions on the Wasm blob, which in return call the Polkadot Host API. The return values are then returned to the tester which will optionally print those values and compare them against the expected results.

Each adapter will use the custom Polkadot Runtime to call functions on the Wasm blob, which in return call the PDRE API. The return values are then returned to the tester which will optionally print those values and compare them against the expected results.

Relevant files:

|Directory/File                     |Description                                          |
|-----------------------------------|-----------------------------------------------------|
|*fixtures/HostAPITests.jl*         | Runs the different adapters and passes data to it    |
|*fixtures/hostapi/include.jl*      | Runs the different adapters and passes data to it    |
|*fixtures/hostapi/inputs.jl*       | Contains names of adapters, functions and input data |
|*fixtures/hostapi/outputs.jl*      | Contains the outputs/results of the adapter          |

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
