/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef KAGOMECROSSTESTCLI_TRIE_HPP
#define KAGOMECROSSTESTCLI_TRIE_HPP

#include <string>

// Trie test args
struct TrieCommandArgs {
    std::string subcommand;
    bool keys_in_hex;
    bool log_trie;
    std::string state_file_name;
};

// parses CLI input
TrieCommandArgs extractTrieArgs(int argc, char **argv);

// executes Trie tests according to provided args
void processTrieCommand(const TrieCommandArgs& args);

#endif //KAGOMECROSSTESTCLI_TRIE_HPP
