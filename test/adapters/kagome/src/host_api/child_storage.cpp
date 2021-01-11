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

#include "child_storage.hpp"

#include "helpers.hpp"

#include <iostream>

namespace child_storage {

  void processSetGet(
    const std::string_view child1, const std::string_view child2,
    const std::string_view key, const std::string_view value
  ) {
    helpers::RuntimeEnvironment environment;

    // Check that key has not been set
    auto result = environment.execute<helpers::MaybeBuffer>(
      "rtm_ext_default_child_storage_get_version_1", child1, key
    );

    BOOST_ASSERT_MSG(!result, "Child1 data exists");

    // Add data to storage
    environment.execute<void>(
      "rtm_ext_default_child_storage_set_version_1", child1, key, value
    );

    // Check that key has not been set
    result = environment.execute<helpers::MaybeBuffer>(
      "rtm_ext_default_child_storage_get_version_1", child2, key
    );

    BOOST_ASSERT_MSG(!result, "Child2 data exists");

    // Retrieve data from storage
    result = environment.execute<helpers::MaybeBuffer>(
      "rtm_ext_default_child_storage_get_version_1", child1, key
    );

    // Check returned data
    BOOST_ASSERT_MSG(result.has_value(), "No value");
    BOOST_ASSERT_MSG(result.value().toString() == value, "Values are different");

    // Print result
    std::cout << result.value().toString() << std::endl;
  }


  // Input: prefix, child1, child2, key1, value1, key2, value2
  void processExtClearChildPrefix(const std::vector<std::string> &args){}

  // Input: child1, child2, key, value
  void processExtClearChildStorage(const std::vector<std::string> &args){}

  // Input: child1, child2, key, value
  void processExtExistsChildStorage(const std::vector<std::string> &args){}

  // Input: child1, child2, key, value
  void processExtKillChildStorage(const std::vector<std::string> &args){}
}
