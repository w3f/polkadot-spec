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

import "fmt"

// Empty error to indicate missing implementation
type MissingImplementation struct {}

func (e MissingImplementation) Error() string { return "Not implemented" }

// Simple string error to indicate test failure
type TestFailure struct {
	message string
}

func (e TestFailure) Error() string { return e.message }

// Constructor using Sprint for message
func newTestFailure(args ...interface{}) error {
	message := fmt.Sprint(args...)
	return TestFailure{message}
}

// Constructor using Sprintf for message
func newTestFailuref(format string, args ...interface{}) error {
	message := fmt.Sprintf(format, args...)
	return TestFailure{message}
}

// Wrapped error to indicate adapter failure
type AdapterError struct {
	message string
	wrapped error
}

func (e AdapterError) Error() string { return e.message + ": " + e.wrapped.Error() }
