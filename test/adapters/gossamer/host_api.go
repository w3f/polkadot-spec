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
	"os"
	"fmt"
	"flag"
	"path"
	"github.com/ChainSafe/gossamer/lib/runtime"
	"github.com/ChainSafe/gossamer/lib/keystore"
	"github.com/ChainSafe/gossamer/lib/trie"
	"github.com/ChainSafe/gossamer/dot/state"

	database "github.com/ChainSafe/chaindb"
)


const RELATIVE_WASM_ADAPTER_PATH = "adapters/wasm-legacy/target/release/wbuild/wasm-adapter-legacy/wasm_adapter_legacy.compact.wasm"


func GetRuntimePath() string {
	dir, err := os.Getwd()
	if err != nil {
		panic("failed to get current working directory")
	}
	return path.Join(dir, RELATIVE_WASM_ADAPTER_PATH)
}

func GetTestStorage() *state.StorageState {
	db := database.NewMemDatabase()

	s, err := state.NewStorageState(db, trie.NewEmptyTrie())
	if err != nil {
		fmt.Println("Failed initialize storage: ", err)
		os.Exit(1)
	}

	return s
}

func ProcessHostApiCommand(args []string) {

	// List of expected flags 
	functionTextPtr := flag.String("function", "", "Function to call (required).")
	inputTextPtr    := flag.String("input",    "", "Input to pass on call (required).")

	// Parse provided argument list
	flag.CommandLine.Parse(args)

	if !flag.Parsed() {
		flag.PrintDefaults()
		os.Exit(1)
	}

	// Verify that a required flags are provided
	if (*functionTextPtr == "") || (*inputTextPtr == "") {
		flag.PrintDefaults()
		os.Exit(1)
	}

	r, err := runtime.NewRuntimeFromFile(
		GetRuntimePath(),
		GetTestStorage(),
		keystore.NewKeystore(),
		runtime.RegisterImports_NodeRuntime)

	if err != nil {
		fmt.Println("Failed initialize runtime: ", err)
		os.Exit(1)
	}

	output, err := r.Exec(*functionTextPtr, nil)
	if err != nil {
		fmt.Println("Execution failed: ", err)
		os.Exit(1)
	}

	println(output)
	os.Exit(0)
}
