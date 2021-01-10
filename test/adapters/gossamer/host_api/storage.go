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
	"bytes"
	"fmt"
	"os"
	"strings"

	"github.com/ChainSafe/gossamer/lib/common/optional"
	"github.com/ChainSafe/gossamer/lib/runtime"
	"github.com/ChainSafe/gossamer/lib/scale"
)

// -- Helpers --

// Helper function to call rtm_ext_storage_set_version_1
func storage_set(r runtime.Instance, key []byte, value []byte) {
	// Encode inputs
	key_enc, err := scale.Encode(key)
	if err != nil {
		fmt.Println("Encoding key failed: ", err)
		os.Exit(1)
	}

	value_enc, err := scale.Encode(value)
	if err != nil {
		fmt.Println("Encoding value failed: ", err)
		os.Exit(1)
	}

	// Set key to value
	_, err = r.Exec("rtm_ext_storage_set_version_1", append(key_enc, value_enc...))
	if err != nil {
		fmt.Println("Execution failed: ", err)
		os.Exit(1)
	}
}

// Helper function to call rtm_ext_storage_get_version_1
func storage_get(r runtime.Instance, key []byte) *optional.Bytes {
	// Encode inputs
	key_enc, err := scale.Encode(key)
	if err != nil {
		fmt.Println("Encoding key failed: ", err)
		os.Exit(1)
	}

	// Retrieve key
	value_enc, err := r.Exec("rtm_ext_storage_get_version_1", key_enc)
	if err != nil {
		fmt.Println("Execution failed: ", err)
		os.Exit(1)
	}

	value_opt, err := scale.Decode(value_enc, &optional.Bytes{})
	if err != nil {
		fmt.Println("Decoding value failed: ", err)
		os.Exit(1)
	}
	return value_opt.(*optional.Bytes)
}

// Helper function to call rtm_ext_storage_clear_version_1
func storage_clear(r runtime.Instance, key []byte) {
	// Encode inputs
	key_enc, err := scale.Encode([]byte(key))
	if err != nil {
		fmt.Println("Encoding key failed: ", err)
		os.Exit(1)
	}

	// Clear storage key
	_, err = r.Exec("rtm_ext_storage_clear_version_1", key_enc)
	if err != nil {
		fmt.Println("Execution failed: ", err)
		os.Exit(1)
	}
}

// Helper function to call rtm_ext_storage_exists_version_1
func storage_exists(r runtime.Instance, key []byte) uint32 {
	// Encode inputs
	key_enc, err := scale.Encode(key)
	if err != nil {
		fmt.Println("Encoding key failed: ", err)
		os.Exit(1)
	}

	// Retrieve status
	exists_enc, err := r.Exec("rtm_ext_storage_exists_version_1", key_enc)
	if err != nil {
		fmt.Println("Execution failed: ", err)
		os.Exit(1)
	}

	exists, err := scale.Decode(exists_enc, uint32(0))
	if err != nil {
		fmt.Println("Decoding value failed: ", err)
		os.Exit(1)
	}
	return exists.(uint32)
}

// Helper function to call rtm_ext_storage_root_version_1
func storage_root(r runtime.Instance) []byte {
	// Retrieve current root
	root_enc, err := r.Exec("rtm_ext_storage_root_version_1", []byte{})
	if err != nil {
		fmt.Println("Execution failed: ", err)
		os.Exit(1)
	}

	root, err := scale.Decode(root_enc, []byte{})
	if err != nil {
		fmt.Println("Decoding failed: ", err)
		os.Exit(1)
	}
	return root.([]byte)
}

// -- Tests --

// Test for initial state of storage
func test_storage_init(r runtime.Instance) {
	// Retrieve and print storage root
	hash := storage_root(r)

	fmt.Printf("%x\n", hash[:])
}

