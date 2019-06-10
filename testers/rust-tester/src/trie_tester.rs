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

///This file is an interface to run Parity implementation of state trie used in Polkadot RE.

extern crate clap;
extern crate serde_yaml;
extern crate trie_root;
extern crate reference_trie;

use trie_root::trie_root;
use reference_trie::ReferenceTrieStream;

use std::collections::BTreeMap;

//use trie::{Encode, Decode, HasCompact, Compact, EncodeAsRef, CompactAs};
use clap::{ArgMatches};

use crate::hasher::blake2::Blake2Hasher;

fn compute_state_root(matches: &ArgMatches) {
    let trie_key_value_file = matches.value_of("state-file").unwrap();

    let f = std::fs::File::open(trie_key_value_file).unwrap();

    // We are deserializing the state data in a BTree
    let key_value_map: BTreeMap<String, Vec<String>> = serde_yaml::from_reader(f).unwrap();
    
    //let trie_value =  key_value_map["data"];
    let trie_vec = key_value_map["keys"].iter().zip(key_value_map["values"].iter());
    let state_trie_root = trie_root::<Blake2Hasher, ReferenceTrieStream, _, _, _>(trie_vec);
    println!("state trie root: {:x?}", &state_trie_root);

}

pub fn process_state_trie_command(subcmd_matches: &ArgMatches) {
    if subcmd_matches.is_present("state-root") {
            compute_state_root(subcmd_matches);
    }
}

