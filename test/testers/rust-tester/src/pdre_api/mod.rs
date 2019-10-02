mod crypto;
mod network;
mod storage;
mod utils;

use clap::{ArgMatches, Values};

struct ParsedInput<'a>(Vec<&'a str>);

impl<'a> ParsedInput<'a> {
    fn get(&self, index: usize) -> &str {
        if let Some(ret) = self.0.get(index) {
            ret
        } else {
            panic!("wrong input data provided for the test function");
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
        if let Some(input) = subcmd_matches.values_of("input") {

        } else {

        }

/*
        match func {
            "test_blake2_128" => crypto::test_blake2_128(),
            "test_blake2_256" => crypto::test_blake2_256(),
            "test_ed25519" => crypto::test_ed25519(),
            "test_keccak_256" => crypto::test_keccak_256(),
            "test_sr25519" => crypto::test_sr25519(),
            "test_twox_64" => crypto::test_twox_64(),
            "test_twox_128" => crypto::test_twox_128(),
            "test_twox_256" => crypto::test_twox_256(),
        }
        */
    }

    /*
    println!("***** PDRE API Test Suite *****");
    println!("NOTE: not all tests display information, only those deemed necessary. If a test fails, this program panics.");
    println!("");

    // crypto tests
    println!("Running crypto tests...");
    crypto::test_blake2_128();
    crypto::test_blake2_256();
    crypto::test_ed25519();
    crypto::test_keccak_256();
    crypto::test_sr25519();
    crypto::test_twox_64();
    crypto::test_twox_128();
    crypto::test_twox_256();
    println!("DONE - OK!");

    // network tests
    println!("**********");
    println!("Running network tests...");
    network::test_http();
    network::test_network_state();
    println!("DONE - OK!");

    // storage tests
    println!("**********");
    println!("Running storage tests...");
    storage::test_allocate_storage();
    storage::test_clear_child_prefix();
    storage::test_clear_child_storage();
    storage::test_clear_prefix();
    storage::test_clear_storage();
    storage::test_exists_child_storage();
    storage::test_exists_storage();
    storage::test_kill_child_storage();
    storage::test_set_get_child_storage();
    storage::test_set_get_local_storage();
    storage::test_set_get_storage();
    storage::test_storage_root();
    println!("DONE - OK!");
    */
}