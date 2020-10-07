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

	"github.com/ChainSafe/gossamer/lib/runtime"
	"github.com/ChainSafe/gossamer/lib/scale"
)


func test_set_get_storage(r runtime.Instance, key string, value string) {

	// Encode inputs
	key_enc, err := scale.Encode([]byte(key))
	if err != nil {
		fmt.Println("Encoding key failed: ", err)
		os.Exit(1)
	}

	value_enc, err := scale.Encode([]byte(value))
	if err != nil {
		fmt.Println("Encoding value failed: ", err)
		os.Exit(1)
	}

	// Get invalid key
	empty_enc, err := r.Exec("rtm_ext_get_allocated_storage", key_enc)
	if err != nil {
		fmt.Println("Execution failed: ", err)
		os.Exit(1)
	}

	empty, err := scale.Decode(empty_enc, []byte{})
	if err != nil {
		fmt.Println("Decoding value failed: ", err)
		os.Exit(1)
	}

	if len(empty.([]byte)) != 0 {
		fmt.Printf("Key already exists: %s\n", empty)
		os.Exit(1)
	}

	// Set key/value
	_, err = r.Exec("rtm_ext_set_storage", append(key_enc, value_enc...))
	if err != nil {
		fmt.Println("Execution failed: ", err)
		os.Exit(1)
	}

	// Get valid key
	result_enc, err := r.Exec("rtm_ext_get_allocated_storage", key_enc)
	if err != nil {
		fmt.Println("Execution failed: ", err)
		os.Exit(1)
	}

	result, err := scale.Decode(result_enc, []byte{})
	if err != nil {
		fmt.Println("Decoding value failed: ", err)
		os.Exit(1)
	}

	if !bytes.Equal(result.([]byte), []byte(value)) {
		fmt.Printf("Value is different: %s\n", result)
		os.Exit(1)
	}

	fmt.Printf("%s\n", result)
}
