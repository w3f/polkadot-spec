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

#pragma once

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
