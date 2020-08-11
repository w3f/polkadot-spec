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

#include "crypto.hpp"

#include "helpers.hpp"

#include <common/buffer.hpp>
#include <common/hexutil.hpp>

#include <iostream>
#include <sstream>
#include <numeric>

namespace crypto {

  // Input: data
  void processHashFunctionTest(std::string_view name, uint32_t size, const std::vector<std::string>& args) {
      helpers::RuntimeEnvironment environment;

      // Allocate input
      std::string data = args[0];

      // Call hash function
      std::stringstream function;
      function << "rtm_ext_" << name << "_" << size * 8;

      auto hash = environment.execute<helpers::Buffer>(function.str(), data);

      BOOST_ASSERT_MSG(hash.size() == size, "Incorrect hash size.");

      // Print result
      std::cout << hash.toHex() << std::endl;
  }

  // Input: value1, value2
  void processExtBlake2_256EnumeratedTrieRoot(const std::vector<std::string> &args) {
    helpers::RuntimeEnvironment environment;

    // Parse input arguments
    std::string values = std::accumulate(args.cbegin(), args.cend(), std::string(""));

    std::vector<uint32_t> lengths;
    std::transform(args.cbegin(), args.cend(), std::back_inserter(lengths),
      [](const std::string& s) { return s.length(); }
    );

    // Compute enumerated trie root
    auto hash = environment.execute<helpers::Buffer>(
      "rtm_ext_blake2_256_enumerated_trie_root", values, lengths
    );

    // Print result
    std::cout << hash.toHex() << std::endl;
  }

  // TODO: Implement
  void processExtEd25519(const std::vector<std::string> &args){}

  // TODO: Implement
  void processExtSr25519(const std::vector<std::string> &args){}
}
