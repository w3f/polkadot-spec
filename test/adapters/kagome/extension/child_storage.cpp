/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#include "child_storage.hpp"

namespace child_storage {
  // Input: prefix, child1, child2, key1, value1, key2, value2
  void processExtClearChildPrefix(const std::vector<std::string> &args){}

  // Input: child1, child2, key, value
  void processExtClearChildStorage(const std::vector<std::string> &args){}

  // Input: child1, child2, key, value
  void processExtExistsChildStorage(const std::vector<std::string> &args){}

  // Input: child1, child2, key, value
  void processExtKillChildStorage(const std::vector<std::string> &args){}

  // Input: child1, child2, key, value
  void processExtSetGetChildStorage(const std::vector<std::string> &args){}
}
