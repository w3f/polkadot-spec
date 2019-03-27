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

extern crate clap;

///This file is an interface to run Parity implementation of SCALE codec.

//use std::process;
extern crate base64;
use parity_codec::{Encode, Decode, HasCompact, Compact, EncodeAsRef, CompactAs};
use clap::{Arg, ArgMatches, App, SubCommand};
fn encode(matches: &ArgMatches) {
    let scale_encoded_value = matches.value_of("input").unwrap().encode();
    
    println!("encoded {}: {}", matches.value_of("input").unwrap(), base64::encode(&scale_encoded_value));
}

fn main() {
    let matches = App::new("SCALE codec tester")
        .version("0.1")
        .about("Simple SCALE CLI enocder/decoder")
        .subcommand(SubCommand::with_name("encode")
                    .about("Encode input using SCALE codec")
                    .arg(Arg::with_name("input")
                         .long("input")
                         .short("i")
                         .required(true)
                         .value_name("INPUT_VALUE")
                         .help("the value to be encoded")))
        .get_matches();

    if let Some(matches) = matches.subcommand_matches("encode") {
        encode(matches);
    }
}

