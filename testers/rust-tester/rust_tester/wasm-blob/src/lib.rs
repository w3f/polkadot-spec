#![allow(dead_code)]
#![allow(unused_imports)]
use std::slice;

use parity_scale_codec::{Encode, Decode};
use sp_core::wasm_export_functions;

fn from_mem(value: u64) -> Vec<u8> {
    let ptr = value as u32;
    let len = (value >> 32) as usize;
    unsafe {
        std::slice::from_raw_parts(ptr as *mut u8, len).to_vec()
    }
}

extern "C" {
    fn ext_storage_get_version_1(key: u64) -> u64;
    fn ext_storage_set_version_1(key: u64, value: u64);
    fn ext_storage_clear_version_1(key: u64);
    fn ext_storage_exists_version_1(key: u64) -> i32;
    fn ext_storage_clear_prefix_version_1(key: u64);
    fn ext_storage_root_version_1() -> u64;
    fn ext_storage_next_key_version_1(key: u64) -> u64;
    fn ext_crypto_ed25519_public_keys_version_1(id: u32) -> u64;
    fn ext_crypto_ed25519_generate_version_1(id: u32, seed: u64) -> u32;
    fn ext_crypto_ed25519_sign_version_1(id: u32, pubkey: u32, msg: u64) -> u64;
    fn ext_crypto_ed25519_verify_version_1(sig: u32, msg: u64, pubkey: u32) -> i32;
    fn ext_crypto_sr25519_public_keys_version_1(id: u32) -> u64;
    fn ext_crypto_sr25519_generate_version_1(id: u32, seed: u64) -> u32;
    fn ext_crypto_sr25519_sign_version_1(id: u32, pubkey: u32, msg: u64) -> u64;
    fn ext_crypto_sr25519_verify_version_1(sig: u32, msg: u64, pubkey: u32) -> i32;
    fn ext_hashing_keccak_256_version_1(data: u64) -> i32;
    fn ext_hashing_sha2_256_version_1(data: u64) -> i32;
    fn ext_hashing_blake2_128_version_1(data: u64) -> i32;
    fn ext_hashing_blake2_256_version_1(data: u64) -> i32;
}

