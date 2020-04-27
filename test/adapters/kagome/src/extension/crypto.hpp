/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef KAGOMECROSSTESTCLI_CRYPTO_EXTENSION_HPP
#define KAGOMECROSSTESTCLI_CRYPTO_EXTENSION_HPP

#include <string>
#include <vector>

namespace crypto {
// executes ext_blake2_128 tests according to provided args
// Input: data
// not implemented
void processExtBlake2_128(const std::vector<std::string> &args);

// executes ext_blake2_256 tests according to provided args
// Input: data
void processExtBlake2_256(const std::vector<std::string> &args);

// executes ext_ed25519 tests according to provided args
// Input: data
// not implemented
void processExtEd25519(const std::vector<std::string> &args);

// executes ext_keccak_256 tests according to provided args
// Input: data
void processExtKeccak256(const std::vector<std::string> &args);

// executes ext_sr25519 tests according to provided args
// Input: data
// not implemented
void processExtSr25519(const std::vector<std::string> &args);

// executes ext_twox_64 tests according to provided args
// Input: data
// not implemented
void processExtTwox64(const std::vector<std::string> &args);

// executes ext_twox_128 tests according to provided args
// Input: data
void processExtTwox128(const std::vector<std::string> &args);

// executes ext_twox_256 tests according to provided args
// Input: data
void processExtTwox256(const std::vector<std::string> &args);

} // namespace crypto

#endif // KAGOMECROSSTESTCLI_CRYPTO_EXTENSION_HPP
