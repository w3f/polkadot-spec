// Copyright (c) 2019 Web3 Technologies Foundation

// This file is part of Polkadot Host Test Suite

// Polkadot Host Test Suite is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// Polkadot Host Tests is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with Foobar.  If not, see <https://www.gnu.org/licenses/>.

package host_api

import (
	"fmt"
	"os"
	"bytes"

	"github.com/ChainSafe/gossamer/lib/common/optional"
	"github.com/ChainSafe/gossamer/lib/runtime"
	"github.com/ChainSafe/gossamer/lib/scale"
)

// -- Helpers --

// Helper function to call rtm_ext_default_child_storage_set_version_1
func child_storage_set(r runtime.Instance, child []byte, key []byte, value []byte) {
	// Encode inputs
	child_enc, err := scale.Encode(child)
	if err != nil {
		fmt.Println("Encoding child failed: ", err)
		os.Exit(1)
	}

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

	args_enc := append(append(child_enc, key_enc...), value_enc...)

	// Set key to value
	_, err = r.Exec("rtm_ext_default_child_storage_set_version_1", args_enc)
	if err != nil {
		fmt.Println("Execution failed: ", err)
		os.Exit(1)
	}
}

// Helper function to call rtm_ext_default_child_storage_get_version_1
func child_storage_get(r runtime.Instance, child []byte, key []byte) *optional.Bytes {
	// Encode inputs
	child_enc, err := scale.Encode(child)
	if err != nil {
		fmt.Println("Encoding child failed: ", err)
		os.Exit(1)
	}

	key_enc, err := scale.Encode(key)
	if err != nil {
		fmt.Println("Encoding key failed: ", err)
		os.Exit(1)
	}

	// Retrieve key
	value_enc, err := r.Exec("rtm_ext_default_child_storage_get_version_1", append(child_enc, key_enc...))
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

// -- Tests --

// Test for rtm_ext_child_storage_set_version_1 and rtm_ext_child_storage_get_version_1
func test_child_storage_set_get(r runtime.Instance, child1 string, child2 string, key string, value string) {
	// Get invalid key
	none1 := child_storage_get(r, []byte(child1), []byte(key))

	if none1.Exists() {
		fmt.Println("Child1/Key is not empty")
		os.Exit(1)
	}

	// Set key to value
	child_storage_set(r, []byte(child1), []byte(key), []byte(value))

	// Get invalid key (wrong child key)
	none2 := child_storage_get(r, []byte(child2), []byte(key))

	if none2.Exists() {
		fmt.Println("Child2/Key is not empty")
		os.Exit(1)
	}

	// Get valid key
	some := child_storage_get(r, []byte(child1), []byte(key))

	if !some.Exists() {
		fmt.Println("Child1/Key is not set")
		os.Exit(1)
	}

	if !bytes.Equal(some.Value(), []byte(value)) {
		fmt.Printf("Value is different: %s\n", some.Value())
		os.Exit(1)
	}

	fmt.Printf("%s\n", some.Value())
}
