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
// along with Polkadot RE Test Suite.  If not, see <https://www.gnu.org/licenses/>.

extern crate base64;
///This file is an interface to run Parity implementation of SCALE codec.
extern crate clap;
extern crate data_encoding;

use clap::ArgMatches;
use parity_scale_codec::Encode;

fn encode(matches: &ArgMatches) {
    let scale_encoded_value = matches.value_of("input").unwrap().encode();
    println!(
        "encoded {}: {:x?}",
        matches.value_of("input").unwrap(),
        &scale_encoded_value
    );
}

pub fn process_scale_codec_command(subcmd_matches: &ArgMatches) {
    if subcmd_matches.is_present("encode") {
        encode(subcmd_matches);
    }
}
