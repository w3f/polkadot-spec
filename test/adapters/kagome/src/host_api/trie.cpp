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

#include "trie.hpp"

#include "helpers.hpp"

#include <common/buffer.hpp>

#include <iostream>

namespace trie {

  // Input: value1, value2
  void processOrderedRoot(
    const std::string_view value1,
    const std::string_view value2,
    const std::string_view value3
  ) {
    helpers::RuntimeEnvironment environment;

    // Compute ordered trie root
    auto hash = environment.execute<helpers::Buffer>(
      "rtm_ext_trie_blake2_256_ordered_root_version_1",
      std::vector{ value1, value2, value3 }
    );

    // Print result
    std::cout << hash.toHex() << std::endl;
  }
}
