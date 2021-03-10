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
	"errors"
	"fmt"
	"bytes"

	"github.com/ChainSafe/gossamer/lib/common/optional"
	"github.com/ChainSafe/gossamer/lib/runtime"
	"github.com/ChainSafe/gossamer/lib/scale"
)

// -- Helpers --

// Helper function to call rtm_ext_default_child_storage_set_version_1
func child_storage_set(r runtime.Instance, child, key, value []byte) error {
	// Encode inputs
	child_enc, err := scale.Encode(child)
	if err != nil {
		return fmt.Errorf("Encoding child failed: %w", err)
	}

	key_enc, err := scale.Encode(key)
	if err != nil {
		return fmt.Errorf("Encoding key failed: %w", err)
	}

	value_enc, err := scale.Encode(value)
	if err != nil {
		return fmt.Errorf("Encoding value failed: %w", err)
	}

	args_enc := append(append(child_enc, key_enc...), value_enc...)

	// Set key to value
	_, err = r.Exec("rtm_ext_default_child_storage_set_version_1", args_enc)
	if err != nil {
		return fmt.Errorf("Execution failed: %w", err)
	}

	return nil
}

// Helper function to call rtm_ext_default_child_storage_get_version_1
func child_storage_get(r runtime.Instance, child, key []byte) (*optional.Bytes, error) {
	// Encode inputs
	child_enc, err := scale.Encode(child)
	if err != nil {
		return nil, fmt.Errorf("Encoding child failed: %w", err)
	}

	key_enc, err := scale.Encode(key)
	if err != nil {
		return nil, fmt.Errorf("Encoding key failed: %w", err)
	}

	// Retrieve key
	value_enc, err := r.Exec("rtm_ext_default_child_storage_get_version_1", append(child_enc, key_enc...))
	if err != nil {
		return nil, fmt.Errorf("Execution failed: %w", err)
	}

	value_opt, err := scale.Decode(value_enc, &optional.Bytes{})
	if err != nil {
		return nil, fmt.Errorf("Decoding value failed: %w", err)
	}
	return value_opt.(*optional.Bytes), nil
}

// -- Tests --

// Test for rtm_ext_child_storage_set_version_1 and rtm_ext_child_storage_get_version_1
func test_child_storage_set_get(r runtime.Instance, child1, child2, key, value string) error {
	// Get invalid key
	none1, err := child_storage_get(r, []byte(child1), []byte(key))
	if err != nil {
		return err
	}

	if none1.Exists() {
		return errors.New("Child1/Key is not empty")
	}

	// Set key to value
	err = child_storage_set(r, []byte(child1), []byte(key), []byte(value))
	if err != nil {
		return err
	}

	// Get invalid key (wrong child key)
	none2, err := child_storage_get(r, []byte(child2), []byte(key))
	if err != nil {
		return err
	}

	if none2.Exists() {
		return errors.New("Child2/Key is not empty")
	}

	// Get valid key
	some, err := child_storage_get(r, []byte(child1), []byte(key))
	if err != nil {
		return err
	}

	if !some.Exists() {
		return errors.New("Child1/Key is not set")
	}

	if !bytes.Equal(some.Value(), []byte(value)) {
		return fmt.Errorf("Value is different: %s", some.Value())
	}

	fmt.Printf("%s\n", some.Value())

	return nil
}
