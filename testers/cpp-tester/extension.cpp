/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#define BOOST_ENABLE_ASSERT_HANDLER
#include <boost/assert.hpp>

#include <boost/optional.hpp>
#include <boost/program_options.hpp>

#include "extension.hpp"
#include "extension/storage.hpp"
#include "extension/network.hpp"
#include "extension/crypto.hpp"
#include "extension/child_storage.hpp"

#include "subcommand_router.hpp"

namespace po = boost::program_options;

ExtensionCommandArgs extractExtensionArgs(int argc, char **argv){
  po::options_description desc("Extension codec related tests\nAllowed options:");
  boost::optional<std::string> function;
  boost::optional<std::string> inputStr;

  // clang-format off
  desc.add_options()
      ("help", "produce help message")
      ("function",
       po::value(&function), "specify a fucntion")
      ("input",
       po::value(&inputStr), "specify a input");
  // clang-format on

  po::positional_options_description pd;
  pd.add("function", 1);

  po::variables_map vm;
  po::store(
      po::command_line_parser(argc, argv).options(desc).positional(pd).run(),
      vm);
  po::notify(vm);

  BOOST_ASSERT_MSG(function, "Function is not stated");
  BOOST_ASSERT_MSG(inputStr, "Input data is not provided");

  ExtensionCommandArgs args;

  args.function = *function;

  std::stringstream inputStream(*inputStr);
  std::string inputElement;
  while(std::getline(inputStream, inputElement, ','))
  {
    args.input.push_back(inputElement);
  }

  return std::move(args);
}

void processExtensionsCommands(const ExtensionCommandArgs& args){
  SubcommandRouter<const std::vector<std::string>&> router;

  // test storage functions
  router.addSubcommand("test_clear_prefix", [](const std::vector<std::string>& args) {
    storage::processExtClearPrefix(args);
  });
  router.addSubcommand("test_clear_storage", [](const std::vector<std::string>& args) {
    storage::processExtClearStorage(args);
  });
  router.addSubcommand("test_exists_storage", [](const std::vector<std::string>& args) {
    storage::processExtExistsStorage(args);
  });
  router.addSubcommand("test_set_get_storage", [](const std::vector<std::string>& args) {
    storage::processExtGetAllocatedStorage(args);
  });
  router.addSubcommand("test_allocate_storage", [](const std::vector<std::string>& args) {
    storage::processExtAllocatedStorage(args);
  });
  router.addSubcommand("test_set_get_local_storage", [](const std::vector<std::string>& args) {
    //storage::processExtGetAllocatedStorage(args); TODO: not implemented
  });
  router.addSubcommand("test_set_get_storage_into", [](const std::vector<std::string>& args) {
    storage::processExtGetAllocatedStorageInto(args);
  });
  router.addSubcommand("test_storage_root", [](const std::vector<std::string>& args) {
    storage::processExtStorageRoot(args);
  });
  router.addSubcommand("test_local_storage_compare_and_set", [](const std::vector<std::string>& args) {
    //storage::processExtGetAllocatedStorage(args); TODO: not implemented
  });
  router.addSubcommand("test_blake2_256_enumerated_trie_root", [](const std::vector<std::string>& args) {
    storage::processExtBlake2_256EnumeratedTrieRoot(args);
  });

  // test crypto functions
  router.addSubcommand("test_blake2_128", [](const std::vector<std::string>& args) {
    crypto::processExtBlake2_128(args);
  });
  router.addSubcommand("test_blake2_256", [](const std::vector<std::string>& args) {
    crypto::processExtBlake2_256(args);
  });
  router.addSubcommand("test_ed25519", [](const std::vector<std::string>& args) {
    crypto::processExtEd25519(args);
  });
  router.addSubcommand("test_keccak_256", [](const std::vector<std::string>& args) {
    crypto::processExtKeccak256(args);
  });
  router.addSubcommand("test_sr25519", [](const std::vector<std::string>& args) {
    crypto::processExtSr25519(args);
  });
  router.addSubcommand("test_twox_64", [](const std::vector<std::string>& args) {
    crypto::processExtTwox64(args);
  });
  router.addSubcommand("test_twox_128", [](const std::vector<std::string>& args) {
    crypto::processExtTwox128(args);
  });
  router.addSubcommand("test_twox_256", [](const std::vector<std::string>& args) {
    crypto::processExtTwox256(args);
  });

  //test child storage functions
  router.addSubcommand("test_clear_child_prefix", [](const std::vector<std::string>& args) {
    //child_storage::processExtClearChildPrefix(args);
  });
  router.addSubcommand("test_child_storage_root", [](const std::vector<std::string>& args) {
    //child_storage::processExtClearChildPrefix(args);
  });
  router.addSubcommand("test_get_child_storage_into", [](const std::vector<std::string>& args) {
    //child_storage::processExtClearChildPrefix(args);
  });
  router.addSubcommand("test_clear_child_storage", [](const std::vector<std::string>& args) {
    //child_storage::processExtClearChildStorage(args);
  });
  router.addSubcommand("test_exists_child_storage", [](const std::vector<std::string>& args) {
    //child_storage::processExtExistsChildStorage(args);
  });
  router.addSubcommand("test_kill_child_storage", [](const std::vector<std::string>& args) {
    //child_storage::processExtKillChildStorage(args);
  });
  router.addSubcommand("test_set_get_child_storage", [](const std::vector<std::string>& args) {
    //child_storage::processExtSetGetChildStorage(args);
  });

  // test network functions
  router.addSubcommand("test_http", [](const std::vector<std::string>& args) {
    network::processExtHttp(args);
  });
  router.addSubcommand("test_network_state", [](const std::vector<std::string>& args) {
    network::processExtNetworkState(args);
  });

  std::string commands_list = "Valid function are: ";
  for (auto &&name : router.collectSubcommandNames()) {
    commands_list += name;
    commands_list += " ";
  }
  auto e1 = "function is not provided\n" + commands_list;
  auto e2 = "Invalid function\n" + commands_list;
  BOOST_VERIFY_MSG(router.executeSubcommand(args.function, args.input),
                   "Invalid function");
}
