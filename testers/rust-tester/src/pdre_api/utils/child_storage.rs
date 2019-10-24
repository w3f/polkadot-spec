//! Contains wrappers for the calls to the Wasm blob (Runtime) APIs related to child storage functionality.
//! Those wrappers are specific to the Parity Substrate `WasmExecutor` implementation.
//!
//! Not relevant for other implementators. Look at the `tests/` directory for the acutal tests.

use super::{copy_u32, de_scale_u32, get_wasm_blob, le, wrap, CallWasm};

use parity_scale_codec::{Encode, Decode};

use substrate_primitives::Blake2Hasher;
use substrate_state_machine::TestExternalities as CoreTestExternalities;

type TestExternalities<H> = CoreTestExternalities<H, u64>;

pub struct ChildStorageApi {
    blob: Vec<u8>,
    ext: TestExternalities<Blake2Hasher>,
}

impl ChildStorageApi {
    pub fn new() -> Self {
        ChildStorageApi {
            blob: get_wasm_blob(),
            ext: TestExternalities::default(),
        }
    }
    fn prep_wasm<'a>(&'a mut self, method: &'a str) -> CallWasm<'a> {
        CallWasm::new(&mut self.ext, &self.blob, method)
    }
    pub fn rtm_ext_get_allocated_child_storage(
        &mut self,
        storage_key_data: &[u8],
        key_data: &[u8],
        written_out: &mut u32,
    ) -> Vec<u8> {
        let mut wasm = self.prep_wasm("test_ext_get_allocated_child_storage");
        let res = wasm.call(&(storage_key_data, key_data).encode());
        Vec::<u8>::decode(&mut res.as_slice()).unwrap()
    }
    pub fn rtm_ext_set_child_storage(
        &mut self,
        storage_key_data: &[u8],
        key_data: &[u8],
        value_data: &[u8],
    ) {
        let mut wasm = self.prep_wasm("test_ext_set_child_storage");
        let _ = wasm.call(&(storage_key_data, key_data, value_data).encode());
    }
    pub fn rtm_ext_clear_child_storage(&mut self, storage_key_data: &[u8], key_data: &[u8]) {
        let mut wasm = self.prep_wasm("test_ext_clear_child_storage");
        let _ = wasm.call(&(storage_key_data, key_data).encode());
    }
    pub fn rtm_ext_exists_child_storage(
        &mut self,
        storage_key_data: &[u8],
        key_data: &[u8],
    ) -> u32 {
        let mut wasm = self.prep_wasm("test_ext_exists_child_storage");
        de_scale_u32(wasm.call(&(storage_key_data, key_data).encode()))
    }
    pub fn rtm_ext_clear_child_prefix(&mut self, storage_key_data: &[u8], prefix_data: &[u8]) {
        let mut wasm = self.prep_wasm("test_ext_clear_child_prefix");
        let _ = wasm.call(&(storage_key_data, prefix_data).encode());
    }
    pub fn rtm_ext_kill_child_storage(&mut self, storage_key_data: &[u8]) {
        let mut wasm = self.prep_wasm("test_ext_kill_child_storage");
        let _ = wasm.call(&storage_key_data.encode());
    }
}
