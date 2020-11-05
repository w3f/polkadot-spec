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

package host_api

import (
	"flag"
	"fmt"
	"os"
	"path"
	"strings"

	"github.com/ChainSafe/gossamer/dot/state"
	"github.com/ChainSafe/gossamer/lib/keystore"
	"github.com/ChainSafe/gossamer/lib/runtime"
	"github.com/ChainSafe/gossamer/lib/runtime/wasmer"
	"github.com/ChainSafe/gossamer/lib/runtime/wasmtime"
	"github.com/ChainSafe/gossamer/lib/trie"

	database "github.com/ChainSafe/chaindb"
)

// #include <errno.h>
import "C"

var RELATIVE_WASM_ADAPTER_PATH = "bin/hostapi_runtime.compact.wasm"

func GetRuntimePath() string {
	dir, err := os.Getwd()
	if err != nil {
		panic("failed to get current working directory")
	}
	return path.Join(dir, RELATIVE_WASM_ADAPTER_PATH)
}

func GetTestStorage() *state.TrieState {
	store, err := state.NewTrieState(database.NewMemDatabase(), trie.NewEmptyTrie())
	if err != nil {
		fmt.Println("Failed initialize storage: ", err)
		os.Exit(1)
	}
	return store
}

func ProcessHostApiCommand(args []string) {

	// List of expected flags
	functionTextPtr := flag.String("function", "", "Function to call (required).")
	inputTextPtr := flag.String("input", "", "Input to pass on call.")
	
	wasmtimeBoolPtr := flag.Bool("wasmtime", false, "Use wasmtime instead of wasmer.")

	// Parse provided argument list
	flag.CommandLine.Parse(args)

	if !flag.Parsed() {
		flag.PrintDefaults()
		os.Exit(1)
	}

	// Verify that all required flags are provided
	if (*functionTextPtr == "") {
		flag.PrintDefaults()
		os.Exit(1)
	}

	function := *functionTextPtr
	inputs   := strings.Split(*inputTextPtr, ",")

	// Initialize runtime environment...
	var rtm runtime.Instance
	if *wasmtimeBoolPtr {
		// ... using wasmtime
		cfg := &wasmtime.Config{
			Imports: wasmtime.ImportsNodeRuntime,
		}
		cfg.Storage = GetTestStorage()
		cfg.Keystore = keystore.NewGenericKeystore("test")
		cfg.LogLvl = 2

		r, err := wasmtime.NewInstanceFromFile(GetRuntimePath(), cfg)
		if err != nil {
			fmt.Println("Failed initialize runtime: ", err)
			os.Exit(1)
		}
		rtm = r
	} else {
		// ... using wasmer
		cfg := &wasmer.Config{
			Imports: wasmer.ImportsNodeRuntime,
		}
		cfg.Storage = GetTestStorage()
		cfg.Keystore = keystore.NewGenericKeystore("test")
		cfg.LogLvl = 2

		r, err := wasmer.NewInstanceFromFile(GetRuntimePath(), cfg)
		if err != nil {
			fmt.Println("Failed initialize runtime: ", err)
			os.Exit(1)
		}
		rtm = r
	}

	// Run requested test function
	switch function {
	// test allocator api
	//case "ext_allocator_malloc_version_1":
	//case "ext_allocator_free_version_1":

	// test child storage api
	//case "ext_default_child_storage_set_version_1":
	//case "ext_default_child_storage_get_version_1":
	//case "ext_default_child_storage_read_version_1":
	//case "ext_default_child_storage_clear_version_1":
	//case "ext_default_child_storage_storage_kill_version_1":
	//case "ext_default_child_storage_exists_version_1":
	//case "ext_default_child_storage_clear_prefix_version_1":
	//case "ext_default_child_storage_root_version_1":
	//case "ext_default_child_storage_next_key_version_1":

	// test crypto api
	//case "ext_crypto_ed25519_public_keys_version_1":
	//case "ext_crypto_ed25519_generate_version_1":
	//case "ext_crypto_ed25519_sign_version_1":
	//case "ext_crypto_ed25519_verify_version_1":
	//case "ext_crypto_sr25519_public_keys_version_1":
	//case "ext_crypto_sr25519_generate_version_1":
	//case "ext_crypto_sr25519_sign_version_1":
	//case "ext_crypto_sr25519_verify_version_1":

	// test hashing api
	case "ext_hashing_blake2_128_version_1",
	     "ext_hashing_blake2_256_version_1",
	     "ext_hashing_keccak_256_version_1",
	//     "ext_hashing_sha2_256_version_1",
	     "ext_hashing_twox_64_version_1",
	     "ext_hashing_twox_128_version_1",
	     "ext_hashing_twox_256_version_1":
		test_hashing(rtm, function, inputs[0])

	// test storage api
	//case "test_storage_init":
	case "ext_storage_set_version_1",
	     "ext_storage_get_version_1":
		test_storage_set_get(rtm, inputs[0], inputs[1])
	//case "ext_storage_read_version_1":
	//case "ext_storage_clear_version_1":
	//case "ext_storage_exists_version_1":
	//case "ext_storage_clear_prefix_version_1":
	//case "ext_storage_append_version_1":
	//case "ext_storage_root_version_1":
	//case "ext_storage_next_key_version_1":

	// test trie api
	//case "ext_trie_blake2_256_root_version_1":
	//case "ext_trie_blake2_256_ordered_root_version_1":

	default:
		fmt.Println("Not implemented: ", function)
		os.Exit(C.EOPNOTSUPP)
	}

	os.Exit(0)
}
