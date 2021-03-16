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

#include "state_trie.hpp"

#include "assert.hpp"

#include <boost/program_options.hpp>

#include <yaml-cpp/yaml.h>

#include <storage/in_memory/in_memory_storage.hpp>
#include <storage/trie/polkadot_trie/polkadot_trie_factory_impl.hpp>
#include <storage/trie/serialization/polkadot_codec.hpp>
#include <storage/trie/serialization/trie_serializer_impl.hpp>
#include <storage/trie/impl/trie_storage_backend_impl.hpp>
#include <storage/trie/impl/trie_storage_impl.hpp>

#include "subcommand.hpp"

#include <iostream>


namespace po = boost::program_options;

using kagome::common::Buffer;
using kagome::common::hex_lower;
using kagome::common::unhex;

using kagome::storage::InMemoryStorage;
using kagome::storage::trie::PolkadotCodec;
using kagome::storage::trie::PolkadotTrieFactoryImpl;
using kagome::storage::trie::PolkadotTrieImpl;
using kagome::storage::trie::TrieSerializerImpl;
using kagome::storage::trie::TrieStorageImpl;
using kagome::storage::trie::TrieStorageBackendImpl;

TrieCommandArgs extractTrieArgs(int argc, char **argv) {
  po::options_description desc("Trie codec related tests\nAllowed options:");
  boost::optional<std::string> subcommand;
  boost::optional<std::string> state_file_name;
  bool keys_in_hex;
  bool log_trie;

  // clang-format off
  desc.add_options()
      ("help", "produce help message")
      ("trie-subcommand",
          po::value(&subcommand), "specify a subcommand")
      ("keys-in-hex",
          po::bool_switch(&keys_in_hex)->default_value(false),
          "regard the keys in the trie file as hex values"
          " and convert them to binary before inserting into the trie")
      ("state-file,i",
          po::value(&state_file_name)->required(),
          "the file containing the key value data defining the state")
      ("print-trie",
          po::bool_switch(&log_trie)->default_value(false),
          "Print Trie to stdout");
  // clang-format on

  po::positional_options_description pd;
  pd.add("trie-subcommand", 1);

  po::variables_map vm;
  po::store(
      po::command_line_parser(argc, argv).options(desc).positional(pd).run(),
      vm);
  po::notify(vm);

  BOOST_ASSERT_MSG(subcommand, "Subcommand is not stated");
  BOOST_ASSERT_MSG(state_file_name, "State file name is not provided");

  return TrieCommandArgs{.subcommand = *subcommand,
                         .keys_in_hex = keys_in_hex,
                         .log_trie = log_trie,
                         .state_file_name = *state_file_name};
}

std::pair<std::vector<Buffer>, std::vector<Buffer>>
parseYamlStateFile(const std::string &filename, bool keys_in_hex) {
  YAML::Node state = YAML::LoadFile(filename);
  std::vector<Buffer> keys;
  keys.reserve(state["keys"].size());

  for (auto &&key_entry : state["keys"]) {
    Buffer b_key;
    auto key_str = key_entry.as<std::string>();
    if (keys_in_hex) {
      auto res = unhex(key_str);
      BOOST_ASSERT_MSG(res, "Invalid hex key");
      b_key = Buffer{res.value()};
    } else {
      std::copy(key_str.begin(), key_str.end(),
                std::back_inserter(b_key.asVector()));
    }
    keys.push_back(b_key);
  }

  std::vector<Buffer> values;
  values.reserve(state["values"].size());
  for (auto &&val_entry : state["values"]) {
    Buffer b_val;
    auto val_str = val_entry.as<std::string>();
    std::copy(val_str.begin(), val_str.end(),
              std::back_inserter(b_val.asVector()));
    values.push_back(b_val);
  }
  BOOST_ASSERT_MSG(keys.size() == values.size(),
                   "Keys and values sizes differ");
  return {keys, values};
}

void processTrieCommand(const TrieCommandArgs &args) {
  // Initialize empty trie
  auto backend = std::make_shared<TrieStorageBackendImpl>(
    std::make_shared<InMemoryStorage>(),
    kagome::common::Buffer{}
  );

  auto trie_factory = std::make_shared<PolkadotTrieFactoryImpl>();
  auto codec        = std::make_shared<PolkadotCodec>();
  auto serializer   = std::make_shared<TrieSerializerImpl>(
    trie_factory, codec, backend
  );

  auto trie_db = TrieStorageImpl::createEmpty(
    trie_factory, codec, serializer, boost::none
  ).value();

  auto trie = trie_db->getPersistentBatch().value();

  // Execute requested command
  SubcommandRouter<std::vector<Buffer>, std::vector<Buffer>> router;
  router.addSubcommand("insert-and-delete", [&trie, &args](
                                                std::vector<Buffer> keys,
                                                std::vector<Buffer> values) {
    for (auto keys_it = keys.begin(), values_it = values.begin();
         keys_it != keys.end(); keys_it++, values_it++) {
      auto res = trie->put(*keys_it, *values_it);
      BOOST_ASSERT_MSG(res, "Error inserting to Trie");
      std::cout << "state root: " << hex_lower(trie->commit().value()) << "\n";
    }
    // drop random nodes
    while (not keys.empty()) {
      auto key_index_to_drop = trie->commit().value()[0] % keys.size();
      auto key_to_drop = keys.begin();
      std::advance(key_to_drop, key_index_to_drop);
      BOOST_ASSERT_MSG(trie->remove(*key_to_drop), "Error removing from Trie");
      std::cout << "state root: " << hex_lower(trie->commit().value()) << "\n";
      keys.erase(key_to_drop);
    }
  });
  router.addSubcommand("trie-root", [&trie, &args](std::vector<Buffer> keys,
                                                   std::vector<Buffer> values) {
    for (auto keys_it = keys.begin(), values_it = values.begin();
         keys_it != keys.end(); keys_it++, values_it++) {
      BOOST_ASSERT_MSG(trie->put(*keys_it, *values_it),
                       "Error inserting to Trie");
    }
    std::cout << "state root: " << hex_lower(trie->commit().value()) << "\n";
  });

  auto [keys, values] =
      parseYamlStateFile(args.state_file_name, args.keys_in_hex);

  BOOST_VERIFY_MSG(router.executeSubcommand(args.subcommand, std::move(keys),
                                            std::move(values)),
                   "Invalid subcommand");
}
