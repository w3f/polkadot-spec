// Copyright (c) 2019 Web3 Technologies Foundation

// This file is part of Polkadot RE Test Suite

// Polkadot RE Test Suite is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// Polkadot RE Tests is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with Foobar.  If not, see <https://www.gnu.org/licenses/>.

// this file provide a command line interface to call scale codec go library

package main

import (
	"../../../../implementations/go/gossamer/codec"
	"bytes"
	"encoding/base64"
	"flag"
	"fmt"
	"os"
)

func main() {

	// Subcommands
	encodeCommand := flag.NewFlagSet("encode", flag.ExitOnError)

	// encod subcommand flag pointers
	inputTextPtr := encodeCommand.String("input", "", "Text to parse. (Required)")

	// Verify that a subcommand has been provided
	// os.Arg[0] is the main command
	// os.Arg[1] will be the subcommand
	if len(os.Args) < 2 {
		fmt.Println("encode or decode subcommand is required")
		os.Exit(1)
	}

	// Switch on the subcommand
	// Parse the flags for appropriate FlagSet
	// os.Args[2:] will be all arguments starting after the subcommand at os.Args[1]
	switch os.Args[1] {
	case "encode":
		encodeCommand.Parse(os.Args[2:])
	default:
		flag.PrintDefaults()
		os.Exit(1)
	}

	// Check which subcommand was Parsed using the FlagSet.Parsed() function. Handle each case accordingly.
	// FlagSet.Parse() will evaluate to false if no flags were parsed
	if encodeCommand.Parsed() {
		// Required Flags
		if *inputTextPtr == "" {
			encodeCommand.PrintDefaults()
			os.Exit(1)
		}

		//Encode by scale codec and then base64
		buffer := bytes.Buffer{}
		se := codec.Encoder{&buffer}
		_, err := se.Encode(*inputTextPtr)
		if err != nil {
			os.Exit(1)
		}
		encodedText := base64.StdEncoding.EncodeToString(buffer.Bytes())
		// Print
		fmt.Printf("encoded %s: %s\n", *inputTextPtr, encodedText)
	}

}
