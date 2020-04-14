/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#include "crypto.hpp"

#include "helpers.hpp"

#include <kagome/common/buffer.hpp>
#include <kagome/common/hexutil.hpp>

#include <iostream>

namespace crypto {

  // Input: data
  void processExtBlake2_128(const std::vector<std::string> &args){}

  // Input: data
  void processExtBlake2_256(const std::vector<std::string> &args){
    std::string data = args[0];

    auto [memory, extension] = helpers::initialize_environment();

    kagome::common::Buffer buffer;

    buffer.put(data);
    kagome::runtime::SizeType valueSize = buffer.size();
    kagome::runtime::WasmPointer valuePtr = memory->allocate(valueSize);
    memory->storeBuffer(valuePtr, buffer);
    buffer.clear();

    auto resultPtr = memory->allocate(32);
    extension->ext_blake2_256(valuePtr, valueSize, resultPtr);
    auto hash = memory->loadN(resultPtr, 32);

    std::cout << kagome::common::hex_lower(hash) << "\n";
  }

  // Input: data
  void processExtEd25519(const std::vector<std::string> &args){}

  // Input: data
  void processExtKeccak256(const std::vector<std::string> &args){
    std::string data = args[0];

    auto [memory, extension] = helpers::initialize_environment();

    kagome::common::Buffer buffer;

    buffer.put(data);
    kagome::runtime::SizeType valueSize = buffer.size();
    kagome::runtime::WasmPointer valuePtr = memory->allocate(valueSize);
    memory->storeBuffer(valuePtr, buffer);
    buffer.clear();

    auto resultPtr = memory->allocate(32);
    extension->ext_keccak_256(valuePtr, valueSize, resultPtr);
    auto hash = memory->loadN(resultPtr, 32);

    std::cout << kagome::common::hex_lower(hash) << "\n";
  }

  // Input: data
  void processExtSr25519(const std::vector<std::string> &args){}

  // Input: data
  void processExtTwox64(const std::vector<std::string> &args){}

  // Input: data
  void processExtTwox128(const std::vector<std::string> &args){
    std::string data = args[0];

    auto [memory, extension] = helpers::initialize_environment();

    kagome::common::Buffer buffer;

    buffer.put(data);
    kagome::runtime::SizeType valueSize = buffer.size();
    kagome::runtime::WasmPointer valuePtr = memory->allocate(valueSize);
    memory->storeBuffer(valuePtr, buffer);
    buffer.clear();

    auto resultPtr = memory->allocate(16);
    extension->ext_twox_128(valuePtr, valueSize, resultPtr);
    auto hash = memory->loadN(resultPtr, 16);

    std::cout << kagome::common::hex_lower(hash) << "\n";
  }

  // Input: data
  void processExtTwox256(const std::vector<std::string> &args){
    std::string data = args[0];

    auto [memory, extension] = helpers::initialize_environment();

    kagome::common::Buffer buffer;

    buffer.put(data);
    kagome::runtime::SizeType valueSize = buffer.size();
    kagome::runtime::WasmPointer valuePtr = memory->allocate(valueSize);
    memory->storeBuffer(valuePtr, buffer);
    buffer.clear();

    auto resultPtr = memory->allocate(32);
    extension->ext_twox_256(valuePtr, valueSize, resultPtr);
    auto hash = memory->loadN(resultPtr, 32);

    std::cout << kagome::common::hex_lower(hash) << "\n";
  }

}