wasm_export_functions! {
    fn rtm_ext_storage_get(
        key_data: Vec<u8>
    ) -> Vec<u8> {
        unsafe {
            let value = ext_storage_get_version_1(
			    (key_data.len() as u64) << 32 | key_data.as_ptr() as u64,
            );
            from_mem(value)
        }
    }
    fn rtm_ext_storage_set(
        key_data: Vec<u8>,
        value_data: Vec<u8>
    ) {
        unsafe {
            let _ = ext_storage_set_version_1(
			    (key_data.len() as u64) << 32 | key_data.as_ptr() as u64,
			    (value_data.len() as u64) << 32 | value_data.as_ptr() as u64
            );
        }
    }
    fn rtm_ext_storage_clear_version_1(
        key_data: Vec<u8>
    ) {
        unsafe {
            let _ = ext_storage_clear_version_1(
			    (key_data.len() as u64) << 32 | key_data.as_ptr() as u64,
            );
        }
    }
    fn rtm_ext_storage_exists_version_1(
        key_data: Vec<u8>
    ) -> u32 {
        unsafe {
            ext_storage_exists_version_1(
			    (key_data.len() as u64) << 32 | key_data.as_ptr() as u64,
            ) as u32
        }
    }
    fn rtm_ext_storage_clear_prefix_version_1(
        key_data: Vec<u8>
    ) {
        unsafe {
            let _ = ext_storage_clear_prefix_version_1(
			    (key_data.len() as u64) << 32 | key_data.as_ptr() as u64,
            );
        }
    }
    fn rtm_ext_storage_root_version_1() -> Vec<u8> {
        unsafe {
            let value = ext_storage_root_version_1();
            from_mem(value)
        }
    }
    fn rtm_ext_storage_next_key_version_1(key_data: Vec<u8>) -> Vec<u8> {
        unsafe {
            let value = ext_storage_next_key_version_1(
			    (key_data.len() as u64) << 32 | key_data.as_ptr() as u64,
            );
            from_mem(value)
        }
    }
    fn rtm_ext_crypto_ed25519_public_keys_version_1(id_data: [u8; 4]) -> Vec<u8> {
        unsafe {
            let value = ext_crypto_ed25519_public_keys_version_1(
			    id_data.as_ptr() as u32,
            );
            from_mem(value)
        }
    }
    fn rtm_ext_crypto_ed25519_generate_version_1(id_data: [u8; 4], seed_data: Option<Vec<u8>>) -> Vec<u8> {
        let seed_data = seed_data.encode();
        unsafe {
            let value = ext_crypto_ed25519_generate_version_1(
			    id_data.as_ptr() as u32,
                (seed_data.len() as u64) << 32 | seed_data.as_ptr() as u64
            );
            std::slice::from_raw_parts(value as *mut u8, 32).to_vec()
        }
    }
    fn rtm_ext_crypto_ed25519_sign_version_1(id_data: [u8; 4], pubkey_data: Vec<u8>, msg_data: Vec<u8>) -> Vec<u8> {
        unsafe {
            let value = ext_crypto_ed25519_sign_version_1(
                id_data.as_ptr() as u32,
                pubkey_data.as_ptr() as u32,
                (msg_data.len() as u64) << 32 | msg_data.as_ptr() as u64
            );
            from_mem(value)
        }
    }
    fn rtm_ext_crypto_ed25519_verify_version_1(sig_data: Vec<u8>, msg_data: Vec<u8>, pubkey_data: Vec<u8>) -> u32 {
        unsafe {
            ext_crypto_ed25519_verify_version_1(
                sig_data.as_ptr() as u32,
                (msg_data.len() as u64) << 32 | msg_data.as_ptr() as u64,
                pubkey_data.as_ptr() as u32
            ) as u32
        }
    }
    fn rtm_ext_crypto_sr25519_public_keys_version_1(id_data: [u8; 4]) -> Vec<u8> {
        unsafe {
            let value = ext_crypto_sr25519_public_keys_version_1(
			    id_data.as_ptr() as u32,
            );
            from_mem(value)
        }
    }
    fn rtm_ext_crypto_sr25519_generate_version_1(id_data: [u8; 4], seed_data: Option<Vec<u8>>) -> Vec<u8> {
        let seed_data = seed_data.encode();
        unsafe {
            let value = ext_crypto_sr25519_generate_version_1(
			    id_data.as_ptr() as u32,
                (seed_data.len() as u64) << 32 | seed_data.as_ptr() as u64
            );
            std::slice::from_raw_parts(value as *mut u8, 32).to_vec()
        }
    }
    fn rtm_ext_crypto_sr25519_sign_version_1(id_data: [u8; 4], pubkey_data: Vec<u8>, msg_data: Vec<u8>) -> Vec<u8> {
        unsafe {
            let value = ext_crypto_sr25519_sign_version_1(
                id_data.as_ptr() as u32,
                pubkey_data.as_ptr() as u32,
                (msg_data.len() as u64) << 32 | msg_data.as_ptr() as u64
            );
            from_mem(value)
        }
    }
    fn rtm_ext_crypto_sr25519_verify_version_1(sig_data: Vec<u8>, msg_data: Vec<u8>, pubkey_data: Vec<u8>) -> u32 {
        unsafe {
            ext_crypto_sr25519_verify_version_1(
                sig_data.as_ptr() as u32,
                (msg_data.len() as u64) << 32 | msg_data.as_ptr() as u64,
                pubkey_data.as_ptr() as u32
            ) as u32
        }
    }
    fn rtm_ext_hashing_keccak_256_version_1(data: Vec<u8>) -> Vec<u8> {
        unsafe {
            let value = ext_hashing_keccak_256_version_1(
                (data.len() as u64) << 32 | data.as_ptr() as u64,
            );
            std::slice::from_raw_parts(value as *mut u8, 32).to_vec()
        }
    }
    fn rtm_ext_hashing_sha2_256_version_1(data: Vec<u8>) -> Vec<u8> {
        unsafe {
            let value = ext_hashing_sha2_256_version_1(
                (data.len() as u64) << 32 | data.as_ptr() as u64,
            );
            std::slice::from_raw_parts(value as *mut u8, 32).to_vec()
        }
    }
    fn rtm_ext_hashing_blake2_128_version_1(data: Vec<u8>) -> Vec<u8> {
        unsafe {
            let value = ext_hashing_blake2_128_version_1(
                (data.len() as u64) << 32 | data.as_ptr() as u64,
            );
            std::slice::from_raw_parts(value as *mut u8, 16).to_vec()
        }
    }
    fn rtm_ext_hashing_blake2_256_version_1(data: Vec<u8>) -> Vec<u8> {
        unsafe {
            let value = ext_hashing_blake2_256_version_1(
                (data.len() as u64) << 32 | data.as_ptr() as u64,
            );
            std::slice::from_raw_parts(value as *mut u8, 32).to_vec()
        }
    }
}
