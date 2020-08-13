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

namespace hashing {

  // execute hash function test by calling the select hash function
  // and target hash size with provided input.
  //
  // @param name is the name of the hash (e.g. blake2, keccak, sha2 or twox)
  // @param size is the expected size of the hash output
  // @param input to pass to the function
  void processHashFunction(
    const std::string_view name, uint32_t size, const std::string_view input
  );

} // namespace hashing

