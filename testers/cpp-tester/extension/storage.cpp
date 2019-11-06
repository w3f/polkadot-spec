/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#include "storage.hpp"

#include <iostream>
#include <kagome/extensions/extension_impl.hpp>
#include <kagome/runtime/impl/wasm_memory_impl.hpp>
#include <kagome/storage/in_memory/in_memory_storage.hpp>
#include <kagome/storage/trie/impl/polkadot_trie_db.hpp>

namespace storage {
// Input: prefix, key1, value1, key2, value2
void processExtClearPrefix(const std::vector<std::string> &args) {
  std::string prefix = args[0];
  std::string key1 = args[1];
  std::string value1 = args[2];
  std::string key2 = args[3];
  std::string value2 = args[4];

  auto db = std::make_unique<kagome::storage::InMemoryStorage>();
  std::unique_ptr<kagome::storage::trie::TrieDb> trie =
      std::make_unique<kagome::storage::trie::PolkadotTrieDb>(std::move(db));
  std::shared_ptr<kagome::runtime::WasmMemory> memory =
      std::make_shared<kagome::runtime::WasmMemoryImpl>();

  std::unique_ptr<kagome::extensions::Extension> extension =
      std::make_unique<kagome::extensions::ExtensionImpl>(memory,
                                                          std::move(trie));

  kagome::common::Buffer buffer;

  buffer.put(key1);
  kagome::runtime::SizeType key1Size = buffer.size();
  memory->resize(memory->size() + buffer.size());
  kagome::runtime::WasmPointer key1Ptr = memory->allocate(key1Size);
  memory->storeBuffer(key1Ptr, buffer);
  buffer.clear();

  buffer.put(value1);
  kagome::runtime::SizeType value1Size = buffer.size();
  memory->resize(memory->size() + buffer.size());
  kagome::runtime::WasmPointer value1Ptr = memory->allocate(value1Size);
  memory->storeBuffer(value1Ptr, buffer);
  buffer.clear();

  extension->ext_set_storage(key1Ptr, key1Size, value1Ptr, value1Size);

  buffer.put(key2);
  kagome::runtime::SizeType key2Size = buffer.size();
  memory->resize(memory->size() + buffer.size());
  kagome::runtime::WasmPointer key2Ptr = memory->allocate(key2Size);
  memory->storeBuffer(key2Ptr, buffer);
  buffer.clear();

  buffer.put(value2);
  kagome::runtime::SizeType value2Size = buffer.size();
  memory->resize(memory->size() + buffer.size());
  kagome::runtime::WasmPointer value2Ptr = memory->allocate(value2Size);
  memory->storeBuffer(value2Ptr, buffer);
  buffer.clear();

  extension->ext_set_storage(key2Ptr, key2Size, value1Ptr, value1Size);

  buffer.put(prefix);
  kagome::runtime::SizeType prefixSize = buffer.size();
  memory->resize(memory->size() + buffer.size());
  kagome::runtime::WasmPointer prefixPtr = memory->allocate(prefixSize);
  memory->storeBuffer(prefixPtr, buffer);
  buffer.clear();

  extension->ext_clear_prefix(prefixPtr, prefixSize);

  kagome::runtime::SizeType sizePtrSize = sizeof(kagome::runtime::SizeType);
  memory->resize(memory->size() + sizePtrSize);
  kagome::runtime::WasmPointer sizePtr =
      memory->allocate(sizePtrSize);
  auto res = extension->ext_get_allocated_storage(key1Ptr, key1Size, sizePtr);
  kagome::runtime::SizeType written_out = memory->load32u(sizePtr);
  if (prefix == key1.substr(0, prefix.size())) {
    /*BOOST_ASSERT_MSG(written_out == memory->kMaxMemorySize,
                     "Value 1 wasn't deleted");*/
    BOOST_ASSERT_MSG(res == 0, "Value 1 wasn't deleted");
    std::cout << "Key '" + key1 + "' was deleted\n";
  } else {
    BOOST_ASSERT_MSG(written_out == value1Size, "Value 1 was deleted");
    BOOST_ASSERT_MSG(memory->loadN(res, written_out) ==
                         memory->loadN(value1Ptr, written_out),
                     "Value 1 was deleted");
    std::cout << "Key '" + key1 + "' remains\n";
  }

  res = extension->ext_get_allocated_storage(key2Ptr, key2Size, sizePtr);
  written_out = memory->load32u(sizePtr);
  if (prefix == key2.substr(0, prefix.size())) {
    /*BOOST_ASSERT_MSG(written_out == memory->kMaxMemorySize,
                     "Value 2 wasn't deleted");*/
    BOOST_ASSERT_MSG(res == 0, "Value 2 wasn't deleted");
    std::cout << "Key '" + key2 + "' was deleted\n";
  } else {
    /*BOOST_ASSERT_MSG(written_out == value2Size, "Value 2 was deleted");
    BOOST_ASSERT_MSG(memory->loadN(res, written_out) ==
                         memory->loadN(value2Ptr, written_out),
                     "Value 2 was deleted");*/
    std::cout << "Key '" + key2 + "' remains\n";
  }

  BOOST_ASSERT_MSG(memory->deallocate(key1Ptr) == key1Size,
                   "Memory Leak: Key1");
  BOOST_ASSERT_MSG(memory->deallocate(value1Ptr) == value1Size,
                   "Memory Leak: Value1");
  BOOST_ASSERT_MSG(memory->deallocate(key2Ptr) == key2Size,
                   "Memory Leak: Key2");
  BOOST_ASSERT_MSG(memory->deallocate(value2Ptr) == value2Size,
                   "Memory Leak: Value 2");
  /*BOOST_ASSERT_MSG(memory->deallocate(sizePtr) == memory->kMaxMemorySize,
                   "Memory Leak: Size");*/
  BOOST_ASSERT_MSG(memory->deallocate(prefixPtr) == prefixSize,
                   "Memory Leak: Prefix");
}

// Input: key, value
void processExtClearStorage(const std::vector<std::string> &args) {
  std::string key = args[0];
  std::string value = args[1];

  auto db = std::make_unique<kagome::storage::InMemoryStorage>();
  std::unique_ptr<kagome::storage::trie::TrieDb> trie =
      std::make_unique<kagome::storage::trie::PolkadotTrieDb>(std::move(db));
  std::shared_ptr<kagome::runtime::WasmMemory> memory =
      std::make_shared<kagome::runtime::WasmMemoryImpl>();

  std::unique_ptr<kagome::extensions::Extension> extension =
      std::make_unique<kagome::extensions::ExtensionImpl>(memory,
                                                          std::move(trie));

  kagome::common::Buffer buffer;

  buffer.put(key);
  kagome::runtime::SizeType keySize = buffer.size();
  memory->resize(memory->size() + buffer.size());
  kagome::runtime::WasmPointer keyPtr = memory->allocate(keySize);
  memory->storeBuffer(keyPtr, buffer);
  buffer.clear();

  buffer.put(value);
  kagome::runtime::SizeType valueSize = buffer.size();
  memory->resize(memory->size() + buffer.size());
  kagome::runtime::WasmPointer valuePtr = memory->allocate(valueSize);
  memory->storeBuffer(valuePtr, buffer);
  buffer.clear();

  extension->ext_set_storage(keyPtr, keySize, valuePtr, valueSize);

  kagome::runtime::SizeType sizePtrSize = sizeof(kagome::runtime::SizeType);
  memory->resize(memory->size() + sizePtrSize);
  kagome::runtime::WasmPointer sizePtr = memory->allocate(sizePtrSize);
  auto res = extension->ext_get_allocated_storage(keyPtr, keySize, sizePtr);
  kagome::runtime::SizeType written_out = memory->load32u(sizePtr);
  BOOST_ASSERT_MSG(written_out == valueSize, "No value");
  BOOST_ASSERT_MSG(memory->loadN(res, written_out) ==
                       memory->loadN(valuePtr, written_out),
                   "No value");

  extension->ext_clear_storage(keyPtr, keySize);

  res = extension->ext_get_allocated_storage(keyPtr, keySize, sizePtr);
  written_out = memory->load32u(sizePtr);
  BOOST_ASSERT_MSG(res == 0, "Value wasn't deleted");
  /*BOOST_ASSERT_MSG(written_out == memory->kMaxMemorySize,
                   "Value wasn't deleted");*/

  BOOST_ASSERT_MSG(memory->deallocate(keyPtr) == keySize, "Memory Leak: Key");
  BOOST_ASSERT_MSG(memory->deallocate(valuePtr) == valueSize,
                   "Memory Leak: Value ");
  BOOST_ASSERT_MSG(memory->deallocate(sizePtr) == sizePtrSize,
                   "Memory Leak: Size");
}

// Input: key, value
void processExtExistsStorage(const std::vector<std::string> &args) {
  std::string key = args[0];
  std::string value = args[1];

  auto db = std::make_unique<kagome::storage::InMemoryStorage>();
  std::unique_ptr<kagome::storage::trie::TrieDb> trie =
      std::make_unique<kagome::storage::trie::PolkadotTrieDb>(std::move(db));
  std::shared_ptr<kagome::runtime::WasmMemory> memory =
      std::make_shared<kagome::runtime::WasmMemoryImpl>();

  std::unique_ptr<kagome::extensions::Extension> extension =
      std::make_unique<kagome::extensions::ExtensionImpl>(memory,
                                                          std::move(trie));

  kagome::common::Buffer buffer;

  buffer.put(key);
  kagome::runtime::SizeType keySize = buffer.size();
  memory->resize(memory->size() + buffer.size());
  kagome::runtime::WasmPointer keyPtr = memory->allocate(keySize);
  memory->storeBuffer(keyPtr, buffer);
  buffer.clear();

  buffer.put(value);
  kagome::runtime::SizeType valueSize = buffer.size();
  memory->resize(memory->size() + buffer.size());
  kagome::runtime::WasmPointer valuePtr = memory->allocate(valueSize);

  memory->storeBuffer(valuePtr, buffer);
  buffer.clear();

  kagome::runtime::SizeType storageSize =
      extension->ext_exists_storage(keyPtr, keySize);
  BOOST_ASSERT_MSG(storageSize == 0, "Storage exists");

  extension->ext_set_storage(keyPtr, keySize, valuePtr, valueSize);

  storageSize = extension->ext_exists_storage(keyPtr, keySize);
  BOOST_ASSERT_MSG(storageSize == 1, "Storage exists");

  BOOST_ASSERT_MSG(memory->deallocate(keyPtr) == keySize, "Memory Leak: Key");
  BOOST_ASSERT_MSG(memory->deallocate(valuePtr) == valueSize,
                   "Memory Leak: Value ");
  std::cout << "true\n";
}

void processExtGetAllocatedStorage(const std::vector<std::string> &args) {}
} // namespace storage
