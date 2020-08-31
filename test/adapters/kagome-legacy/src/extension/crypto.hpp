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

#ifndef KAGOMECROSSTESTCLI_CRYPTO_EXTENSION_HPP
#define KAGOMECROSSTESTCLI_CRYPTO_EXTENSION_HPP

#include <string>
#include <vector>

namespace crypto {

// execute hash function test by calling the select hash function
// and target hash size with provided input.
//
// @param name is the name of the hash (i.e. blake2, keccak or twox)
// @param size is the expected size of the hash output
// @param the first entry of args is passed as input to the function
void processHashFunctionTest(std::string_view name, uint32_t size, const std::vector<std::string>& args);

// executes ext_blake2_256_enumerated_trie_root tests according to provided args
// Input: value1, value2
void processExtBlake2_256EnumeratedTrieRoot(const std::vector<std::string> &args);

// executes ext_ed25519 tests according to provided args
// Input: data
// not implemented
void processExtEd25519(const std::vector<std::string> &args);

// executes ext_sr25519 tests according to provided args
// Input: data
// not implemented
void processExtSr25519(const std::vector<std::string> &args);

} // namespace crypto

#endif // KAGOMECROSSTESTCLI_CRYPTO_EXTENSION_HPP
