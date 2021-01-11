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

#pragma once

#include <string>
#include <vector>

// TODO update and implement module
namespace child_storage {
  // executes ext_default_child_storage_set_version_1 and
  // ext_default_child storage_get_version_1 test
  void processSetGet(
    const std::string_view child1, const std::string_view child2,
    const std::string_view key, const std::string_view value
  );


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
} // namespace storage
