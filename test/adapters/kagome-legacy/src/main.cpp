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

#include <iostream>

#define BOOST_ENABLE_ASSERT_HANDLER
#include <boost/assert.hpp>

#include <boost/optional.hpp>
#include <boost/program_options.hpp>

#include <common/logger.hpp>

#include "subcommand_router.hpp"

#include "extension.hpp"

//! Helpers to print asserts and associated messages
namespace boost {
  void assertion_failed(char const * expr, char const * function, char const * file, long line) {
    std::cout << "Assert inside function '" << function
              << "' in file '" << file
              << "' on line '" << line
              << "' when evaluating '" << expr
              << "'" << std::endl;
  }
  void assertion_failed_msg(char const * expr, char const * msg, char const * function, char const * file, long line) {
    std::cout << "Error inside function '" << function
              << "' in file '" << file
              << "' on line '" << line
              << "' when evaluating '" << expr
              << "': " << msg << std::endl;
  }
}


/**
 * Implementation of Polkadot Host API, SCALE codec and Merkle-Patricia
 * Tree compatibility tests
 */
int main(int argc, char **argv) {
  kagome::common::setLogLevel(kagome::common::LogLevel::off);

  SubcommandRouter<int, char **> router;
  router.addSubcommand("host-api", [](int argc, char **argv) {
    processExtensionsCommands(extractExtensionArgs(argc, argv));
  });

  std::string commands_list = "Valid subcommands are: ";
  for (auto &&name : router.collectSubcommandNames()) {
    commands_list += name;
    commands_list += " ";
  }

  auto e1 = "Subcommand is not provided\n" + commands_list;
  auto e2 = "Invalid subcommand\n" + commands_list;
  BOOST_ASSERT_MSG(argc > 1, e1.data());
  BOOST_VERIFY_MSG(router.executeSubcommand(argv[1], argc - 1, argv + 1),
                   e2.data());

  return 0;
}
