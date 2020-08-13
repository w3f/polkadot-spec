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


} // namespace storage

#endif // KAGOMECROSSTESTCLI_STORAGE_EXTENSION_HPP
