#include <boost/program_options.hpp>
#include <boost/optional.hpp>
#include "subcommand_router.hpp"
#include "scale_codec.hpp"
#include "trie.hpp"

namespace po = boost::program_options;

/**
 * Implementation of Polkadot RE compatibility tests
 * Contains tests for SCALE codec and Merkle-Patricia Tree
 */

int main(int argc, char **argv) {
  SubcommandRouter<int, char **> router;
  router.addSubcommand("scale-codec", [](int argc, char** argv) {
    processScaleCodecCommand(extractScaleArgs(argc, argv));
  });
  router.addSubcommand("state-trie", [](int argc, char** argv) {
    processTrieCommand(extractTrieArgs(argc, argv));
  });

  std::string commands_list = "Valid subcommands are: ";
  for (auto &&name : router.collectSubcommandNames()) {
    commands_list += name;
    commands_list += " ";
  }
  auto e1 = "Subcommand is not provided\n" + commands_list;
  auto e2 = "Invalid subcommand\n" + commands_list;
  BOOST_ASSERT_MSG(argc > 1, e1.data());
  BOOST_ASSERT_MSG(router.executeSubcommand(argv[1], argc - 1, argv + 1),
                   e2.data());

  return 0;
}
