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
	"fmt"
	"os"

	"w3f/gossamer-adapter/host_api"
)

func usage() {
	fmt.Println("usage: ", os.Args[0], " <scale-codec|state-trie|host-api> <subcommand-args>")
}

func main() {
	// Verify that a subcommand has been provided
	if len(os.Args) < 2 {
		usage()
		os.Exit(1)
	}

	// Parse subcommand and call it with all remaining args
	switch os.Args[1] {
	case "scale-codec":
		ProcessScaleCodecCommand(os.Args[2:])
	case "state-trie":
		ProcessStateTrieCommand(os.Args[2:])
	case "host-api":
		host_api.ProcessHostApiCommand(os.Args[2:])
	default:
		usage()
		os.Exit(1)
	}
}
