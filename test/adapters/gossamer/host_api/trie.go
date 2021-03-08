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

	"github.com/ChainSafe/gossamer/lib/runtime"
	"github.com/ChainSafe/gossamer/lib/scale"
)


func test_trie_root(r runtime.Instance, key1 string, value1 string, key2 string, value2 string, key3 string, value3 string) error {
	// Construct and encode input
	trie := []string{key1, value1, key2, value2, key3, value3}

	trie_enc, err := scale.Encode(trie)
	if err != nil {
		return fmt.Errorf("Encoding input failed: %w", err)
	}

	// Change encoding to key-value tuples by fixing encoded list length
	trie_enc[0] = trie_enc[0] / 2

	// Compute ordered root hash
	hash_enc, err := r.Exec("rtm_ext_trie_blake2_256_root_version_1", trie_enc)

	if err != nil {
		return fmt.Errorf("Execution failed: %w", err)
	}

	// Decode and print result
	hash, err := scale.Decode(hash_enc, []byte{})
	if err != nil {
		return fmt.Errorf("Decoding value failed: %w", err)
	}

	fmt.Printf("%x\n", hash.([]byte)[:])

	return nil
}

func test_trie_ordered_root(r runtime.Instance, value1 string, value2 string, value3 string) error {
	// Construct and encode input
	trie := []string{value1, value2, value3}

	trie_enc, err := scale.Encode(trie)
	if err != nil {
		return fmt.Errorf("Encoding input failed: %w", err)
	}

	// Compute ordered root hash
	hash_enc, err := r.Exec("rtm_ext_trie_blake2_256_ordered_root_version_1", trie_enc)

	if err != nil {
		return fmt.Errorf("Execution failed: %w", err)
	}

	// Decode and print result
	hash, err := scale.Decode(hash_enc, []byte{})
	if err != nil {
		return fmt.Errorf("Decoding value failed: %w", err)
	}

	fmt.Printf("%x\n", hash.([]byte)[:])

	return nil
}
