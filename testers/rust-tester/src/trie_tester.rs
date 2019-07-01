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
extern crate trie_db;
extern crate reference_trie;
extern crate hex;

use trie_root::trie_root_no_ext;
use reference_trie::ReferenceTrieStreamNoExt as ReferenceTrieStream;
use reference_trie::LayoutNew;//H;
use trie_db::trie_visit;
use memory_db::{MemoryDB, HashKey};
use std::collections::BTreeMap;

//use trie::{Encode, Decode, HasCompact, Compact, EncodeAsRef, CompactAs};
use clap::{ArgMatches};

use crate::hasher::blake2::Blake2Hasher;

fn compute_state_root(matches: &ArgMatches) {
    let trie_key_value_file = matches.value_of("state-file").unwrap();

    let f = std::fs::File::open(trie_key_value_file).unwrap();

    // We are deserializing the state data in a BTree
    let key_value_map: BTreeMap<String, Vec<String>> = serde_yaml::from_reader(f).unwrap();

    let key_list = &key_value_map["keys"];
    let value_list = &key_value_map["values"];

    let mut processed_key_list : Vec<Vec<u8>> = Vec::new();

    if !(matches.is_present("keys-in-hex")) {
        for cur_key_str in key_list.iter() {
            processed_key_list.push(cur_key_str.clone().into_bytes());
        }
    } else {
        for cur_key_str in key_list.iter() {
            processed_key_list.push(hex::decode(cur_key_str).expect("Decoding failed"));
        }
    }
        
    //let trie_value =  key_value_map["data"];
    let trie_vec: Vec<_> = processed_key_list.iter().zip(value_list.iter()).collect();

    let state_trie_root = trie_root_no_ext::<Blake2Hasher, ReferenceTrieStream, _, _, _>(trie_vec);
    println!("state root: {:x}", &state_trie_root);

}

pub fn process_state_trie_command(subcmd_matches: &ArgMatches) {
    if subcmd_matches.is_present("trie-root") {
            compute_state_root(subcmd_matches);
    }
}

