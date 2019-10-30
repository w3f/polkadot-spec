mod child_storage;
mod crypto;
mod network;
mod storage;
mod utils;

use clap::{ArgMatches, Values};

pub struct ParsedInput<'a>(Vec<&'a str>);

impl<'a> ParsedInput<'a> {
    pub fn get(&self, index: usize) -> &[u8] {
        if let Some(ret) = self.0.get(index) {
            ret.as_bytes()
        } else {
            panic!("failed to get index, wrong input data provided for the test function");
        }
    }
}

impl<'a> From<Values<'a>> for ParsedInput<'a> {
    fn from(input: Values<'a>) -> Self {
        ParsedInput(input.collect())
    }
}

pub fn process_pdre_api_tests(subcmd_matches: &ArgMatches) {
    if let Some(func) = subcmd_matches.value_of("function") {
        let input: ParsedInput = subcmd_matches.values_of("input").unwrap().into();

        match func {
            // test crypto functions
            "test_blake2_128" => crypto::test_blake2_128(input),
            "test_blake2_256" => crypto::test_blake2_256(input),
            // TODO: Call from Julia
            "test_blake2_256_enumerated_trie_root" => crypto::test_blake2_256_enumerated_trie_root(input),
            "test_ed25519" => crypto::test_ed25519(input),
            "test_keccak_256" => crypto::test_keccak_256(input),
            "test_sr25519" => crypto::test_sr25519(input),
            "test_twox_64" => crypto::test_twox_64(input),
            "test_twox_128" => crypto::test_twox_128(input),
            "test_twox_256" => crypto::test_twox_256(input),
            //
            // test storage functions
            "test_allocate_storage" => storage::test_allocate_storage(),
            "test_clear_prefix" => storage::test_clear_prefix(input),
            "test_clear_storage" => storage::test_clear_storage(input),
            "test_exists_storage" => storage::test_exists_storage(input),
            "test_set_get_local_storage" => storage::test_set_get_local_storage(input),
            "test_set_get_storage" => storage::test_set_get_storage(input),
            // TODO: Call from Julia
            "test_set_get_storage_into" => storage::test_set_get_storage_into(input),
            // TODO: Call from Julia
            "test_storage_root" => storage::test_storage_root(input),
            // TODO: Call from Julia
            "test_storage_changes_root" => storage::test_storage_changes_root(input),
            //
            // test child storage functions
            "test_clear_child_prefix" => child_storage::test_clear_child_prefix(input),
            "test_clear_child_storage" => child_storage::test_clear_child_storage(input),
            "test_exists_child_storage" => child_storage::test_exists_child_storage(input),
            "test_kill_child_storage" => child_storage::test_kill_child_storage(input),
            "test_set_get_child_storage" => child_storage::test_set_get_child_storage(input),
            // TODO: Call from Julia
            "test_get_child_storage_into" => child_storage::test_get_child_storage_into(input),
            // TODO: Call from Julia
            "test_child_storage_root" => child_storage::test_child_storage_root(input),
            //
            // test network functions
            "test_http" => network::test_http(),
            "test_network_state" => network::test_network_state(),
            //
            _ => panic!("specified functio not available"),
        }
    }
}
