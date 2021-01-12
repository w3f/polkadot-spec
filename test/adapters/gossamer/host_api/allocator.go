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

// Test for ext_allocator_malloc_version_1 and ext_allocator_free_version_1
func test_allocator_malloc_free(r runtime.Instance, value string) {

	// Encode inputs
	value_enc, err := scale.Encode([]byte(value))
	if err != nil {
		fmt.Println("Encoding value failed: ", err)
		os.Exit(1)
	}

	// The Wasm function tests both the allocation and freeing of the buffer
	result_enc, err := r.Exec("rtm_ext_allocator_malloc_version_1", value_enc)
	if err != nil {
		fmt.Println("Execution failed: ", err)
		os.Exit(1)
	}

	// Decode and print output
	result_dec, err := scale.Decode(result_enc, []byte{})
	if err != nil {
		fmt.Println("Decoding result failed: ", err)
		os.Exit(1)
	}
	result := result_dec.([]byte)

	if !bytes.Equal(result, []byte(value)) {
		fmt.Printf("Value is different: %s\n", result)
		os.Exit(1)
	}

	fmt.Printf("%s\n", result)
}
