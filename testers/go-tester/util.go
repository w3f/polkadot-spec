package main

import (
	"encoding/hex"
	"fmt"
)

func csvHexPrinter(encodedText []byte) {
	hexEncoded := make([]byte, hex.EncodedLen(len(encodedText)))
	hex.Encode(hexEncoded, encodedText)

	bihexcode := make([]byte, 2)
	for i, c := range hexEncoded {
		if i%2 == 0 {
			bihexcode[0] = c
		} else {
			bihexcode[1] = c
			if bihexcode[0] == '0' {
				fmt.Printf("%c", bihexcode[1])
			} else {
				fmt.Printf("%s", bihexcode)
			}
			if i < len(hexEncoded)-1 {
				fmt.Printf(", ")
			}
		}
	}
}
