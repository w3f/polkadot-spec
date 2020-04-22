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

///This file is an interface to run various Polkadot RE functions

#[macro_use]
extern crate clap;
extern crate base64;
extern crate data_encoding;

// For PDRE API
extern crate hex;
extern crate sc_executor;
extern crate sp_core;
extern crate sp_state_machine;

use clap::App;

pub mod hash;
pub mod hasher;
mod pdre_api;
pub mod scale_codec;
pub mod trie_tester;

use trie_tester::TrieTester;

fn main() {
    let yaml_data = load_yaml!("cli.yaml");
    let matches = App::from_yaml(yaml_data).get_matches();

    if let Some(matches) = matches.subcommand_matches("scale-codec") {
        scale_codec::process_scale_codec_command(matches);
    } else if let Some(matches) = matches.subcommand_matches("state-trie") {
        let mut trie_tryer: TrieTester = TrieTester::new(matches);
        trie_tryer.process_state_trie_command(matches);
    } else if let Some(matches) = matches.subcommand_matches("pdre-api") {
        pdre_api::process_pdre_api_tests(matches);
    }
}
