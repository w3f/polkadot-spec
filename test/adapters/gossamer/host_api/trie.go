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

	"github.com/ChainSafe/gossamer/lib/runtime"
	"github.com/ChainSafe/gossamer/lib/scale"
)

func test_trie_ordered_root(r runtime.Instance, value1 string, value2 string, value3 string) {
	// Construct and encode input
	trie := []string{value1, value2, value3}

	trie_enc, err := scale.Encode(trie)
	if err != nil {
		fmt.Println("Encoding input failed: ", err)
		os.Exit(1)
	}


	// Compute ordered root hash
	hash_enc, err := r.Exec("rtm_ext_trie_blake2_256_ordered_root_version_1", trie_enc)

	if err != nil {
		fmt.Println("Execution failed: ", err)
		os.Exit(1)
	}

	// Decode and print result
	hash, err := scale.Decode(hash_enc, []byte{})
	if err != nil {
		fmt.Println("Decoding value failed: ", err)
		os.Exit(1)
	}

	fmt.Printf("%x\n", hash.([]byte)[:])
}
