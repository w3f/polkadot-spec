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
	"errors"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"path"
	"strings"
	"strconv"

	"github.com/ChainSafe/gossamer/lib/keystore"
	"github.com/ChainSafe/gossamer/lib/runtime"
	"github.com/ChainSafe/gossamer/lib/runtime/storage"
	"github.com/ChainSafe/gossamer/lib/runtime/wasmer"
	"github.com/ChainSafe/gossamer/lib/runtime/wasmtime"
	"github.com/ChainSafe/gossamer/lib/runtime/life"
)

// #include <errno.h>
import "C"

// Configuration
const RELATIVE_WASM_ADAPTER_PATH = "bin/hostapi_runtime.compact.wasm"

// String to Integer conversion helper
func ToUint32(input string) uint32 {
	output, err := strconv.ParseUint(input, 10, 32)
	if err != nil {
		fmt.Println("Failed parse integer: ", err)
		os.Exit(1)
	}
	return uint32(output)
}

// Return absolute runtime patch
func GetRuntimePath() string {
	dir, err := os.Getwd()
	if err != nil {
		panic("failed to get current working directory")
	}
	return path.Join(dir, RELATIVE_WASM_ADAPTER_PATH)
}

// Main hostapi test argument parser
func ProcessHostApiCommand(args []string) {

	// List of expected flags
	functionTextPtr := flag.String("function", "", "Function to call (required).")
	inputTextPtr := flag.String("input", "", "Input to pass on call.")

	environmentTextPtr := flag.String("environment", "wasmer", "WASM environment to use:  wasmer, wasmtime or life")
	runtimeTextPtr := flag.String("runtime", GetRuntimePath(), "Override path to hostapi test runtime to use.")

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
	inputs := strings.Split(*inputTextPtr, ",")
	environment := *environmentTextPtr
	runtimePath := *runtimeTextPtr

	err := executeHostApiTest(function, inputs, environment, runtimePath)

	if err != nil {
		if _, ok := err.(MissingImplementation); ok {
			fmt.Println("Not implemented: ", function)
			os.Exit(C.EOPNOTSUPP)
		}
		fmt.Println(err)
		os.Exit(1)
	}
}

