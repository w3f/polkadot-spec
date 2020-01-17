#![allow(dead_code)]
#![allow(unused_imports)]
use std::slice;

use sp_core::wasm_export_functions;

extern "C" {
    fn ext_storage_set(key_data: *const u8, key_len: u32, value_data: *const u8, value_len: u32);
    fn ext_storage_get(key_data: *const u8, key_len: u32) -> u64;
}

#[cfg(not(feature = "std"))]

wasm_export_functions! {
    fn rtm_ext_storage_set(
        key_data: Vec<u8>,
        value_data: Vec<u8>,
    ) {
        unsafe {
            ext_storage_set(
                key_data.as_ptr(),
                key_data.len() as u32,
                value_data.as_ptr(),
                value_data.len() as u32
            );
        }
    }
    fn rtm_ext_storage_get(
        key_data: Vec<u8>,
    ) {
        unsafe {
            ext_storage_get(
                key_data.as_ptr(),
                key_data.len() as u32,
            );
        }
    }
}