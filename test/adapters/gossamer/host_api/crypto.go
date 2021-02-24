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
	"bytes"

	"github.com/ChainSafe/gossamer/lib/common/optional"
	"github.com/ChainSafe/gossamer/lib/runtime"
	"github.com/ChainSafe/gossamer/lib/scale"
)

// -- Helpers --

const DUMY_KEY_ID int32 = 0x64756d79 // DUMY

// Helper function to call rtm_ext_crypto_<suite>_generate_version_1
func crypto_generate(r runtime.Instance, suite string, seed string) ([]byte, error) {
	// Encode inputs
	id_enc, err := scale.Encode(DUMY_KEY_ID)
	if err != nil {
		return nil, AdapterError{"Encoding key id failed", err}
	}

	seed_enc, err := scale.Encode(optional.NewBytes(true, []byte(seed)))
	if err != nil {
		return nil, AdapterError{"Encoding seed failed", err}
	}

	// Generate new public key
	pk, err := r.Exec("rtm_ext_crypto_" + suite + "_generate_version_1", append(id_enc, seed_enc...))
	if err != nil {
		return nil, AdapterError{"Execution failed", err}
	}

	return pk, nil
}

// Helper function to call rtm_ext_crypto_<suite>_public_keys_version_1
func crypto_public_keys(r runtime.Instance, suite string) ([]byte, error) {
	// Encode input
	id_enc, err := scale.Encode(DUMY_KEY_ID)
	if err != nil {
		return nil, AdapterError{"Encoding key id failed", err}
	}

	// Request all know public keys
	keys, err := r.Exec("rtm_ext_crypto_" + suite + "_public_keys_version_1", id_enc)
	if err != nil {
		return nil, AdapterError{"Execution failed", err}
	}

	return keys, nil
}

// -- Tests --

// Test for ext_crypto_<suite>_generate_version_1
func test_crypto_generate(r runtime.Instance, suite string, seed string) error {
	// Generate new key and print result
	pk, err := crypto_generate(r, suite, seed)
	if err != nil {
		return err
	}

	fmt.Printf("%x\n", pk)

	return nil
}

// Test for ext_crypto_<suite>_public_keys_version_1
func test_crypto_public_keys(r runtime.Instance, suite string, seed1 string, seed2 string) error {
	// Generate two new keys
	pk1, err := crypto_generate(r, suite, seed1)
	if err != nil {
		return err
	}

	pk2, err := crypto_generate(r, suite, seed2)
	if err != nil {
		return err
	}

	// Retrieve all public keys
	keys, err := crypto_public_keys(r, suite)
	if err != nil {
		return err
	}

	// Check result
	if len(keys) != 65 || keys[0] != 8 {
		return newTestFailure("Pubkeys size missmatch")
	}

	key1 := keys[1:33]
	key2 := keys[33:65]

	if !bytes.Equal(pk1, key1) && !bytes.Equal(pk1, key2) {
		return newTestFailure("Keystore does not include pubkey 1")
	}

	if !bytes.Equal(pk2, key1) && !bytes.Equal(pk2, key2) {
		return newTestFailure("Keystore does not include pubkey 2")
	}

	fmt.Printf("1. Public key: %x\n", key1)
	fmt.Printf("2. Public key: %x\n", key2)

	return nil
}
