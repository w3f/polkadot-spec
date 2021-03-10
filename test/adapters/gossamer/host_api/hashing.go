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

	"github.com/ChainSafe/gossamer/lib/runtime"
	"github.com/ChainSafe/gossamer/lib/scale"
)

// Simple wrapper to test hash function that input and output byte arrays
func test_hashing(r runtime.Instance, name, input string) error {

	enc, err := scale.Encode([]byte(input))
	if err != nil {
		return fmt.Errorf("Encoding failed: %w", err)
	}

	output, err := r.Exec("rtm_" + name, enc)
	if err != nil {
		return fmt.Errorf("Execution failed: %w", err)
	}

	dec, err := scale.Decode(output, []byte{})
	if err != nil {
		return fmt.Errorf("Decoding failed: %w", err)
	}

	fmt.Printf("%x\n", dec.([]byte)[:])

	return nil
}
