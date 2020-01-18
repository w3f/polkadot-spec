#![allow(dead_code)]
#![allow(unused_imports)]
use std::slice;

use sp_core::wasm_export_functions;

extern "C" {
    fn ext_storage_get_version_1(data: u64) -> u64;
    fn ext_storage_set_version_1(data: u64) -> u64;
}

wasm_export_functions! {
    fn rtm_ext_storage_get(
        key_data: Vec<u8>,
    ) -> u64 {
        unsafe {
            ext_storage_get_version_1(
			    (key_data.len() as u64) << 32 | key_data.as_ptr() as u64,
            )
        }
    }
    fn rtm_ext_storage_set(
        key_data: Vec<u8>,
        value_data: Vec<u8>,
    ) -> u64 {
        unsafe {
            ext_storage_set_version_1(
			    (key_data.len() as u64) << 32 | key_data.as_ptr() as u64,
            )
        }
    }
}