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

namespace storage {

  // executes ext_storage_set_version_1/ext_storage_get_version_1 test
  void processSetGet(const std::string_view key, const std::string_view value);

  // executes ext_storage_clear_version_1 test
  void processClear(const std::string_view key, const std::string_view value);

  // executes ext_storage_exists_version_1 test
  void processExists(const std::string_view key, const std::string_view value);

  // executes ext_storage_clear_prefix_version_1 test
  void processClearPrefix(const std::string_view prefix,
    const std::string_view key1, const std::string_view value1,
    const std::string_view key2, const std::string_view value2
  );

  // executes ext_storage_root_version_1 test
  void processRoot(
    const std::string_view key1, const std::string_view value1,
    const std::string_view key2, const std::string_view value2
  );

} // namespace storage
