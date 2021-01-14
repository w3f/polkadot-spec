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

// Helper function to call rtm_ext_storage_read_version_1
func storage_read(r runtime.Instance, key []byte, offset uint32, length uint32) *optional.Bytes {
	// Encode inputs
	key_enc, err := scale.Encode([]byte(key))
	if err != nil {
		fmt.Println("Encoding key failed: ", err)
		os.Exit(1)
	}

	offset_enc, err := scale.Encode(offset)
	if err != nil {
		fmt.Println("Encoding offset failed: ", err)
		os.Exit(1)
	}

	length_enc, err := scale.Encode(length)
	if err != nil {
		fmt.Println("Encoding length failed: ", err)
		os.Exit(1)
	}

	args_enc := append(append(key_enc, offset_enc...), length_enc...)

	// Check that key has not been set
	value_enc, err := r.Exec("rtm_ext_storage_read_version_1", args_enc)
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

// Helper function to call rtm_ext_storage_append_version_1
func storage_append(r runtime.Instance, key []byte, value []byte) {
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

	// Append value to key
	_, err = r.Exec("rtm_ext_storage_append_version_1", append(key_enc, value_enc...))
	if err != nil {
		fmt.Println("Execution failed: ", err)
		os.Exit(1)
	}
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

// Helper function to call rtm_ext_storage_next_key_version_1
func storage_next_key(r runtime.Instance, key []byte) *optional.Bytes {
	// Encode inputs
	key_enc, err := scale.Encode(key)
	if err != nil {
		fmt.Println("Encoding key failed: ", err)
		os.Exit(1)
	}

	// Retrieve key
	value_enc, err := r.Exec("rtm_ext_storage_next_key_version_1", key_enc)
	if err != nil {
		fmt.Println("Execution failed: ", err)
		os.Exit(1)
	}

	value_opt, err := scale.Decode(value_enc, &optional.Bytes{})
	if err != nil {
		fmt.Println("Decoding next key failed: ", err)
		os.Exit(1)
	}
	return value_opt.(*optional.Bytes)
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

// Test for rtm_ext_storage_read_version_1
func test_storage_read(r runtime.Instance, key string, value string, offset uint32, length uint32) {
	// Check that key has not been set
	none := storage_read(r, []byte(key), offset, length)

	if none.Exists() {
		fmt.Printf("Key already exists: %s\n", none.Value())
		os.Exit(1)
	}

	// Add data to storage
	storage_set(r, []byte(key), []byte(value))

	// Retrieve and check returned data
	some := storage_read(r, []byte(key), offset, length)

	if !some.Exists() {
		fmt.Println("Key is missing")
		os.Exit(1)
	}

	if int(offset) < len(value) {
		expected_length := len(value) - int(offset)
		if expected_length > int(length) {
			expected_length = int(length)
		}
		expected_value := value[offset:int(offset)+expected_length];

		if !bytes.Equal(some.Value(), []byte(expected_value)) {
			fmt.Printf("Value is different: %s\n", some.Value())
			os.Exit(1)
		}
	} else if len(some.Value()) != 0 {
		fmt.Printf("Value is not empty: %s\n", some.Value())
		os.Exit(1)
	}

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

// Test for rtm_ext_storage_append_version_1
func test_storage_append(r runtime.Instance, key1 string, value1 string, key2 string, value2 string) {
	// Encode inputs
	value1_enc, err := scale.Encode(value1)
	if err != nil {
		fmt.Println("Encoding value1 failed: ", err)
		os.Exit(1)
	}

	value2_enc, err := scale.Encode(value2)
	if err != nil {
		fmt.Println("Encoding value2 failed: ", err)
		os.Exit(1)
	}

	// Check that key1 is unset
	none1 := storage_get(r, []byte(key1))

	if none1.Exists() {
		fmt.Printf("Key1 already exists: %s\n", none1.Value())
		os.Exit(1)
	}

	// Insert key1
	storage_append(r, []byte(key1), []byte(value1_enc))
	storage_append(r, []byte(key1), []byte(value2_enc))

	// Check that key2 is unset
	none2 := storage_get(r, []byte(key2))

	if none2.Exists() {
		fmt.Printf("Key2 already exists: %s\n", none2.Value())
		os.Exit(1)
	}

	// Insert key2
	storage_append(r, []byte(key2), []byte(value2_enc))
	storage_append(r, []byte(key2), []byte(value1_enc))
	storage_append(r, []byte(key2), []byte(value2_enc))
	storage_append(r, []byte(key2), []byte(value1_enc))

	// Check key1
	some1_opt := storage_get(r, []byte(key1))

	if !some1_opt.Exists() {
		fmt.Println("Key1 not set")
		os.Exit(1)
	}

	some1_dec, err := scale.Decode(some1_opt.Value(), []string{})
	if err != nil {
		fmt.Println("Decoding value failed: ", err)
		os.Exit(1)
	}
	some1 := some1_dec.([]string)

	if some1[0] != value1 || some1[1] != value2 {
		fmt.Println("Value is different")
		os.Exit(1)
	}

	fmt.Println(strings.Join(some1, ","))

	// Check key2
	some2_opt := storage_get(r, []byte(key2))

	if !some2_opt.Exists() {
		fmt.Println("Key2 not set")
		os.Exit(1)
	}

	some2_dec, err := scale.Decode(some2_opt.Value(), []string{})
	if err != nil {
		fmt.Println("Decoding value failed: ", err)
		os.Exit(1)
	}
	some2 := some2_dec.([]string)

	if some2[0] != value2 || some2[1] != value1 || some2[2] != value2 || some2[3] != value1 {
		fmt.Printf("Key2 not set: %s\n", some2_opt.Value())
		os.Exit(1)
	}

	fmt.Println(strings.Join(some2, ","))
}

// Test for rtm_ext_storage_root_version_1
func test_storage_root(r runtime.Instance, key1 string, value1 string, key2 string, value2 string) {
	// Insert data
	storage_set(r, []byte(key1), []byte(value1))
	storage_set(r, []byte(key2), []byte(value2))

	// Compute and print storage root hash
	hash := storage_root(r)

	fmt.Printf("%x\n", hash[:])
}

// Test for rtm_ext_storage_next_key_version_1
func test_storage_next_key(r runtime.Instance, key1 string, value1 string, key2 string, value2 string) {

	// No next key available
	none1 := storage_next_key(r, []byte(key1))

	if none1.Exists() {
		fmt.Println("Next1 is not empty")
		os.Exit(1)
	}

	none2 := storage_next_key(r, []byte(key2))

	if none2.Exists() {
		fmt.Println("Next2 is not empty")
		os.Exit(1)
	}

	// Insert test data
	storage_set(r, []byte(key1), []byte(value1))
	storage_set(r, []byte(key2), []byte(value2))

	// Check next key after key1
	some1 := storage_next_key(r, []byte(key1))

	if strings.Compare(key1, key2) < 0 {
		if !some1.Exists() {
			fmt.Println("Key2 is missing")
			os.Exit(1)
		}
		next := some1.Value();

		if !bytes.Equal(next, []byte(key2)) {
			fmt.Printf("Next is not key2: %s\n", next)
			os.Exit(1)
		}

		fmt.Printf("%s\n", next);
	} else {
		if some1.Exists() {
			fmt.Println("Next is not empty");
			os.Exit(1)
		}
	}

	// Check next key after key2
	some2 := storage_next_key(r, []byte(key2))

	if strings.Compare(key2, key1) < 0 {
		if !some2.Exists() {
			fmt.Println("Key1 is missing")
			os.Exit(1)
		}
		next := some2.Value();

		if !bytes.Equal(next, []byte(key1)) {
			fmt.Printf("Next is not key1: %s\n", next)
			os.Exit(1)
		}

		fmt.Printf("%s\n", next);
	} else {
		if some2.Exists() {
			fmt.Println("Next is not empty");
			os.Exit(1)
		}
	}
}
