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

#include "helpers.hpp"

#include <binaryen/shell-interface.h>

#include <crypto/pbkdf2/impl/pbkdf2_provider_impl.hpp>
#include <crypto/random_generator/boost_generator.hpp>
#include <crypto/ed25519/ed25519_provider_impl.hpp>
#include <crypto/sr25519/sr25519_provider_impl.hpp>
#include <crypto/secp256k1/secp256k1_provider_impl.hpp>
#include <crypto/hasher/hasher_impl.hpp>
#include <crypto/crypto_store/crypto_store_impl.hpp>
#include <crypto/bip39/impl/bip39_provider_impl.hpp>

#include <storage/in_memory/in_memory_storage.hpp>
#include <storage/trie/polkadot_trie/polkadot_trie_factory_impl.hpp>
#include <storage/trie/serialization/polkadot_codec.hpp>
#include <storage/trie/serialization/trie_serializer_impl.hpp>
#include <storage/trie/impl/trie_storage_backend_impl.hpp>
#include <storage/trie/impl/trie_storage_impl.hpp>
#include <storage/changes_trie/impl/storage_changes_tracker_impl.hpp>

#include <runtime/common/trie_storage_provider_impl.hpp>
#include <runtime/binaryen/wasm_memory_impl.hpp>

#include <extensions/impl/extension_impl.hpp>


using kagome::common::Buffer;

using kagome::crypto::Bip39ProviderImpl;
using kagome::crypto::BoostRandomGenerator;
using kagome::crypto::CryptoStoreImpl;
using kagome::crypto::ED25519ProviderImpl;
using kagome::crypto::HasherImpl;
using kagome::crypto::Pbkdf2ProviderImpl;
using kagome::crypto::Secp256k1ProviderImpl;
using kagome::crypto::SR25519ProviderImpl;

using kagome::runtime::TrieStorageProvider;
using kagome::runtime::TrieStorageProviderImpl;

using kagome::storage::changes_trie::StorageChangesTrackerImpl;
using kagome::storage::trie::PolkadotCodec;
using kagome::storage::trie::PolkadotTrieFactoryImpl;
using kagome::storage::trie::PolkadotTrieImpl;
using kagome::storage::trie::TrieSerializerImpl;
using kagome::storage::trie::TrieStorage;
using kagome::storage::trie::TrieStorageImpl;


namespace helpers {

  // Global instance of wasm shell (probably not thread safe)
  wasm::ShellExternalInterface GLOBAL_WASM_SHELL;

  // Initialize kagome wasm host extensions
  std::unique_ptr<kagome::extensions::Extension> initialize_extension() {

    // Build storage provider
    auto backend = std::make_shared<kagome::storage::trie::TrieStorageBackendImpl>(
      std::make_shared<kagome::storage::InMemoryStorage>(),
      kagome::common::Buffer{}
    );

    auto trie_factory = std::make_shared<PolkadotTrieFactoryImpl>();
    auto codec        = std::make_shared<PolkadotCodec>();
    auto serializer   = std::make_shared<TrieSerializerImpl>(
      trie_factory, codec, backend
    );

    auto trie_db = kagome::storage::trie::TrieStorageImpl::createEmpty(
      trie_factory, codec, serializer, boost::none
    ).value();

    auto storage_provider = std::make_shared<TrieStorageProviderImpl>(
      std::move(trie_db)
    );
    storage_provider->setToPersistent(); // Remove when using runtime manager

    // Build change tracker
    auto tracker = std::make_shared<StorageChangesTrackerImpl>(
      trie_factory, codec
    );

    // Build crypto providers
    auto pbkdf2_provider    = std::make_shared<Pbkdf2ProviderImpl>();
    auto random_generator   = std::make_shared<BoostRandomGenerator>();
    auto ed25519_provider   = std::make_shared<ED25519ProviderImpl>();
    auto sr25519_provider   = std::make_shared<SR25519ProviderImpl>(
      random_generator
    );
    auto secp256k1_provider = std::make_shared<Secp256k1ProviderImpl>();
    auto hasher             = std::make_shared<HasherImpl>();
    auto bip39_provider     = std::make_shared<Bip39ProviderImpl>(
      pbkdf2_provider
    );
    auto crypto_store       = std::make_shared<CryptoStoreImpl>(
      ed25519_provider,
      sr25519_provider,
      secp256k1_provider,
      bip39_provider,
      random_generator
    );

    // Initialize Wasm memory
    std::shared_ptr<kagome::runtime::WasmMemory> memory =
      std::make_shared<kagome::runtime::binaryen::WasmMemoryImpl>(
        &GLOBAL_WASM_SHELL.memory, 4096
      );

    // Final assembly
    return std::make_unique<kagome::extensions::ExtensionImpl>(
      memory,
      storage_provider,
      tracker,
      sr25519_provider,
      ed25519_provider,
      secp256k1_provider,
      hasher,
      crypto_store,
      bip39_provider
    );
  }

} // namespace helper