// Test for rtm_ext_storage_set_version_1 and rtm_ext_storage_get_version_1
func test_storage_set_get(r runtime.Instance, key string, value string) {
	// Get invalid key
	none := storage_get(r, []byte(key))

	if none.Exists() {
		fmt.Printf("Key already exists: %s\n", none.Value())
		os.Exit(1)
	}

	// Set key to value
	storage_set(r, []byte(key), []byte(value))

	// Get valid key
	some := storage_get(r, []byte(key))

	if !some.Exists() {
		fmt.Println("Key is missing")
		os.Exit(1)
	}

	if !bytes.Equal(some.Value(), []byte(value)) {
		fmt.Printf("Value is different: %s\n", some.Value())
		os.Exit(1)
	}

	// Print result
	fmt.Printf("%s\n", some.Value())
}

// Test for rtm_ext_storage_clear_version_1
func test_storage_clear(r runtime.Instance, key string, value string) {
	// Insert data
	storage_set(r, []byte(key), []byte(value))

	// Retrieve and check stored data
	some := storage_get(r, []byte(key))

	if !some.Exists() {
		fmt.Println("Key is missing")
		os.Exit(1)
	}

	if !bytes.Equal(some.Value(), []byte(value)) {
		fmt.Printf("Value is different: %s\n", some.Value())
		os.Exit(1)
	}

	// Clear data
	storage_clear(r, []byte(key))

	// Retrieve and check cleared data
	none := storage_get(r, []byte(key))

	if none.Exists() {
		fmt.Printf("Key was not cleared: %s\n", none.Value())
		os.Exit(1)
	}
}

// Test for rtm_ext_storage_exists_version_1
func test_storage_exists(r runtime.Instance, key string, value string) {
	// Check for no data
	none := storage_exists(r, []byte(key))

	if none != 0 {
		fmt.Println("Key already exists")
		os.Exit(1)
	}

	// Insert data
	storage_set(r, []byte(key), []byte(value))

	// Check for data
	some := storage_exists(r, []byte(key))

	if some != 1 {
		fmt.Println("Key does not exists")
		os.Exit(1)
	}

	// Print result
	fmt.Println("true")
}

// Test for rtm_ext_storage_clear_prefix_version_1
func test_storage_clear_prefix(r runtime.Instance, prefix string, key1 string, value1 string, key2 string, value2 string) {
	// Insert data
	storage_set(r, []byte(key1), []byte(value1))
	storage_set(r, []byte(key2), []byte(value2))

	// Clear prefix
	prefix_enc, err := scale.Encode([]byte(prefix))
	if err != nil {
		fmt.Println("Encoding prefix failed: ", err)
		os.Exit(1)
	}

	_, err = r.Exec("rtm_ext_storage_clear_prefix_version_1", prefix_enc)
	if err != nil {
		fmt.Println("Execution failed: ", err)
		os.Exit(1)
	}

	// Check if first key was handled correctly
	result1 := storage_get(r, []byte(key1))

	if strings.HasPrefix(key1, prefix) {
		if result1.Exists() {
			fmt.Println("Key1 was not deleted")
			os.Exit(1)
		}
	} else {
		if !result1.Exists() {
			fmt.Println("Key1 was deleted")
			os.Exit(1)
		}

		if !bytes.Equal(result1.Value(), []byte(value1)) {
			fmt.Printf("Value1 is different: %s\n", result1.Value())
			os.Exit(1)
		}
	}

	// Check if second key was handled correctly
	result2 := storage_get(r, []byte(key2))

	if strings.HasPrefix(key2, prefix) {
		if result2.Exists() {
			fmt.Println("Key2 was not deleted")
			os.Exit(1)
		}
	} else {
		if !result2.Exists() {
			fmt.Println("Key2 was deleted")
			os.Exit(1)
		}

		if !bytes.Equal(result2.Value(), []byte(value2)) {
			fmt.Printf("Value2 is different: %s\n", result2.Value())
			os.Exit(1)
		}
	}
}
