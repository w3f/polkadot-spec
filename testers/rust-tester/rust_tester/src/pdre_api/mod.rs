mod child_storage;
mod crypto;
mod misc;
mod network;
mod storage;
mod utils;

use clap::ArgMatches;
use utils::ParsedInput;

pub fn process_pdre_api_tests(subcmd_matches: &ArgMatches) {
    if let Some(func) = subcmd_matches.value_of("function") {
        let input: ParsedInput = subcmd_matches.values_of("input").unwrap().into();

        match func {
            // test crypto functions
            "test_blake2_128" => crypto::test_blake2_128(input),
            "test_blake2_256" => crypto::test_blake2_256(input),
            "test_blake2_256_enumerated_trie_root" => {
                crypto::test_blake2_256_enumerated_trie_root(input)
            }
            "test_ed25519" => crypto::test_ed25519(input),
            "test_keccak_256" => crypto::test_keccak_256(input),
            "test_sr25519" => crypto::test_sr25519(input),
            "test_twox_64" => crypto::test_twox_64(input),
            "test_twox_128" => crypto::test_twox_128(input),
            "test_twox_256" => crypto::test_twox_256(input),
            // TODO: Not fully implemented/tested
            "test_secp256k1_ecdsa_recover" => crypto::test_secp256k1_ecdsa_recover(input),
            //
            // test storage functions
            "test_allocate_storage" => storage::test_allocate_storage(),
            "test_clear_prefix" => storage::test_clear_prefix(input),
            "test_clear_storage" => storage::test_clear_storage(input),
            "test_exists_storage" => storage::test_exists_storage(input),
            "test_set_get_local_storage" => storage::test_set_get_local_storage(input),
            "test_set_get_storage" => storage::test_set_get_storage(input),
            "test_set_get_storage_into" => storage::test_set_get_storage_into(input),
            "test_storage_root" => storage::test_storage_root(input),
            // TODO: Not fully implemented/tested
            "test_storage_changes_root" => storage::test_storage_changes_root(input),
            "test_local_storage_compare_and_set" => {
                storage::test_local_storage_compare_and_set(input)
            }
            //
            // test child storage functions
            "test_clear_child_prefix" => child_storage::test_clear_child_prefix(input),
            "test_clear_child_storage" => child_storage::test_clear_child_storage(input),
            "test_exists_child_storage" => child_storage::test_exists_child_storage(input),
            "test_kill_child_storage" => child_storage::test_kill_child_storage(input),
            "test_set_get_child_storage" => child_storage::test_set_get_child_storage(input),
            "test_get_child_storage_into" => child_storage::test_get_child_storage_into(input),
            "test_child_storage_root" => child_storage::test_child_storage_root(input),
            //
            // test network functions
            "test_http" => network::test_http(),
            "test_network_state" => network::test_network_state(),
            //
            // miscellaneous functions
            // TODO: Not fully implemented/tested
            "test_chain_id" => misc::test_chain_id(),
            // TODO: Not fully implemented/tested
            "test_is_validator" => misc::test_is_validator(),
            // TODO: Not fully implemented/tested
            "test_submit_transaction" => misc::test_submit_transaction(input),
            // TODO: Not fully implemented/tested
            "test_timestamp" => misc::test_timestamp(),
            // TODO: Not fully implemented/tested
            "test_sleep_until" => misc::test_sleep_until(input),
            // TODO: Not fully implemented/tested
            "test_random_seed" => misc::test_random_seed(),
            //
            _ => panic!("specified function not available"),
        }
    }
}