// Main hostapi test executor
func executeHostApiTest(function string, inputs []string, environment, runtimePath string) error {
	// Initialize storage
	store, err := storage.NewTrieState(nil)
	if err != nil {
		return fmt.Errorf("Failed to initialize storage: %w", err)
	}

	store.Set([]byte(":code"), []byte{})
	store.Set([]byte(":heappages"), []byte{8, 0, 0, 0, 0, 0, 0, 0})

	// Initialize runtime environment..
	var rtm runtime.Instance
	switch environment {
	case "wasmer":
		// ... using wasmer
		cfg := &wasmer.Config{
			Imports: wasmer.ImportsNodeRuntime,
		}
		cfg.Storage = store
		cfg.Keystore = keystore.NewGlobalKeystore()
		cfg.LogLvl = 2 // = Warn

		rtm, err = wasmer.NewInstanceFromFile(runtimePath, cfg)
		if err != nil {
			return fmt.Errorf("Failed to intialize wasmer environment: %w", err)
		}
	case "wasmtime":
		// ... using wasmtime
		cfg := &wasmtime.Config{
			Imports: wasmtime.ImportNodeRuntime,
		}
		cfg.Storage = store
		cfg.Keystore = keystore.NewGlobalKeystore()
		cfg.LogLvl = 2 // = Warn

		rtm, err = wasmtime.NewInstanceFromFile(runtimePath, cfg)
		if err != nil {
			return fmt.Errorf("Failed to intialize wasmtime environment: %w", err)
		}
	case "life":
		// ... using life
		cfg := &life.Config{
			Resolver: new(life.Resolver),
		}
		cfg.Storage = store
		cfg.Keystore = keystore.NewGlobalKeystore()
		cfg.LogLvl = 2 // = Warn

		code, err := ioutil.ReadFile(runtimePath)
		if err != nil {
			return fmt.Errorf("Failed to load test runtime: %w", err)
		}

		// create runtime executor
		rtm, err = life.NewInstance(code, cfg)
		if err != nil {
			return fmt.Errorf("Failed to intialize life environment: %w", err)
		}
	default:
		return errors.New("Unknown runtime environment: " + environment)
	}

	// Run requested test function
	switch function {
	// test allocator api
	case "ext_allocator_malloc_version_1",
	     "ext_allocator_free_version_1":
		return test_allocator_malloc_free(rtm, inputs[0])

	// test child storage api
	//case "ext_default_child_storage_set_version_1":
	//case "ext_default_child_storage_get_version_1":
	//	test_child_storage_set_get(rtm, inputs[0], inputs[1], inputs[2], inputs[3])
	//case "ext_default_child_storage_read_version_1":
	//case "ext_default_child_storage_clear_version_1":
	//case "ext_default_child_storage_storage_kill_version_1":
	//case "ext_default_child_storage_exists_version_1":
	//case "ext_default_child_storage_clear_prefix_version_1":
	//case "ext_default_child_storage_root_version_1":
	//case "ext_default_child_storage_next_key_version_1":

	// test crypto api
	case "ext_crypto_ed25519_public_keys_version_1":
		return test_crypto_public_keys(rtm, "ed25519", inputs[0], inputs[1])
	case "ext_crypto_ed25519_generate_version_1":
		return test_crypto_generate(rtm, "ed25519", inputs[0])
	//case "ext_crypto_ed25519_sign_version_1":
	//case "ext_crypto_ed25519_verify_version_1":
	case "ext_crypto_sr25519_public_keys_version_1":
		return test_crypto_public_keys(rtm, "sr25519", inputs[0], inputs[1])
	case "ext_crypto_sr25519_generate_version_1":
		return test_crypto_generate(rtm, "sr25519", inputs[0])
	//case "ext_crypto_sr25519_sign_version_1":
	//case "ext_crypto_sr25519_verify_version_1":

	// test hashing api
	case "ext_hashing_blake2_128_version_1",
	     "ext_hashing_blake2_256_version_1",
	     "ext_hashing_keccak_256_version_1",
	     "ext_hashing_sha2_256_version_1",
	     "ext_hashing_twox_64_version_1",
	     "ext_hashing_twox_128_version_1",
	     "ext_hashing_twox_256_version_1":
		return test_hashing(rtm, function, inputs[0])

	// test storage api
	case "test_storage_init":
		return test_storage_init(rtm)
	case "ext_storage_set_version_1",
	     "ext_storage_get_version_1":
		return test_storage_set_get(rtm, inputs[0], inputs[1])
	case "ext_storage_read_version_1":
		return test_storage_read(rtm, inputs[0], inputs[1], ToUint32(inputs[2]), ToUint32(inputs[3]))
	case "ext_storage_clear_version_1":
		return test_storage_clear(rtm, inputs[0], inputs[1])
	case "ext_storage_exists_version_1":
		return test_storage_exists(rtm, inputs[0], inputs[1])
	case "ext_storage_clear_prefix_version_1":
		return test_storage_clear_prefix(rtm, inputs[0], inputs[1], inputs[2], inputs[3], inputs[4])
	case "ext_storage_append_version_1":
		return test_storage_append(rtm, inputs[0], inputs[1], inputs[2], inputs[3])
	case "ext_storage_root_version_1":
		return test_storage_root(rtm, inputs[0], inputs[1], inputs[2], inputs[3])
	case "ext_storage_next_key_version_1":
		return test_storage_next_key(rtm, inputs[0], inputs[1], inputs[2], inputs[3])

	// test trie api
	case "ext_trie_blake2_256_root_version_1":
		return test_trie_root(rtm, inputs[0], inputs[1], inputs[2], inputs[3], inputs[4], inputs[5])
	case "ext_trie_blake2_256_ordered_root_version_1":
		return test_trie_ordered_root(rtm, inputs[0], inputs[1], inputs[2])
	}

	return MissingImplementation{}
}
