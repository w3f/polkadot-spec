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

///This file is an interface to run Parity implementation of state trie used in Polkadot Host.

extern crate clap;
extern crate hex;
extern crate reference_trie;
extern crate serde_yaml;
extern crate trie_db;
extern crate trie_root;

use reference_trie::ReferenceTrieStreamNoExt as ReferenceTrieStream;
use trie_db::TrieMut;
use trie_root::trie_root_no_extension;

use memory_db::{HashKey, MemoryDB};
use std::collections::BTreeMap;

use reference_trie::GenericNoExtensionLayout; //H;
                                              //use trie_db::{TrieRootPrint, trie_visit};

// pub struct PolkadotTrieLayout;

// impl TrieLayOut for PolkadotTrieLayout {
// 	const USE_EXTENSION: bool = false;
// 	type H = Blake2Hasher;
// 	type C = ReferenceNodeCodecNoExt<BitMap16>;
// 	type N = NibbleHalf;
// 	type CB = Cache16;
// }

pub use primitive_types::{H160, H256, H512};

//use trie::{Encode, Decode, HasCompact, Compact, EncodeAsRef, CompactAs};
use clap::ArgMatches;

use crate::hasher::blake2::Blake2Hasher;

///An object to perform various tests on a trie
pub struct TrieTester {
    keys: Vec<Vec<u8>>,
    values: Vec<Vec<u8>>,
}

impl TrieTester {
    ////Create TrieTester and read its data according to the command line arg

    pub fn new(matches: &ArgMatches) -> Self {
        let trie_key_value_file = matches.value_of("state-file").unwrap();

        let f = std::fs::File::open(trie_key_value_file).unwrap();

        // We are deserializing the state data in a BTree
        let key_value_map: BTreeMap<String, Vec<String>> = serde_yaml::from_reader(f).unwrap();

        TrieTester {
            keys: key_value_map["keys"].iter().map(
                |k| if matches.is_present("keys-in-hex") {
                        hex::decode(k).expect("Decoding failed")
                    } else {
                        k.clone().into_bytes()
                    }).collect(),
            values: key_value_map["values"].iter().map(
                |v| if matches.is_present("values-in-hex") {
                        hex::decode(v).expect("Decoding failed")
                    } else {
                        v.clone().into_bytes()
                    }).collect(),
        }
    }

    ///read a yaml file containig key value pairs and return a list of key

    /// Create a trie from the key value yaml file and compute its hash and print it out.
    ///
    /// # Arguments
    ///
    /// * `Argmatches` - the resulting command line argument matches from clap processor related to state-trie command
    ///
    fn compute_state_root(&self, _matches: &ArgMatches) {
        //let trie_value =  key_value_map["data"];
        let trie_vec: Vec<_> = self
            .keys
            .iter()
            .zip(self.values.iter())
            .collect();

        let state_trie_root =
            trie_root_no_extension::<Blake2Hasher, ReferenceTrieStream, _, _, _>(trie_vec);
        println!("state root: {:x}", &state_trie_root);
    }

    /// Perform a sequentials insert and delete test: it insert the key value pairs from the yaml file
    /// One by one and compute the hash at each stages then it takes
    /// random steps in the key list equal to the first byte of the last hash it has computed and delete
    /// the key it lands on and print the hash of the the new trie. It continue this process till all
    /// keys are deleted.
    fn insert_and_delete_test(&mut self, _matches: &ArgMatches) {
        let mut memdb = MemoryDB::<_, HashKey<_>, _>::default();
        let mut root = Default::default();

        //let mut memtrie = RefTrieDBMutNoExt::new(&mut memdb, &mut root);
        pub type RefPolkadotTrieDBMutNoExt<'a> =
            trie_db::TrieDBMut<'a, GenericNoExtensionLayout<Blake2Hasher>>;
        let mut memtrie = RefPolkadotTrieDBMutNoExt::new(&mut memdb, &mut root);

        for i in 0..self.keys.len() {
            let key: &[u8] = &self.keys[i];
            let val: &[u8] = &self.values[i];
            memtrie.insert(key, val).unwrap();
            memtrie.commit();
            println!("state root: {:x}", memtrie.root());
        }

        //now we randomly drop nodes
        while self.keys.len() > 0 {
            let key_index_to_drop = memtrie.root()[0] as usize % self.keys.len();
            let key_to_drop = &self.keys[key_index_to_drop];
            memtrie.remove(key_to_drop).unwrap();
            memtrie.commit();
            println!("state root: {:x}", memtrie.root());
            self.keys.remove(key_index_to_drop);
        }
    }

    pub fn process_state_trie_command(&mut self, subcmd_matches: &ArgMatches) {
        if let Some(trie_subcommand) = subcmd_matches.value_of("trie-subcommand") {
            if trie_subcommand == "trie-root" {
                self.compute_state_root(subcmd_matches);
            } else if trie_subcommand == "insert-and-delete" {
                self.insert_and_delete_test(subcmd_matches);
            }
        } else {
            panic!("trie-root subcommand is required");
        }
    }
}
