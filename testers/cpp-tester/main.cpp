#include <iostream>

#define BOOST_ENABLE_ASSERT_HANDLER
#include <boost/assert.hpp>

#include <boost/optional.hpp>
#include <boost/program_options.hpp>

#include "subcommand_router.hpp"

#include "scale_codec.hpp"
#include "trie.hpp"
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
              << "':" << msg << std::endl;
  }
}


/**
 * Implementation of Polkadot RE compatibility tests
 * Contains tests for SCALE codec and Merkle-Patricia Tree
 */
int main(int argc, char **argv) {
  SubcommandRouter<int, char **> router;
  router.addSubcommand("scale-codec", [](int argc, char **argv) {
    processScaleCodecCommand(extractScaleArgs(argc, argv));
  });
  router.addSubcommand("state-trie", [](int argc, char **argv) {
    processTrieCommand(extractTrieArgs(argc, argv));
  });
  router.addSubcommand("pdre-api", [](int argc, char **argv) {
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
