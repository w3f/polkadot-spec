/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef KAGOMECROSSTESTCLI_CHILD_STORAGE_EXTENSION_HPP
#define KAGOMECROSSTESTCLI_CHILD_STORAGE_EXTENSION_HPP

#include <string>
#include <vector>

namespace child_storage {
  // executes ext_clear_child_prefix tests according to provided args
  // Input: prefix, child1, child2, key1, value1, key2, value2
  // not implemented
  void processExtClearChildPrefix(const std::vector<std::string> &args);

  // executes ext_clear_child_storage tests according to provided args
  // Input: child1, child2, key, value
  // not implemented
  void processExtClearChildStorage(const std::vector<std::string> &args);

  // executes ext_exists_child_storage tests according to provided args
  // Input: child1, child2, key, value
  // not implemented
  void processExtExistsChildStorage(const std::vector<std::string> &args);

  // executes ext_kill_child_storage tests according to provided args
  // Input: child1, child2, key, value
  // not implemented
  void processExtKillChildStorage(const std::vector<std::string> &args);

  // executes ext_get_allocated_child_storage and ext_set_child_storage tests according to provided args
  // Input: child1, child2, key, value
  // not implemented
  void processExtSetGetChildStorage(const std::vector<std::string> &args);
} // namespace storage

#endif // KAGOMECROSSTESTCLI_CHILD_STORAGE_EXTENSION_HPP
