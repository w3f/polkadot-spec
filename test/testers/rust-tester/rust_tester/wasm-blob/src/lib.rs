#![allow(dead_code)]
#![allow(unused_imports)]
use std::slice;

use parity_scale_codec::Decode;
use sp_core::wasm_export_functions;

fn from_mem(value: u64) -> Vec<u8> {
    let ptr = value as u32;
    let len = (value >> 32) as usize;
    unsafe {
        std::slice::from_raw_parts(ptr as *mut u8, len).to_vec()
    }
}

extern "C" {
    fn ext_storage_get_version_1(key: u64) -> u64; // Option
    fn ext_storage_set_version_1(key: u64, value: u64);
    fn ext_storage_clear_version_1(key: u64);
    fn ext_storage_exists_version_1(key: u64) -> i32; // Boolean
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
}