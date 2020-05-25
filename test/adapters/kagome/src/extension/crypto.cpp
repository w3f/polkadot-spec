/*
 * Copyright (c) 2019 Web3 Technologies Foundation
 *
 * This file is part of Polkadot Host Test Suite
 *
 * Polkadot Host Test Suite is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Polkadot Host Tests is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Foobar.  If not, see <https://www.gnu.org/licenses/>.
 */

#include "crypto.hpp"

#include "helpers.hpp"

#include <common/buffer.hpp>
#include <common/hexutil.hpp>

#include <iostream>

namespace crypto {

  // Input: data
  void processExtBlake2_128(const std::vector<std::string> &args){
      std::string data = args[0];

      auto [memory, extension] = helpers::initialize_environment();

      kagome::common::Buffer buffer;

      buffer.put(data);
      kagome::runtime::SizeType valueSize = buffer.size();
      kagome::runtime::WasmPointer valuePtr = memory->allocate(valueSize);
      memory->storeBuffer(valuePtr, buffer);
      buffer.clear();

      auto resultPtr = memory->allocate(16);
      extension->ext_blake2_128(valuePtr, valueSize, resultPtr);
      auto hash = memory->loadN(resultPtr, 16);

      std::cout << kagome::common::hex_lower(hash) << "\n";
  }

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
  void processExtTwox64(const std::vector<std::string> &args){
      std::string data = args[0];

      auto [memory, extension] = helpers::initialize_environment();

      kagome::common::Buffer buffer;

      buffer.put(data);
      kagome::runtime::SizeType valueSize = buffer.size();
      kagome::runtime::WasmPointer valuePtr = memory->allocate(valueSize);
      memory->storeBuffer(valuePtr, buffer);
      buffer.clear();

      auto resultPtr = memory->allocate(8);
      extension->ext_twox_64(valuePtr, valueSize, resultPtr);
      auto hash = memory->loadN(resultPtr, 8);

      std::cout << kagome::common::hex_lower(hash) << "\n";
  }

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
