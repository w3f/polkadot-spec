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

package main

import (
	"bytes"
	"flag"
	"fmt"
	"github.com/ChainSafe/gossamer/lib/scale"
	"os"
)

func ProcessScaleCodecCommand(scale_codec_args []string) {
	//here we need to parse the args related to scale_codec

	// Subcommands
	encodeCommand := flag.NewFlagSet("encode", flag.ExitOnError)

	// encode subcommand flag pointers
	inputTextPtr := encodeCommand.String("input", "", "Text to parse. (Required)")

	// Verify that a subcommand has been provided
	// scale_codec_args[0] is the subcommand
	if len(scale_codec_args) < 1 {
		fmt.Println("encode or decode subcommand is required")
		os.Exit(1)
	}

	// Switch on the subcommand
	// Parse the flags for appropriate FlagSet
	// os.Args[2:] will be all arguments starting after the subcommand at os.Args[1]
	switch scale_codec_args[0] {
	case "encode":
		encodeCommand.Parse(scale_codec_args[1:])
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
		se := scale.Encoder{&buffer}
		_, err := se.Encode(*inputTextPtr)
		if err != nil {
			os.Exit(1)
		}

		encodedText := buffer.Bytes()

		fmt.Printf("encoded %s: [", *inputTextPtr)
		csvHexPrinter(encodedText)
		fmt.Printf("]\n")
	}

}
