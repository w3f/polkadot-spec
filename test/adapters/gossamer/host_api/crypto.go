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

package host_api

import (
	"fmt"
	"os"

	"github.com/ChainSafe/gossamer/lib/runtime"
	"github.com/ChainSafe/gossamer/lib/scale"
)

// Simple wrapper to test hash function that input and output byte arrays
func test_crypto_hash(r *runtime.Runtime, name string, input string) {
	enc, err := scale.Encode([]byte(input))
	if err != nil {
		fmt.Println("Encoding failed: ", err)
		os.Exit(1)
	}

	output, err := r.Exec("rtm_ext_" + name, enc)
	if err != nil {
		fmt.Println("Execution failed: ", err)
		os.Exit(1)
	}

	dec, err := scale.Decode(output, []byte{}) 
	if err != nil {
		fmt.Println("Decoding failed: ", err)
		os.Exit(1)
	}

	fmt.Printf("%x\n", dec.([]byte)[:])
}



