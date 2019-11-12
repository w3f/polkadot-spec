/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#include "crypto.hpp"

#include <iostream>
#include <kagome/extensions/extension_impl.hpp>
#include <kagome/runtime/impl/wasm_memory_impl.hpp>
#include <kagome/storage/in_memory/in_memory_storage.hpp>
#include <kagome/storage/trie/impl/polkadot_trie_db.hpp>

namespace crypto {

  // Input: data
  void processExtBlake2_128(const std::vector<std::string> &args){}

  // Input: data
  void processExtBlake2_256(const std::vector<std::string> &args){
    std::string data = args[0];

    auto db = std::make_unique<kagome::storage::InMemoryStorage>();
    std::unique_ptr<kagome::storage::trie::TrieDb> trie =
        std::make_unique<kagome::storage::trie::PolkadotTrieDb>(std::move(db));
    std::shared_ptr<kagome::runtime::WasmMemory> memory =
        std::make_shared<kagome::runtime::WasmMemoryImpl>(4096);

    std::unique_ptr<kagome::extensions::Extension> extension =
        std::make_unique<kagome::extensions::ExtensionImpl>(memory,
                                                            std::move(trie));

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
  void processExtKeccak256(const std::vector<std::string> &args){}

  // Input: data
  void processExtSr25519(const std::vector<std::string> &args){}

  // Input: data
  void processExtTwox64(const std::vector<std::string> &args){}

  // Input: data
  void processExtTwox128(const std::vector<std::string> &args){

  }

  // Input: data
  void processExtTwox256(const std::vector<std::string> &args){}

}
