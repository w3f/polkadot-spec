#![allow(dead_code)]
#![allow(unused_imports)]
use std::slice;

#[cfg(feature = "runtime-wasm")]
use parity_scale_codec::{Decode, Encode};

#[cfg(not(feature = "runtime-wasm"))]
include!(concat!(env!("OUT_DIR"), "/wasm_binary.rs"));

#[cfg(feature = "runtime-wasm")]
extern "C" {
    // Storage API
    fn ext_storage_set_version_1(key: u64, value: u64);
    fn ext_storage_get_version_1(key: u64) -> u64;
    fn ext_storage_read_version_1(key: u64, out: u64, offset: u32) -> u64;
    fn ext_storage_clear_version_1(key: u64);
    fn ext_storage_exists_version_1(key: u64) -> i32;
    fn ext_storage_clear_prefix_version_1(key: u64);
    fn ext_storage_root_version_1() -> u64;
    fn ext_storage_next_key_version_1(key: u64) -> u64;

    // Default child stoage API
    fn ext_default_child_storage_set_version_1(child: u64, key: u64, value: u64);
    fn ext_default_child_storage_get_version_1(child: u64, key: u64) -> u64;
    fn ext_default_child_storage_read_version_1(child: u64, key: u64, out: u64, offset: u32) -> u64;
    fn ext_default_child_storage_clear_version_1(child: u64, key: u64);
    fn ext_default_child_storage_storage_kill_version_1(child: u64);
    fn ext_default_child_storage_exists_version_1(child: u64, key: u64) -> i32;
    fn ext_default_child_storage_clear_prefix_version_1(child: u64, key: u64);
    fn ext_default_child_storage_root_version_1(child: u64) -> u64;
    fn ext_default_child_storage_next_key_version_1(child: u64, key: u64) -> u64;

    // Crypto API
    fn ext_crypto_ed25519_public_keys_version_1(id: u32) -> u64;
    fn ext_crypto_ed25519_generate_version_1(id: u32, seed: u64) -> u32;
    fn ext_crypto_ed25519_sign_version_1(id: u32, pubkey: u32, msg: u64) -> u64;
    fn ext_crypto_ed25519_verify_version_1(sig: u32, msg: u64, pubkey: u32) -> i32;

    fn ext_crypto_sr25519_public_keys_version_1(id: u32) -> u64;
    fn ext_crypto_sr25519_generate_version_1(id: u32, seed: u64) -> u32;
    fn ext_crypto_sr25519_sign_version_1(id: u32, pubkey: u32, msg: u64) -> u64;
    fn ext_crypto_sr25519_verify_version_1(sig: u32, msg: u64, pubkey: u32) -> i32;

    fn ext_crypto_secp256k1_ecdsa_recover_version_1(sig: u32, msg: u32) -> u64;

    // Hashing API
    fn ext_hashing_keccak_256_version_1(data: u64) -> i32;
    fn ext_hashing_sha2_256_version_1(data: u64) -> i32;

    fn ext_hashing_blake2_128_version_1(data: u64) -> i32;
    fn ext_hashing_blake2_256_version_1(data: u64) -> i32;

    fn ext_hashing_twox_256_version_1(data: u64) -> i32;
    fn ext_hashing_twox_128_version_1(data: u64) -> i32;
    fn ext_hashing_twox_64_version_1(data: u64) -> i32;

    // Allocator API
    fn ext_allocator_malloc_version_1(size: u32) -> u32;
    fn ext_allocator_free_version_1(ptr: u32);

    // Trie API
    fn ext_trie_blake2_256_root_version_1(data: u64) -> u32;
    fn ext_trie_blake2_256_ordered_root_version_1(data: u64) -> u32;
}

#[cfg(feature = "runtime-wasm")]
fn from_mem(value: u64) -> Vec<u8> {
    let ptr = value as u32;
    let len = (value >> 32) as usize;
    unsafe { std::slice::from_raw_parts(ptr as *mut u8, len).to_vec() }
}

#[cfg(feature = "runtime-wasm")]
trait AsRePtr {
    fn as_re_ptr(&self) -> u64;
}

