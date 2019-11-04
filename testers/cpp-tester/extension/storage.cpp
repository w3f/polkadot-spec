/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#include "storage.hpp"

#include <boost/program_options.hpp>
#include <kagome/extensions/extension_impl.hpp>
#include <kagome/runtime/impl/wasm_memory_impl.hpp>
#include <kagome/storage/in_memory/in_memory_storage.hpp>
#include <kagome/storage/trie/impl/polkadot_trie_db.hpp>

namespace po = boost::program_options;

ClearPrefixCommandArgs extractClearPrefixArgs(int argc, char **argv) {
  po::options_description desc("Clear Prefix related tests\nAllowed options:");
  boost::optional<std::string> prefix;
  boost::optional<std::string> key1;
  boost::optional<std::string> value1;
  boost::optional<std::string> key2;
  boost::optional<std::string> value2;

  // clang-format off
  desc.add_options()
      ("help", "produce help message")
      ("prefix",
       po::value(&prefix)->required(), "The prefix for deletion")
      ("key1",
       po::value(&key1),
       "first key")
      ("value1",
       po::value(&value1),
       "first value")
      ("key2",
       po::value(&key2),
       "second key")
      ("value2",
       po::value(&value2),
       "second value");
  // clang-format on

  po::variables_map vm;
  po::store(
      po::command_line_parser(argc, argv).options(desc).run(),
      vm);
  po::notify(vm);

  BOOST_ASSERT_MSG(prefix, "Prefix is not stated");
  BOOST_ASSERT_MSG(key1, "Key 1 is not provided");
  BOOST_ASSERT_MSG(value1, "Value 1 is not provided");
  BOOST_ASSERT_MSG(key2, "Key 2 is not provided");
  BOOST_ASSERT_MSG(value2, "Value 2 is not provided");

  return ClearPrefixCommandArgs{.prefix = *prefix,
      .key1 = *key1,
      .value1 = *value1,
      .key2 = *key2,
      .value2 = *value2};
}

void processExtClearPrefix(const ClearPrefixCommandArgs& args) {
  auto db = std::make_unique<kagome::storage::InMemoryStorage>();
  std::unique_ptr<kagome::storage::trie::TrieDb> trie =
      std::make_unique<kagome::storage::trie::PolkadotTrieDb>(std::move(db));
  std::shared_ptr<kagome::runtime::WasmMemory> memory =
      std::shared_ptr<kagome::runtime::WasmMemoryImpl>();

  std::unique_ptr<kagome::extensions::Extension> extension =
      std::make_unique<kagome::extensions::ExtensionImpl>(memory,
                                                          std::move(trie));

  memory->resize(memory->kMaxMemorySize);

  kagome::common::Buffer buffer;

  buffer.put(args.key1);
  kagome::runtime::SizeType  key1Size = buffer.size();
  kagome::runtime::WasmPointer key1Ptr = memory->allocate(key1Size);
  memory->storeBuffer(key1Ptr, buffer);
  buffer.clear();

  buffer.put(args.value1);
  kagome::runtime::SizeType  value1Size = buffer.size();
  kagome::runtime::WasmPointer value1Ptr = memory->allocate(value1Size);
  memory->storeBuffer(value1Ptr, buffer);
  buffer.clear();

  extension->ext_set_storage(key1Ptr, key1Size, value1Ptr, value1Size);

  buffer.put(args.key2);
  kagome::runtime::SizeType  key2Size = buffer.size();
  kagome::runtime::WasmPointer key2Ptr = memory->allocate(key2Size);
  memory->storeBuffer(key2Ptr, buffer);
  buffer.clear();

  buffer.put(args.value2);
  kagome::runtime::SizeType  value2Size = buffer.size();
  kagome::runtime::WasmPointer value2Ptr = memory->allocate(value2Size);
  memory->storeBuffer(value2Ptr, buffer);
  buffer.clear();

  extension->ext_set_storage(key2Ptr, key2Size, value1Ptr, value1Size);

  buffer.put(args.prefix);
  kagome::runtime::SizeType  prefixSize = buffer.size();
  kagome::runtime::WasmPointer prefixPtr = memory->allocate(prefixSize);
  memory->storeBuffer(prefixPtr, buffer);
  buffer.clear();

  extension->ext_clear_prefix(prefixPtr, prefixSize);

  kagome::runtime::WasmPointer sizePtr = memory->allocate(sizeof(memory->kMaxMemorySize));
  auto res = extension->ext_get_allocated_storage(key1Ptr, key1Size, sizePtr);
  kagome::runtime::SizeType written_out = memory->load32u(sizePtr);
  if (args.prefix == args.key1.substr(0, args.prefix.size())) {
    BOOST_ASSERT_MSG( written_out == memory->kMaxMemorySize, "Value 1 wasn't deleted");
    BOOST_ASSERT_MSG(res == 0, "Value 1 wasn't deleted");
  }
  else
  {
    BOOST_ASSERT_MSG( written_out == value1Size, "Value 1 was deleted");
    BOOST_ASSERT_MSG(res == value1Ptr, "Value 1 was deleted");
  }

  res = extension->ext_get_allocated_storage(key2Ptr, key2Size, sizePtr);
  written_out = memory->load32u(sizePtr);
  if (args.prefix == args.key2.substr(0, args.prefix.size())) {
    BOOST_ASSERT_MSG( written_out == memory->kMaxMemorySize, "Value 2 wasn't deleted");
    BOOST_ASSERT_MSG(res == 0, "Value 2 wasn't deleted");
  }
  else
  {
    BOOST_ASSERT_MSG( written_out == value2Size, "Value 2 was deleted");
    BOOST_ASSERT_MSG(res == value2Ptr, "Value 2 was deleted");
  }

  BOOST_ASSERT_MSG(memory->deallocate(key1Ptr) == key1Size, "Memory Leak: Key1");
  BOOST_ASSERT_MSG(memory->deallocate(value1Ptr) == value1Size, "Memory Leak: Value1");
  BOOST_ASSERT_MSG(memory->deallocate(key2Ptr) == key2Size, "Memory Leak: Key2");
  BOOST_ASSERT_MSG(memory->deallocate(value2Ptr) == value2Size, "Memory Leak: Value 2");
  BOOST_ASSERT_MSG(memory->deallocate(sizePtr) == memory->kMaxMemorySize, "Memory Leak: Size");
  BOOST_ASSERT_MSG(memory->deallocate(prefixPtr) == prefixSize, "Memory Leak: Prefix");
}
