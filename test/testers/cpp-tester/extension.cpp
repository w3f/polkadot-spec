/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#include "extension.hpp"
#include "extension/storage.hpp"
#include "subcommand_router.hpp"
#include <boost/optional.hpp>

void processExtensionsCommands(int argc, char **argv){
  SubcommandRouter<int, char **> router;

  // test storage functions
  router.addSubcommand("test_clear_prefix", [](int argc, char **argv) {
    processExtClearPrefix(extractClearPrefixArgs(argc, argv));
  });
  router.addSubcommand("test_clear_storage", [](int argc, char **argv) {
    processExtClearStorage(extractClearStorageArgs(argc, argv));
  });
  router.addSubcommand("test_allocate_storage", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });
  router.addSubcommand("test_exists_storage", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });
  router.addSubcommand("test_set_get_local_storage", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });
  router.addSubcommand("test_set_get_storage", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });
  router.addSubcommand("test_storage_root", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });

  // test crypto functions
  router.addSubcommand("test_blake2_128", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });
  router.addSubcommand("test_blake2_256", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });
  router.addSubcommand("test_ed25519", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });
  router.addSubcommand("test_keccak_256", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });
  router.addSubcommand("test_sr25519", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });
  router.addSubcommand("test_twox_64", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });
  router.addSubcommand("test_twox_128", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });
  router.addSubcommand("test_twox_256", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });

  // test child storage functions
  router.addSubcommand("test_clear_child_prefix", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });
  router.addSubcommand("test_clear_child_storage", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });
  router.addSubcommand("test_exists_child_storage", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });
  router.addSubcommand("test_kill_child_storage", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });
  router.addSubcommand("test_set_get_child_storage", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });

  // test network functions
  router.addSubcommand("test_http", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });
  router.addSubcommand("test_network_state", [](int argc, char **argv) {
    BOOST_ASSERT(true); // Not tested
  });

  std::string commands_list = "Valid function are: ";
  for (auto &&name : router.collectSubcommandNames()) {
    commands_list += name;
    commands_list += " ";
  }
  auto e1 = "function is not provided\n" + commands_list;
  auto e2 = "Invalid function\n" + commands_list;
  BOOST_ASSERT_MSG(argc > 1, e1.data());
  BOOST_ASSERT_MSG(router.executeSubcommand(argv[2], argc - 2, argv + 2),
                   e2.data());
}