#[cfg(feature = "runtime-wasm")]
impl AsRePtr for Vec<u8> {
    fn as_re_ptr(&self) -> u64 {
        (self.len() as u64) << 32 | self.as_ptr() as u64
    }
}

#[cfg(feature = "runtime-wasm")]
sp_core::wasm_export_functions! {
    fn rtm_ext_storage_get_version_1(
        key_data: Vec<u8>
    ) -> Option<Vec<u8>> {
        unsafe {
            let value = ext_storage_get_version_1(
                key_data.as_re_ptr(),
            );
            Decode::decode(&mut from_mem(value).as_slice()).unwrap()
        }
    }
    fn rtm_ext_default_child_storage_get_version_1(
        child_key: Vec<u8>,
        key_data: Vec<u8>
    ) -> Option<Vec<u8>> {
        unsafe {
            let value = ext_default_child_storage_get_version_1(
                child_key.as_re_ptr(),
                key_data.as_re_ptr(),
            );
            Decode::decode(&mut from_mem(value).as_slice()).unwrap()
        }
    }
    fn rtm_ext_storage_read_version_1(
        key_data: Vec<u8>,
        offset: u32,
        buffer_size: u32 // not directly required for PDRE API, only used for testing
    ) -> Option<Vec<u8>> {
        let mut buffer = vec![0u8; buffer_size as usize];
        unsafe {
            let res = ext_storage_read_version_1(
                key_data.as_re_ptr(),
                buffer.as_re_ptr(),
                offset
            );

            Option::<u32>::decode(&mut from_mem(res).as_slice())
                .unwrap()
                .map(|n| buffer[..(n.min(buffer_size) as usize)].to_vec())
        }
    }
    fn rtm_ext_default_child_storage_read_version_1(
        child_key: Vec<u8>,
        key_data: Vec<u8>,
        offset: u32,
        buffer_size: u32 // not directly required for PDRE API, only used for testing
    ) -> Option<Vec<u8>> {
        let mut buffer = vec![0u8; buffer_size as usize];
        unsafe {
            let res = ext_default_child_storage_read_version_1(
                child_key.as_re_ptr(),
                key_data.as_re_ptr(),
                buffer.as_re_ptr(),
                offset
            );

            Option::<u32>::decode(&mut from_mem(res).as_slice())
                .unwrap()
                .map(|n| buffer[..(n.min(buffer_size) as usize)].to_vec())
        }
    }
    fn rtm_ext_storage_set_version_1(
        key_data: Vec<u8>,
        value_data: Vec<u8>
    ) {
        unsafe {
            let _ = ext_storage_set_version_1(
                key_data.as_re_ptr(),
                value_data.as_re_ptr()
            );
        }
    }
    fn rtm_ext_default_child_storage_set_version_1(
        child_key: Vec<u8>,
        key_data: Vec<u8>,
        value_data: Vec<u8>
    ) {
        unsafe {
            let _ = ext_default_child_storage_set_version_1(
                child_key.as_re_ptr(),
                key_data.as_re_ptr(),
                value_data.as_re_ptr()
            );
        }
    }
    fn rtm_ext_storage_clear_version_1(
        key_data: Vec<u8>
    ) {
        unsafe {
            let _ = ext_storage_clear_version_1(
                key_data.as_re_ptr(),
            );
        }
    }
    fn rtm_ext_default_child_storage_clear_version_1(
        child_key: Vec<u8>,
        key_data: Vec<u8>
    ) {
        unsafe {
            let _ = ext_default_child_storage_clear_version_1(
                child_key.as_re_ptr(),
                key_data.as_re_ptr(),
            );
        }
    }
    fn rtm_ext_default_child_storage_storage_kill_version_1(
        child_key: Vec<u8>,
    ) {
        unsafe {
            let _ = ext_default_child_storage_storage_kill_version_1(
                child_key.as_re_ptr(),
            );
        }
    }
    fn rtm_ext_storage_exists_version_1(
        key_data: Vec<u8>
    ) -> u32 {
        unsafe {
            ext_storage_exists_version_1(
                key_data.as_re_ptr(),
            ) as u32
        }
    }
    fn rtm_ext_default_child_storage_exists_version_1(
        child_key: Vec<u8>,
        key_data: Vec<u8>
    ) -> u32 {
        unsafe {
            ext_default_child_storage_exists_version_1(
                child_key.as_re_ptr(),
                key_data.as_re_ptr(),
            ) as u32
        }
    }
    fn rtm_ext_storage_clear_prefix_version_1(
        key_data: Vec<u8>
    ) {
        unsafe {
            let _ = ext_storage_clear_prefix_version_1(
                key_data.as_re_ptr(),
            );
        }
    }
    fn rtm_ext_default_child_storage_clear_prefix_version_1(
        child_key: Vec<u8>,
        key_data: Vec<u8>
    ) {
        unsafe {
            let _ = ext_default_child_storage_clear_prefix_version_1(
                child_key.as_re_ptr(),
                key_data.as_re_ptr(),
            );
        }
    }
    fn rtm_ext_storage_root_version_1() -> Vec<u8> {
        unsafe {
            let value = ext_storage_root_version_1();
            from_mem(value)
        }
    }
    fn rtm_ext_default_child_storage_root_version_1(child_key: Vec<u8>) -> Vec<u8> {
        unsafe {
            let value = ext_default_child_storage_root_version_1(
                child_key.as_re_ptr(),
            );
            from_mem(value)
        }
    }
    fn rtm_ext_storage_next_key_version_1(key_data: Vec<u8>) -> Option<Vec<u8>> {
        unsafe {
            let value = ext_storage_next_key_version_1(
                key_data.as_re_ptr(),
            );
            Decode::decode(&mut from_mem(value).as_slice()).unwrap()
        }
    }
    fn rtm_ext_default_child_storage_next_key_version_1(
        child_key: Vec<u8>,
        key_data: Vec<u8>
    ) -> Option<Vec<u8>> {
        unsafe {
            let value = ext_default_child_storage_next_key_version_1(
                child_key.as_re_ptr(),
                key_data.as_re_ptr(),
            );
            Decode::decode(&mut from_mem(value).as_slice()).unwrap()
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
                seed_data.as_re_ptr()
            );
            std::slice::from_raw_parts(value as *mut u8, 32).to_vec()
        }
    }
    fn rtm_ext_crypto_ed25519_sign_version_1(id_data: [u8; 4], pubkey_data: Vec<u8>, msg_data: Vec<u8>) -> Vec<u8> {
        unsafe {
            let value = ext_crypto_ed25519_sign_version_1(
                id_data.as_ptr() as u32,
                pubkey_data.as_ptr() as u32,
                msg_data.as_re_ptr()
            );
            from_mem(value)
        }
    }
    fn rtm_ext_crypto_ed25519_verify_version_1(sig_data: Vec<u8>, msg_data: Vec<u8>, pubkey_data: Vec<u8>) -> u32 {
        unsafe {
            ext_crypto_ed25519_verify_version_1(
                sig_data.as_ptr() as u32,
                msg_data.as_re_ptr(),
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
                seed_data.as_re_ptr()
            );
            std::slice::from_raw_parts(value as *mut u8, 32).to_vec()
        }
    }
    fn rtm_ext_crypto_sr25519_sign_version_1(id_data: [u8; 4], pubkey_data: Vec<u8>, msg_data: Vec<u8>) -> Vec<u8> {
        unsafe {
            let value = ext_crypto_sr25519_sign_version_1(
                id_data.as_ptr() as u32,
                pubkey_data.as_ptr() as u32,
                msg_data.as_re_ptr()
            );
            from_mem(value)
        }
    }
    fn rtm_ext_crypto_sr25519_verify_version_1(sig_data: Vec<u8>, msg_data: Vec<u8>, pubkey_data: Vec<u8>) -> u32 {
        unsafe {
            ext_crypto_sr25519_verify_version_1(
                sig_data.as_ptr() as u32,
                msg_data.as_re_ptr(),
                pubkey_data.as_ptr() as u32
            ) as u32
        }
    }
    fn rtm_ext_crypto_secp256k1_ecdsa_recover_version_1(sig_data: Vec<u8>, msg_data: Vec<u8>) -> Vec<u8> {
        unsafe {
            let value = ext_crypto_secp256k1_ecdsa_recover_version_1(
                sig_data.as_ptr() as u32,
                msg_data.as_ptr() as u32,
            );
            from_mem(value)
        }
    }
    fn rtm_ext_hashing_keccak_256_version_1(data: Vec<u8>) -> Vec<u8> {
        unsafe {
            let value = ext_hashing_keccak_256_version_1(
                data.as_re_ptr(),
            );
            std::slice::from_raw_parts(value as *mut u8, 32).to_vec()
        }
    }
    fn rtm_ext_hashing_sha2_256_version_1(data: Vec<u8>) -> Vec<u8> {
        unsafe {
            let value = ext_hashing_sha2_256_version_1(
                data.as_re_ptr(),
            );
            std::slice::from_raw_parts(value as *mut u8, 32).to_vec()
        }
    }
    fn rtm_ext_hashing_blake2_128_version_1(data: Vec<u8>) -> Vec<u8> {
        unsafe {
            let value = ext_hashing_blake2_128_version_1(
                data.as_re_ptr(),
            );
            std::slice::from_raw_parts(value as *mut u8, 16).to_vec()
        }
    }
    fn rtm_ext_hashing_blake2_256_version_1(data: Vec<u8>) -> Vec<u8> {
        unsafe {
            let value = ext_hashing_blake2_256_version_1(
                data.as_re_ptr(),
            );
            std::slice::from_raw_parts(value as *mut u8, 32).to_vec()
        }
    }
    fn rtm_ext_hashing_twox_256_version_1(data: Vec<u8>) -> Vec<u8> {
        unsafe {
            let value = ext_hashing_twox_256_version_1(
                data.as_re_ptr(),
            );
            std::slice::from_raw_parts(value as *mut u8, 32).to_vec()
        }
    }
    fn rtm_ext_hashing_twox_128_version_1(data: Vec<u8>) -> Vec<u8> {
        unsafe {
            let value = ext_hashing_twox_128_version_1(
                data.as_re_ptr(),
            );
            std::slice::from_raw_parts(value as *mut u8, 16).to_vec()
        }
    }
    fn rtm_ext_hashing_twox_64_version_1(data: Vec<u8>) -> Vec<u8> {
        unsafe {
            let value = ext_hashing_twox_64_version_1(
                data.as_re_ptr(),
            );
            std::slice::from_raw_parts(value as *mut u8, 8).to_vec()
        }
    }
    fn rtm_ext_allocator_malloc_version_1(value: Vec<u8>) -> Vec<u8> {
        use std::ptr;
        let size = value.len();

        unsafe {
            let ptr = ext_allocator_malloc_version_1(
                size as u32,
            ) as *mut u8;
            assert!(!ptr.is_null());

            // Write `value` to buffer
            ptr::copy(value.as_ptr(), ptr, size);
            // Read that value back from buffer
            let result = std::slice::from_raw_parts(ptr, size).to_vec();

            // Free buffer (panics if pointer is invalid)
            ext_allocator_free_version_1(
                ptr as u32
            );

            result
        }
    }
    fn rtm_ext_trie_blake2_256_root_version_1(data: Vec<(Vec<u8>, Vec<u8>)>) -> Vec<u8> {
        let data = data.encode();
        unsafe {
            let value = ext_trie_blake2_256_root_version_1(
                data.as_re_ptr()
            );
            std::slice::from_raw_parts(value as *mut u8, 32).to_vec()
        }
    }
    fn rtm_ext_trie_blake2_256_ordered_root_version_1(data: Vec<Vec<u8>>) -> Vec<u8> {
        let data = data.encode();
        unsafe {
            let value = ext_trie_blake2_256_ordered_root_version_1(
                data.as_re_ptr()
            );
            std::slice::from_raw_parts(value as *mut u8, 32).to_vec()
        }
    }
}
