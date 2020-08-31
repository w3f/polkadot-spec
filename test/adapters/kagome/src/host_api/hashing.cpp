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

#include "hashing.hpp"

#include "helpers.hpp"

#include <iostream>
#include <sstream>

namespace hashing {

  // Input: data
  void processHashFunction(
    const std::string_view name, uint32_t size, const std::string_view input
  ) {
    helpers::RuntimeEnvironment environment;

    // Call hash function
    std::stringstream function;
    function << "rtm_ext_hashing_" << name << "_" << size * 8 << "_version_1";

    auto hash = environment.execute<helpers::Buffer>(function.str(), input);

    BOOST_ASSERT_MSG(hash.size() == size, "Incorrect hash size.");

    // Print result
    std::cout << hash.toHex() << std::endl;
  }

}
