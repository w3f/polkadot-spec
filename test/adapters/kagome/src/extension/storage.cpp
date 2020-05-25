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

#include "storage.hpp"

#include "helpers.hpp"

#include <common/buffer.hpp>
#include <common/hexutil.hpp>

#include <iostream>
namespace storage {

// Input: prefix, key1, value1, key2, value2
void processExtClearPrefix(const std::vector<std::string> &args) {
  std::string prefix = args[0];
  std::string key1 = args[1];
  std::string value1 = args[2];
  std::string key2 = args[3];
  std::string value2 = args[4];

  auto [memory, extension] = helpers::initialize_environment();

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

  extension->ext_set_storage(key2Ptr, key2Size, value2Ptr, value2Size);

  buffer.put(prefix);
  kagome::runtime::SizeType prefixSize = buffer.size();
  kagome::runtime::WasmPointer prefixPtr = memory->allocate(prefixSize);
  memory->storeBuffer(prefixPtr, buffer);
  buffer.clear();

  extension->ext_clear_prefix(prefixPtr, prefixSize);

  kagome::runtime::SizeType sizePtrSize = sizeof(kagome::runtime::SizeType);
  kagome::runtime::WasmPointer sizePtr = memory->allocate(sizePtrSize);
  auto res = extension->ext_get_allocated_storage(key1Ptr, key1Size, sizePtr);
  kagome::runtime::SizeType written_out = memory->load32u(sizePtr);
  if (prefix == key1.substr(0, prefix.size())) {
    BOOST_ASSERT_MSG(written_out == memory->kMaxMemorySize,
                     "Value 1 wasn't deleted");
    BOOST_ASSERT_MSG(res == 0, "Value 1 wasn't deleted");
    std::cout << "Key '" + key1 + "' was deleted\n";
  } else {
    BOOST_ASSERT_MSG(written_out == value1Size, "Value 1 was deleted");
    BOOST_ASSERT_MSG(memory->loadN(res, written_out) ==
                         memory->loadN(value1Ptr, written_out),
                     "Value1 does not match");
    std::cout << "Key '" + key1 + "' remains\n";
  }

  res = extension->ext_get_allocated_storage(key2Ptr, key2Size, sizePtr);
  written_out = memory->load32u(sizePtr);
  if (prefix == key2.substr(0, prefix.size())) {
    BOOST_ASSERT_MSG(written_out == memory->kMaxMemorySize,
                     "Value 2 wasn't deleted");
    BOOST_ASSERT_MSG(res == 0, "Value 2 wasn't deleted");
    std::cout << "Key '" + key2 + "' was deleted\n";
  } else {
    BOOST_ASSERT_MSG(written_out == value2Size, "Value 2 was deleted");
    BOOST_ASSERT_MSG(memory->loadN(res, written_out) ==
                         memory->loadN(value2Ptr, written_out),
                     "Value2 does not match");
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
  BOOST_ASSERT_MSG(memory->deallocate(sizePtr) == sizePtrSize,
                   "Memory Leak: Size");
  BOOST_ASSERT_MSG(memory->deallocate(prefixPtr) == prefixSize,
                   "Memory Leak: Prefix");
}

// Input: key, value
void processExtClearStorage(const std::vector<std::string> &args) {
  std::string key = args[0];
  std::string value = args[1];

  auto [memory, extension] = helpers::initialize_environment();

  kagome::common::Buffer buffer;

  buffer.put(key);
  kagome::runtime::SizeType keySize = buffer.size();
  kagome::runtime::WasmPointer keyPtr = memory->allocate(keySize);
  memory->storeBuffer(keyPtr, buffer);
  buffer.clear();

  buffer.put(value);
  kagome::runtime::SizeType valueSize = buffer.size();
  kagome::runtime::WasmPointer valuePtr = memory->allocate(valueSize);
  memory->storeBuffer(valuePtr, buffer);
  buffer.clear();

  extension->ext_set_storage(keyPtr, keySize, valuePtr, valueSize);
  kagome::runtime::SizeType sizePtrSize = sizeof(kagome::runtime::SizeType);
  kagome::runtime::WasmPointer sizePtr = memory->allocate(sizePtrSize);
  auto res = extension->ext_get_allocated_storage(keyPtr, keySize, sizePtr);
  kagome::runtime::SizeType written_out = memory->load32u(sizePtr);
  BOOST_ASSERT_MSG(written_out == valueSize, "No value");
  BOOST_ASSERT_MSG(memory->loadN(res, written_out) ==
                       memory->loadN(valuePtr, written_out),
                   "Values are different");

  extension->ext_clear_storage(keyPtr, keySize);

  res = extension->ext_get_allocated_storage(keyPtr, keySize, sizePtr);
  written_out = memory->load32u(sizePtr);
  BOOST_ASSERT_MSG(res == 0, "Value wasn't deleted");
  BOOST_ASSERT_MSG(written_out == memory->kMaxMemorySize,
                   "Value wasn't deleted");

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

  auto [memory, extension] = helpers::initialize_environment();

  kagome::common::Buffer buffer;

  buffer.put(key);
  kagome::runtime::SizeType keySize = buffer.size();
  kagome::runtime::WasmPointer keyPtr = memory->allocate(keySize);
  memory->storeBuffer(keyPtr, buffer);
  buffer.clear();

  buffer.put(value);
  kagome::runtime::SizeType valueSize = buffer.size();
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
                   "Memory Leak: Value");

  std::cout << "true\n";
}

// Input: key, value
void processExtGetAllocatedStorage(const std::vector<std::string> &args) {
  std::string key = args[0];
  std::string value = args[1];

  auto [memory, extension] = helpers::initialize_environment();

  kagome::common::Buffer buffer;

  buffer.put(key);
  kagome::runtime::SizeType keySize = buffer.size();
  kagome::runtime::WasmPointer keyPtr = memory->allocate(keySize);
  memory->storeBuffer(keyPtr, buffer);
  buffer.clear();

  buffer.put(value);
  kagome::runtime::SizeType valueSize = buffer.size();
  kagome::runtime::WasmPointer valuePtr = memory->allocate(valueSize);
  memory->storeBuffer(valuePtr, buffer);
  buffer.clear();

  kagome::runtime::SizeType sizePtrSize = sizeof(kagome::runtime::SizeType);
  kagome::runtime::WasmPointer sizePtr = memory->allocate(sizePtrSize);
  auto res = extension->ext_get_allocated_storage(keyPtr, keySize, sizePtr);
  kagome::runtime::SizeType written_out = memory->load32u(sizePtr);
  BOOST_ASSERT_MSG(written_out == kagome::runtime::WasmMemory::kMaxMemorySize,
                   "Data exists");
  BOOST_ASSERT_MSG(res == 0, "Data exists");

  extension->ext_set_storage(keyPtr, keySize, valuePtr, valueSize);

  res = extension->ext_get_allocated_storage(keyPtr, keySize, sizePtr);
  written_out = memory->load32u(sizePtr);
  BOOST_ASSERT_MSG(written_out == valueSize, "Value not preserved");
  auto resultBuffer = memory->loadN(res, written_out);
  BOOST_ASSERT_MSG(resultBuffer == memory->loadN(valuePtr, written_out),
                   "Values are different");

  BOOST_ASSERT_MSG(memory->deallocate(keyPtr) == keySize, "Memory Leak: Key");
  BOOST_ASSERT_MSG(memory->deallocate(valuePtr) == valueSize,
                   "Memory Leak: Value");
  BOOST_ASSERT_MSG(memory->deallocate(sizePtr) == sizePtrSize,
                   "Memory Leak: Size");

  std::string message(reinterpret_cast<const char *>(resultBuffer.data()),
                      written_out);
  std::cout << message << "\n";
}

// Input: key, value, offset
void processExtGetAllocatedStorageInto(const std::vector<std::string> &args) {
  std::string key = args[0];
  std::string value = args[1];
  uint32_t offset = static_cast<uint32_t>(std::stoul(args[2]));

  auto [memory, extension] = helpers::initialize_environment();

  kagome::common::Buffer buffer;

  buffer.put(key);
  kagome::runtime::SizeType keySize = buffer.size();
  kagome::runtime::WasmPointer keyPtr = memory->allocate(keySize);
  memory->storeBuffer(keyPtr, buffer);
  buffer.clear();

  buffer.put(value);
  kagome::runtime::SizeType valueSize = buffer.size();
  kagome::runtime::WasmPointer valuePtr = memory->allocate(valueSize);
  memory->storeBuffer(valuePtr, buffer);
  buffer.clear();

  kagome::runtime::SizeType resultSize =
      valueSize < offset ? 0 : valueSize - offset;
  kagome::runtime::WasmPointer resultPtr = memory->allocate(resultSize);

  auto res = extension->ext_get_storage_into(keyPtr, keySize, resultPtr,
                                             resultSize, offset);
  BOOST_ASSERT_MSG(res == kagome::runtime::WasmMemory::kMaxMemorySize,
                   "Data exists");

  extension->ext_set_storage(keyPtr, keySize, valuePtr, valueSize);

  res = extension->ext_get_storage_into(keyPtr, keySize, resultPtr, resultSize,
                                        offset);
  BOOST_ASSERT_MSG(res == resultSize, "Values are different");
  auto resultBuffer = memory->loadN(resultPtr, res);
  BOOST_ASSERT_MSG(resultBuffer == memory->loadN(valuePtr + offset, resultSize),
                   "Values are different");

  BOOST_ASSERT_MSG(memory->deallocate(keyPtr) == keySize, "Memory Leak: Key");
  BOOST_ASSERT_MSG(memory->deallocate(valuePtr) == valueSize,
                   "Memory Leak: Value");
  if (resultSize == 0) {
    BOOST_ASSERT_MSG(memory->deallocate(resultPtr) == boost::none,
                     "Memory Leak: Result");
  } else {
    BOOST_ASSERT_MSG(memory->deallocate(resultPtr) == resultSize,
                     "Memory Leak: Result");
  }

  std::string message(reinterpret_cast<const char *>(resultBuffer.data()), res);
  std::cout << message << "\n";
}

// Input: key1, value1, key2, value2
void processExtStorageRoot(const std::vector<std::string> &args) {
  std::string key1 = args[0];
  std::string value1 = args[1];
  std::string key2 = args[2];
  std::string value2 = args[3];

  auto [memory, extension] = helpers::initialize_environment();

  kagome::common::Buffer buffer;

  buffer.put(key1);
  kagome::runtime::SizeType key1Size = buffer.size();
  kagome::runtime::WasmPointer key1Ptr = memory->allocate(key1Size);
  memory->storeBuffer(key1Ptr, buffer);
  buffer.clear();

  buffer.put(value1);
  kagome::runtime::SizeType value1Size = buffer.size();
  kagome::runtime::WasmPointer value1Ptr = memory->allocate(value1Size);
  memory->storeBuffer(value1Ptr, buffer);
  buffer.clear();

  buffer.put(key2);
  kagome::runtime::SizeType key2Size = buffer.size();
  kagome::runtime::WasmPointer key2Ptr = memory->allocate(key2Size);
  memory->storeBuffer(key2Ptr, buffer);
  buffer.clear();

  buffer.put(value2);
  kagome::runtime::SizeType value2Size = buffer.size();
  kagome::runtime::WasmPointer value2Ptr = memory->allocate(value2Size);
  memory->storeBuffer(value2Ptr, buffer);
  buffer.clear();

  buffer.put(":code");
  kagome::runtime::SizeType prepareKey1Size = buffer.size();
  kagome::runtime::WasmPointer prepareKey1Ptr =
      memory->allocate(prepareKey1Size);
  memory->storeBuffer(prepareKey1Ptr, buffer);
  buffer.clear();

  buffer.put("");
  kagome::runtime::SizeType prepareValue1Size = buffer.size();
  kagome::runtime::WasmPointer prepareValue1Ptr =
      memory->allocate(prepareValue1Size);
  memory->storeBuffer(prepareValue1Ptr, buffer);
  buffer.clear();

  buffer.put(":heappages");
  kagome::runtime::SizeType prepareKey2Size = buffer.size();
  kagome::runtime::WasmPointer prepareKey2Ptr =
      memory->allocate(prepareKey2Size);
  memory->storeBuffer(prepareKey2Ptr, buffer);
  buffer.clear();

  kagome::runtime::SizeType prepareValue2Size = 8;
  kagome::runtime::WasmPointer prepareValue2Ptr =
      memory->allocate(prepareValue2Size);
  memory->store64(prepareValue2Ptr, 8);
  buffer.clear();

  extension->ext_set_storage(prepareKey1Ptr, prepareKey1Size, prepareValue1Ptr,
                             prepareValue1Size);
  extension->ext_set_storage(prepareKey2Ptr, prepareKey2Size, prepareValue2Ptr,
                             prepareValue2Size);
  extension->ext_set_storage(key1Ptr, key1Size, value1Ptr, value1Size);
  extension->ext_set_storage(key2Ptr, key2Size, value2Ptr, value2Size);

  auto resultPtr = memory->allocate(32);
  extension->ext_storage_root(resultPtr);
  auto rootHash = memory->loadN(resultPtr, 32);

  std::cout << kagome::common::hex_lower(rootHash) << "\n";
}

// Input: value1, value2
void processExtBlake2_256EnumeratedTrieRoot(
    const std::vector<std::string> &args) {
  std::string value1 = args[0];
  std::string value2 = args[1];

  auto [memory, extension] = helpers::initialize_environment();

  kagome::runtime::WasmPointer valuesLenPtr = memory->allocate(8);

  kagome::common::Buffer buffer1;

  buffer1.put(value1);
  kagome::runtime::SizeType value1Size = buffer1.size();
  memory->store32(valuesLenPtr, value1Size);

  kagome::common::Buffer buffer2;

  buffer2.put(value2);
  kagome::runtime::SizeType value2Size = buffer2.size();
  memory->store32(valuesLenPtr + 4, value2Size);

  kagome::runtime::WasmPointer valuesPtr =
      memory->allocate(value1Size + value2Size);
  memory->storeBuffer(valuesPtr, buffer1);
  memory->storeBuffer(valuesPtr + value1Size, buffer2);

  auto resultPtr = memory->allocate(32);
  extension->ext_blake2_256_enumerated_trie_root(valuesPtr, valuesLenPtr, 2,
                                                 resultPtr);
  auto hash = memory->loadN(resultPtr, 32);

  std::cout << kagome::common::hex_lower(hash) << "\n";
}
void processExtAllocatedStorage(const std::vector<std::string> &args) {

  auto [memory, extension] = helpers::initialize_environment();

  auto pointer = extension->ext_malloc(44);

  // TODO

  extension->ext_free(pointer);
}

} // namespace storage
