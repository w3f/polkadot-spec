/*
 * Copyright (c) 2019 Web3 Technologies Foundation
 *
 * This file is part of Polkadot Host Test Suite
 *
 * Polkadot Host Test Suite is free software: you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as published by
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

#include "helpers.hpp"

namespace crypto {
  // execute ext_crypto_sr25519_public_keys_version_1 test
  void processEd25519PublicKeys(const std::string_view seed1, const std::string_view seed2);

  // execute ext_crypto_sr25519_generate_version_1 test
  void processEd25519Generate(const std::string_view seed);

  // execute ext_crypto_sr25519_sign_version_1 test
  void processEd25519Sign(const std::string_view seed, const std::string_view message);

  // execute ext_crypto_sr25519_verify_version_1 test
  void processEd25519Verify(const std::string_view seed, const std::string_view message);


  // execute ext_crypto_sr25519_public_keys_version_1 test
  void processSr25519PublicKeys(const std::string_view seed1, const std::string_view seed2);

  // execute ext_crypto_sr25519_generate_version_1 test
  void processSr25519Generate(const std::string_view seed);

  // execute ext_crypto_sr25519_sign_version_1 test
  void processSr25519Sign(const std::string_view seed, const std::string_view message);

  // execute ext_crypto_sr25519_verify_version_1 test
  void processSr25519Verify(const std::string_view seed, const std::string_view message);

} // namespace crypto
