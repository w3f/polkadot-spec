/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef KAGOMECROSSTESTCLI_STORAGE_EXTENSION_HPP
#define KAGOMECROSSTESTCLI_STORAGE_EXTENSION_HPP

#include <string>
#include <vector>

namespace storage {
  // executes ext_clear_prefix tests according to provided args
  // Input: prefix, key1, value1, key2, value2
  void processExtClearPrefix(const std::vector<std::string> &args);

  // executes ext_clear_storage tests according to provided args
  // Input: key, value
  void processExtClearStorage(const std::vector<std::string> &args);

  // executes ext_exists_storage tests according to provided args
  // Input: key, value
  void processExtExistsStorage(const std::vector<std::string> &args);

  // executes ext_get_allocated_storage tests according to provided args
  // Input: key, value
  void processExtGetAllocatedStorage(const std::vector<std::string> &args);

  // executes ext_get_allocated_storage_into tests according to provided args
  // Input: key, value, offset
  void processExtGetAllocatedStorageInto(const std::vector<std::string> &args);

  // executes ext_storage_changes_root tests according to provided args
  // Input: key1, value1, key2, value2
  void processExtStorageRoot(const std::vector<std::string> &args);

  // executes ext_blake2_256_enumerated_trie_root tests according to provided args
  // Input: value1, value2
  void processExtBlake2_256EnumeratedTrieRoot(const std::vector<std::string> &args);

  // executes ext_malloc and ext_free tests according to provided args
  // Input:
  void processExtAllocatedStorage(const std::vector<std::string> &args);
} // namespace storage

#endif // KAGOMECROSSTESTCLI_STORAGE_EXTENSION_HPP
