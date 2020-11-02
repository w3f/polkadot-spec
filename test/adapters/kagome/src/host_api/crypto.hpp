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

#ifndef KAGOMECROSSTESTCLI_CRYPTO_EXTENSION_HPP
#define KAGOMECROSSTESTCLI_CRYPTO_EXTENSION_HPP

#include <memory>
#include <string>
#include <vector>

#include <crypto/ed25519_types.hpp>
#include <crypto/sr25519_types.hpp>

#include "../kagome_prelude.hpp"
#include "helpers.hpp"

// TODO update and implement module
namespace crypto {

using namespace kagome::crypto;
using std::string_literals::operator""s;

template <typename TKeypair, typename TSeed, typename TPublicKey,
          typename TSecretKey, typename TSignature, const char *CPrefix>
struct CryptoSuite {
  using Keypair = TKeypair;
  using Seed = TSeed;
  using PublicKey = TPublicKey;
  using SecreyKey = TSecretKey;
  using Signature = TSignature;
  static constexpr const char *Prefix = CPrefix;
};

extern char kSrPrefix[8];
extern char kEdPrefix[8];
using Ed25519Suite =
    CryptoSuite<Ed25519Keypair, Ed25519Seed, Ed25519PublicKey,
                Ed25519PrivateKey, Ed25519Signature, kEdPrefix>;
using Sr25519Suite = CryptoSuite<Sr25519Keypair, Sr25519Seed, Sr25519PublicKey,
                                 Sr25519SecretKey, Sr25519Signature, kSrPrefix>;

class CryptoExtensionTestSuite {
public:
  CryptoExtensionTestSuite(std::shared_ptr<helpers::RuntimeEnvironment> env,
                           kagome::common::Logger logger,
                           std::ostream &out)
      : env_{std::move(env)}, logger_{std::move(logger)}, out_{out} {
    BOOST_ASSERT(env_ != nullptr);
    BOOST_ASSERT(logger_ != nullptr);
    BOOST_ASSERT(out_);
  }

  template <typename Suite>
  void process_ext_public_keys(std::string_view seed1, std::string_view seed2) {
    kagome::runtime::WasmSize key_type = 0xDEADBEEF;
    auto pk_bytes1 = env_->execute<Buffer>(
        "rtm_ext_crypto_"s + Suite::Prefix + "_generate_version_1",
        key_type, boost::make_optional(seed1));
    auto pk1 = Suite::PublicKey::fromSpan(pk_bytes1).value();

    auto pk_bytes2 = env_->execute<Buffer>(
        "rtm_ext_crypto_"s + Suite::Prefix + "_generate_version_1",
        key_type, boost::make_optional(seed2));
    auto pk2 = Suite::PublicKey::fromSpan(pk_bytes2).value();

    auto keys = env_->execute<Buffer>("rtm_ext_crypto_"s + Suite::Prefix +
                                          "_public_keys_version_1",
                                      key_type);
    auto dec_keys =
        scale::decode<std::vector<typename Suite::PublicKey>>(keys).value();
    BOOST_ASSERT(dec_keys.size() == 2);
    auto res1 = dec_keys.at(0);
    auto res2 = dec_keys.at(1);
    BOOST_ASSERT(pk1 == res1 or pk1 == res2);
    BOOST_ASSERT(pk2 == res2 or pk2 == res1);
    out_ << "1. Public key: " << hex_lower(res1) << "\n";
    out_ << "2. Public key: " << hex_lower(res2) << "\n";
  }

  template <typename Suite> void process_ext_generate(std::string_view seed) {
    kagome::runtime::WasmSize key_type = 0xDEADBEEF;
    auto pk_bytes = env_->execute<Buffer>("rtm_ext_crypto_"s + Suite::Prefix +
                                              "_generate_version_1",
                                          key_type, boost::make_optional(seed));
    out_ << pk_bytes.toHex() << "\n";
  }

  template <typename Suite>
  void process_ext_sign(std::string_view seed, std::string_view message) {
    kagome::runtime::WasmSize key_type = 0xDEADBEEF;
    auto msg = Buffer::fromString(std::string(message)).value();

    auto pk_bytes = env_->execute<Buffer>("rtm_ext_crypto_"s + Suite::Prefix +
                                              "_generate_version_1",
                                          key_type, boost::make_optional(seed));
    auto sig_bytes = env_->execute<Buffer>("rtm_ext_crypto_"s + Suite::Prefix +
                                               "_sign_version_1",
                                           key_type, pk_bytes, msg);
    auto sig =
        scale::decode<boost::optional<typename Suite::Signature>>(sig_bytes)
            .value()  // result
            .value(); // optional;
    std::cout << "Message: " << msg << "\n";
    std::cout << "Public key: " << pk_bytes.toHex() << "\n";
    std::cout << "Signature: " << sig.toHex() << "\n";
  }

  template <typename Suite>
  void process_ext_verify(std::string_view seed, std::string_view message) {
    kagome::runtime::WasmSize key_type = 0xDEADBEEF;
    auto msg = Buffer::fromString(std::string(message)).value();

    auto pk_bytes = env_->execute<Buffer>("rtm_ext_crypto_"s + Suite::Prefix +
                                              "_generate_version_1",
                                          key_type, boost::make_optional(seed));
    auto sig_bytes = env_->execute<Buffer>("rtm_ext_crypto_"s + Suite::Prefix +
                                               "_sign_version_1",
                                           key_type, pk_bytes, msg);
    auto sig =
        scale::decode<boost::optional<typename Suite::Signature>>(sig_bytes)
            .value()  // result
            .value(); // optional;

    auto verified = env_->execute<int32_t>("rtm_ext_crypto_"s + Suite::Prefix +
                                               "_verify_version_1",
                                           gsl::make_span(sig), msg, pk_bytes);

    std::cout << "Message: " << msg << "\n";
    std::cout << "Public key: " << pk_bytes.toHex() << "\n";
    std::cout << "Signature: " << sig.toHex() << "\n";
    if (verified) {
      std::cout << "GOOD SIGNATURE\n";
    } else {
      std::cout << "BAD SIGNATURE\n";
    }
  }

private:
  std::shared_ptr<helpers::RuntimeEnvironment> env_;
  kagome::common::Logger logger_;
  std::ostream &out_;
};

} // namespace crypto

#endif // KAGOMECROSSTESTCLI_CRYPTO_EXTENSION_HPP
