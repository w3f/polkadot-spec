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

#include "assert.hpp"

#include <boost/optional.hpp>
#include <boost/program_options.hpp>

#include <common/logger.hpp>

#include "subcommand_router.hpp"

#include "extension.hpp"

#include <cerrno>

/**
 * Implementation of Polkadot Host API, SCALE codec and Merkle-Patricia
 * Tree compatibility tests
 */
int main(int argc, char **argv) {
  // Disable all logging
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
  BOOST_ASSERT_MSG(argc > 1, e1.data());

  try {
    auto e2 = "Invalid subcommand\n" + commands_list;
    BOOST_VERIFY_MSG(router.executeSubcommand(argv[1], argc - 1, argv + 1), e2.data());
  } catch (const NotImplemented &e) {
    return EOPNOTSUPP;
  }

  return 0;
}
