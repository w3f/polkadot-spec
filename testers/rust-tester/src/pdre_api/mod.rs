mod legacy;
mod utils;

use utils::ParsedInput;
use clap::ArgMatches;

pub fn process_pdre_api_tests(subcmd_matches: &ArgMatches) {
    if let Some(func) = subcmd_matches.value_of("function") {
        let input: ParsedInput = subcmd_matches.values_of("input").unwrap().into();

        match func {
            // test crypto functions
            "test_blake2_128" => legacy::crypto::test_blake2_128(input),
            "test_blake2_256" => legacy::crypto::test_blake2_256(input),
            "test_blake2_256_enumerated_trie_root" => legacy::crypto::test_blake2_256_enumerated_trie_root(input),
            "test_ed25519" => legacy::crypto::test_ed25519(input),
            "test_keccak_256" => legacy::crypto::test_keccak_256(input),
            "test_sr25519" => legacy::crypto::test_sr25519(input),
            "test_twox_64" => legacy::crypto::test_twox_64(input),
            "test_twox_128" => legacy::crypto::test_twox_128(input),
            "test_twox_256" => legacy::crypto::test_twox_256(input),
            // TODO: Call from Julia
            "test_secp256k1_ecdsa_recover" => legacy::crypto::test_secp256k1_ecdsa_recover(input),
            //
            // test storage functions
            "test_allocate_storage" => legacy::storage::test_allocate_storage(),
            "test_clear_prefix" => legacy::storage::test_clear_prefix(input),
            "test_clear_storage" => legacy::storage::test_clear_storage(input),
            "test_exists_storage" => legacy::storage::test_exists_storage(input),
            "test_set_get_local_storage" => legacy::storage::test_set_get_local_storage(input),
            "test_set_get_storage" => legacy::storage::test_set_get_storage(input),
            "test_set_get_storage_into" => legacy::storage::test_set_get_storage_into(input),
            "test_storage_root" => legacy::storage::test_storage_root(input),
            // TODO: Call from Julia
            "test_storage_changes_root" => legacy::storage::test_storage_changes_root(input),
            "test_local_storage_compare_and_set" => legacy::storage::test_local_storage_compare_and_set(input),
            //
            // test child storage functions
            "test_clear_child_prefix" => legacy::child_storage::test_clear_child_prefix(input),
            "test_clear_child_storage" => legacy::child_storage::test_clear_child_storage(input),
            "test_exists_child_storage" => legacy::child_storage::test_exists_child_storage(input),
            "test_kill_child_storage" => legacy::child_storage::test_kill_child_storage(input),
            "test_set_get_child_storage" => legacy::child_storage::test_set_get_child_storage(input),
            "test_get_child_storage_into" => legacy::child_storage::test_get_child_storage_into(input),
            "test_child_storage_root" => legacy::child_storage::test_child_storage_root(input),
            //
            // test network functions
            "test_http" => legacy::network::test_http(),
            "test_network_state" => legacy::network::test_network_state(),
            //
            // miscellaneous functions
            // TODO: Call from Julia
            "test_chain_id" => legacy::misc::test_chain_id(),
            // TODO: Call from Julia
            "test_is_validator" => legacy::misc::test_is_validator(),
            // TODO: Call from Julia
            "test_submit_transaction" => legacy::misc::test_submit_transaction(input),
            // TODO: Call from Julia
            "test_timestamp" => legacy::misc::test_timestamp(),
            // TODO: Call from Julia
            "test_sleep_until" => legacy::misc::test_sleep_until(input),
            // TODO: Call from Julia
            "test_random_seed" => legacy::misc::test_random_seed(),
            //
            _ => panic!("specified function not available"),
        }
    }
}
