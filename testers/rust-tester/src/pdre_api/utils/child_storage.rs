//! Contains wrappers for the calls to the Wasm blob (Runtime) APIs related to child storage functionality.
//! Those wrappers are specific to the Parity Substrate `WasmExecutor` implementation.
//!
//! Not relevant for other implementators. Look at the `tests/` directory for the acutal tests.

use super::{CallWasm, get_wasm_blob, Decoder};

use parity_scale_codec::Encode;

use sp_core::Blake2Hasher;
use sp_state_machine::TestExternalities as CoreTestExternalities;

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
    ) -> Vec<u8> {
        self
            .prep_wasm("rtm_ext_get_allocated_child_storage")
            .call(&(storage_key_data, key_data).encode())
            .decode_vec()
    }
    pub fn rtm_ext_get_child_storage_into(
        &mut self,
        storage_key_data: &[u8],
        key_data: &[u8],
        value_data: &[u8],
        value_offset: u32
    ) -> Vec<u8> {
        self
            .prep_wasm("rtm_ext_get_child_storage_into")
            .call(&(storage_key_data, key_data, value_data, value_offset).encode())
            .decode_vec()
    }
    pub fn rtm_ext_set_child_storage(
        &mut self,
        storage_key_data: &[u8],
        key_data: &[u8],
        value_data: &[u8],
    ) {
        self
            .prep_wasm("rtm_ext_set_child_storage")
            .call(&(storage_key_data, key_data, value_data).encode());
    }
    pub fn rtm_ext_clear_child_storage(&mut self, storage_key_data: &[u8], key_data: &[u8]) {
        self
            .prep_wasm("rtm_ext_clear_child_storage")
            .call(&(storage_key_data, key_data).encode());
    }
    pub fn rtm_ext_exists_child_storage(
        &mut self,
        storage_key_data: &[u8],
        key_data: &[u8],
    ) -> u32 {
        self
            .prep_wasm("rtm_ext_exists_child_storage")
            .call(&(storage_key_data, key_data).encode())
            .decode_u32()
    }
    pub fn rtm_ext_clear_child_prefix(&mut self, storage_key_data: &[u8], prefix_data: &[u8]) {
        self
            .prep_wasm("rtm_ext_clear_child_prefix")
            .call(&(storage_key_data, prefix_data).encode());
    }
    pub fn rtm_ext_kill_child_storage(&mut self, storage_key_data: &[u8]) {
        self
            .prep_wasm("rtm_ext_kill_child_storage")
            .call(&storage_key_data.encode());
    }
    pub fn rtm_ext_child_storage_root(&mut self, storage_key_data: &[u8]) -> Vec<u8> {
        self
            .prep_wasm("rtm_ext_child_storage_root")
            .call(&storage_key_data.encode())
            .decode_vec()
    }
}
