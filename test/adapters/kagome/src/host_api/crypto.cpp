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

#include <memory>
#include <vector>

#include <crypto/ed25519_types.hpp>
#include <crypto/sr25519_types.hpp>

using std::string_literals::operator""s;

using namespace kagome::crypto;

namespace crypto {

  template <
    const char *CName,
    typename TPublicKey,
    typename TSignature
    > struct CryptoSuite {
    static constexpr const char *Name = CName;
    using PublicKey = TPublicKey;
    using Signature = TSignature;
  };

  const char Ed25519Name[] = "ed25519";
  const char Sr25519Name[] = "sr25519";

  using Ed25519Suite = CryptoSuite<Ed25519Name, Ed25519PublicKey, Ed25519Signature>;
  using Sr25519Suite = CryptoSuite<Sr25519Name, Sr25519PublicKey, Sr25519Signature>;

  const kagome::runtime::WasmSize TEST_KEY_TYPE = 0xDEADBEEF;

  template <typename Suite>
  void processPublicKeys(const std::string_view seed1, const std::string_view seed2) {
    helpers::RuntimeEnvironment environment;

    auto pk1 = environment.execute<typename Suite::PublicKey>(
      "rtm_ext_crypto_"s + Suite::Name + "_generate_version_1",
      TEST_KEY_TYPE, boost::make_optional(seed1)
    );

    auto pk2 = environment.execute<typename Suite::PublicKey>(
      "rtm_ext_crypto_"s + Suite::Name + "_generate_version_1",
      TEST_KEY_TYPE, boost::make_optional(seed2)
    );

    auto keys = environment.execute<std::vector<typename Suite::PublicKey>>(
      "rtm_ext_crypto_"s + Suite::Name + "_public_keys_version_1",
      TEST_KEY_TYPE
    );

    BOOST_ASSERT(keys.size() == 2);

    BOOST_ASSERT(pk1 == keys.at(0) or pk1 == keys.at(1));
    BOOST_ASSERT(pk2 == keys.at(0) or pk2 == keys.at(1));

    std::cout << "1. Public key: " << keys.at(0).toHex() << std::endl;
    std::cout << "2. Public key: " << keys.at(1).toHex() << std::endl;
  }

  template <typename Suite>
  void processGenerate(std::string_view seed) {
    helpers::RuntimeEnvironment environment;

    auto key = environment.execute<typename Suite::PublicKey>(
      "rtm_ext_crypto_"s + Suite::Name + "_generate_version_1",
      TEST_KEY_TYPE, boost::make_optional(seed));

    std::cout << key.toHex() << std::endl;
  }

  template <typename Suite>
  void processSign(std::string_view seed, std::string_view message) {
    helpers::RuntimeEnvironment environment;

    auto pk = environment.execute<typename Suite::PublicKey>(
      "rtm_ext_crypto_"s + Suite::Name + "_generate_version_1",
      TEST_KEY_TYPE, boost::make_optional(seed)
    );

    auto sig = environment.execute<boost::optional<typename Suite::Signature>>(
      "rtm_ext_crypto_"s + Suite::Name + "_sign_version_1",
      TEST_KEY_TYPE, pk, message
    ).value();

    std::cout << "Message: " << message << std::endl;
    std::cout << "Public key: " << pk.toHex() << std::endl;
    std::cout << "Signature: " << sig.toHex() << std::endl;
  }

  template <typename Suite>
  void processVerify(std::string_view seed, std::string_view message) {
    helpers::RuntimeEnvironment environment;

    auto pk = environment.execute<typename Suite::PublicKey>(
      "rtm_ext_crypto_"s + Suite::Name + "_generate_version_1",
      TEST_KEY_TYPE, boost::make_optional(seed)
    );
    auto sig = environment.execute<boost::optional<typename Suite::Signature>>(
      "rtm_ext_crypto_"s + Suite::Name + "_sign_version_1",
      TEST_KEY_TYPE, pk, message
    ).value();

    auto verified = environment.execute<bool>(
      "rtm_ext_crypto_"s + Suite::Name + "_verify_version_1",
      sig, message, pk
    );

    std::cout << "Message: " << message << std::endl;
    std::cout << "Public key: " << pk.toHex() << std::endl;
    std::cout << "Signature: " << sig.toHex() << std::endl;

    if (verified) {
      std::cout << "GOOD SIGNATURE" << std::endl;
    } else {
      std::cout << "BAD SIGNATURE" << std::endl;
    }
  }


  void processEd25519PublicKeys(const std::string_view seed1, const std::string_view seed2) {
    processPublicKeys<Ed25519Suite>(seed1, seed2);
  }

  void processEd25519Generate(const std::string_view seed) {
    processGenerate<Ed25519Suite>(seed);
  }

  void processEd25519Sign(const std::string_view seed, const std::string_view message) {
    processSign<Ed25519Suite>(seed, message);
  }

  void processEd25519Verify(const std::string_view seed, const std::string_view message) {
    processVerify<Ed25519Suite>(seed, message);
  }


  void processSr25519PublicKeys(const std::string_view seed1, const std::string_view seed2) {
    processPublicKeys<Sr25519Suite>(seed1, seed2);
  }

  void processSr25519Generate(const std::string_view seed) {
    processGenerate<Sr25519Suite>(seed);
  }

  void processSr25519Sign(const std::string_view seed, const std::string_view message) {
    processSign<Sr25519Suite>(seed, message);
  }

  void processSr25519Verify(const std::string_view seed, const std::string_view message) {
    processVerify<Sr25519Suite>(seed, message);
  }
}
