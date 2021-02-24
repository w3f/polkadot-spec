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

