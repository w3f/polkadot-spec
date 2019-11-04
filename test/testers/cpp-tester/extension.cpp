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
  router.addSubcommand("test_clear_prefix", [](int argc, char **argv) {
    processExtClearPrefix(extractClearPrefixArgs(argc, argv));
  });

  std::string commands_list = "Valid function are: ";
  for (auto &&name : router.collectSubcommandNames()) {
    commands_list += name;
    commands_list += " ";
  }
  auto e1 = "function is not provided\n" + commands_list;
  auto e2 = "Invalid function\n" + commands_list;
  BOOST_ASSERT_MSG(argc > 1, e1.data());
  BOOST_ASSERT_MSG(router.executeSubcommand(argv[1], argc - 2, argv + 2),
                   e2.data());
}
