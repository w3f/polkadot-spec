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
	"fmt"
	"os"
	"bytes"

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

// -- Tests --

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
