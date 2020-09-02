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

#include "scale_codec.hpp"

#include "assert.hpp"

#include <boost/optional.hpp>
#include <boost/program_options.hpp>

#include <common/hexutil.hpp>
#include <common/logger.hpp>
#include <scale/scale.hpp>

#include "subcommand.hpp"

#include <iostream>


namespace po = boost::program_options;

ScaleCommandArgs extractScaleArgs(int argc, char **argv) {
  po::options_description desc("SCALE codec related tests\nAllowed options:");
  boost::optional<std::string> subcommand;
  boost::optional<std::string> input;
  // clang-format off
  desc.add_options()
      ("help", "produce help message")
      ("subcommand", po::value(&subcommand)->required(), "specify a subcommand")
      ("input,i", po::value(&input)->required(), "the string to be encoded");
  // clang-format on

  po::positional_options_description pd;
  pd.add("subcommand", 1);

  po::variables_map vm;
  po::store(
      po::command_line_parser(argc, argv).options(desc).positional(pd).run(),
      vm);
  po::notify(vm);

  BOOST_ASSERT_MSG(subcommand, "Subcommand is not stated");
  BOOST_ASSERT_MSG(input, "Input string is not provided");

  return ScaleCommandArgs { .subcommand = *subcommand, .input = *input};
}



void processScaleCodecCommand(ScaleCommandArgs args) {
  SubcommandRouter<std::string> router;
  router.addSubcommand("encode", [](std::string input) {
    auto res = kagome::scale::encode(input);
    BOOST_ASSERT_MSG(res, "Encode error");
    std::cout << "encoded " << input << ": [";
    bool first = true;
    for(auto byte: res.value()) {
      if(not first) {
        std::cout << ", ";
      } else {
        first = false;
      }
      std::cout << std::hex << (int)byte;
    }
    std::cout << "]\n";
  });

  BOOST_VERIFY_MSG(
      router.executeSubcommand(args.subcommand,
                               args.input),
      "Invalid subcommand");
}
