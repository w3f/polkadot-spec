// Copyright (c) 2019 Web3 Technologies Foundation

// This file is part of Polkadot RE Test Suite

// Polkadot RE Test Suite is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// Polkadot RE Tests is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with Foobar.  If not, see <https://www.gnu.org/licenses/>.

// this file provide a command line interface to call scale codec go library

package main

import (
	"encoding/hex"
	"flag"
	"fmt"
	"github.com/ChainSafe/gossamer/polkadb"
	"github.com/ChainSafe/gossamer/trie"
	"github.com/go-yaml/yaml"
	"io/ioutil"
	"log"
	"os"
)

func ProcessStateTrieCommand(scale_codec_command *flag.FlagSet, command_args []string) {
	//here we need to parse the args related to scale_codec

	// Subcommands
	stateRootCommand := flag.NewFlagSet("trie-root", flag.ExitOnError)

	// state-file subcommand flag pointers
	stateFilePtr := stateRootCommand.String("state-file", "", "YAML file containing the state")
	keysInHexPtr := stateRootCommand.Bool("keys-in-hex", false, "keys in the YAML file are treated as hex entries")

	// Verify that a subcommand has been provided
	if len(command_args) < 1 {
		fmt.Println("trie-root subcommand is required")
		os.Exit(1)
	}

	// Switch on the subcommand
	// Parse the flags for appropriate FlagSet
	switch command_args[0] {
	case "trie-root":
		stateRootCommand.Parse(command_args[1:])

	default:
		flag.PrintDefaults()
		os.Exit(1)
	}

	// Check which subcommand was Parsed using the FlagSet.Parsed() function. Handle each case accordingly.
	// FlagSet.Parse() will evaluate to false if no flags were parsed
	if stateRootCommand.Parsed() {
		// Required Flags
		if *stateFilePtr == "" {
			stateRootCommand.PrintDefaults()
			os.Exit(1)
		}

		//Insert all (key, value) pairs in the YAML file into state trie.
		key_value_data := &KeyValueData{}
		state_data_file, err := ioutil.ReadFile(*stateFilePtr)

		if err != nil {
			log.Fatal(err)
		}

		err = yaml.Unmarshal(state_data_file, &key_value_data)
		if err != nil {
			log.Fatal(err)
		}

		db := trie.Database{
			Db: polkadb.NewMemDatabase(),
		}
		test_trie := trie.NewEmptyTrie(&db)

		for i, key := range key_value_data.Keys {
			var keyBytes []byte
			var err error
			if *keysInHexPtr {
				keyBytes, err = hex.DecodeString(key)
				if err != nil {
					log.Fatal(err)
				}
			} else {
				keyBytes = []byte(key)
			}
			err = test_trie.Put(keyBytes, []byte(key_value_data.Values[i]))
			if err != nil {
				return
			}
		}

		hash, err := test_trie.Hash()
		if err != nil {
			log.Fatal(err)
		}
		fmt.Printf("state root: %x\n", hash)
	}

}
