/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#include "scale_codec.hpp"

#include <iostream>

#include "kagome/common/hexutil.hpp"
#include "kagome/common/logger.hpp"
#include "kagome/scale/scale.hpp"
#include <boost/optional.hpp>
#include <boost/program_options.hpp>

#include "subcommand_router.hpp"

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

  BOOST_ASSERT_MSG(
      router.executeSubcommand(args.subcommand,
                               args.input),
      "Invalid subcommand");
}
