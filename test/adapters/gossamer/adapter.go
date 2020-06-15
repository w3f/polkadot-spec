// Copyright (c) 2019 Web3 Technologies Foundation

// This file is part of Polkadot Host Test Suite

// Polkadot Host Test Suite is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// Polkadot Host Tests is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with Foobar.  If not, see <https://www.gnu.org/licenses/>.

// this file provide a command line interface to call scale codec go library

package main

import (
	"flag"
	"fmt"
	"os"
)

func main() {

	// Subcommands
	codecCommand := flag.NewFlagSet("scale-codec", flag.ExitOnError)
	trieCommand := flag.NewFlagSet("state-trie", flag.ExitOnError)
	trieCommand := flag.NewFlagSet("host-api", flag.ExitOnError)

	// Verify that a subcommand has been provided
	// os.Arg[0] is the main command
	// os.Arg[1] will be the subcommand
	// os.Arg[2] will be the sub subcommand
	if len(os.Args) < 2 {
		fmt.Println("a command amongst \"scale-codec\", \"state-trie\" needs to be specified.")
		os.Exit(1)
	}

	// Switch on the subcommand
	// Parse the flags for appropriate FlagSet
	// os.Args[2:] will be all arguments starting after the subcommand at os.Args[1]
	switch os.Args[1] {
	case "scale-codec":
		ProcessScaleCodecCommand(codecCommand, os.Args[2:])
	case "state-trie":
		ProcessStateTrieCommand(trieCommand, os.Args[2:])
	default:
		flag.PrintDefaults()
		os.Exit(1)
	}

}
