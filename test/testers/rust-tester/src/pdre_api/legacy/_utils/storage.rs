//! Contains wrappers for the calls to the Wasm blob (Runtime) APIs related to storage functionality.
//! Those wrappers are specific to the Parity Substrate `WasmExecutor` implementation.
//!
//! Not relevant for other implementators. Look at the `tests/` directory for the acutal tests.

use super::{CallWasm, get_wasm_blob, Decoder};

use parity_scale_codec::Encode;
use sp_offchain::testing::TestOffchainExt;
use sp_core::{Blake2Hasher, {offchain::OffchainExt}};
use sp_state_machine::TestExternalities as CoreTestExternalities;

type TestExternalities<H> = CoreTestExternalities<H, u64>;

pub struct StorageApi {
    blob: Vec<u8>,
    ext: TestExternalities<Blake2Hasher>,
}

impl StorageApi {
    pub fn new() -> Self {
        StorageApi {
            blob: get_wasm_blob(),
            ext: TestExternalities::default(),
        }
    }
    pub fn new_with_offchain_context() -> Self {
        let mut ext = TestExternalities::default();
        let (offchain, _) = TestOffchainExt::new();
        ext.register_extension(OffchainExt::new(offchain));

        StorageApi {
            blob: get_wasm_blob(),
            ext: ext,
        }
    }
    fn prep_wasm<'a>(&'a mut self, method: &'a str) -> CallWasm<'a> {
        CallWasm::new(&mut self.ext, &self.blob, method)
    }
    pub fn rtm_ext_malloc(&mut self, size: u32) -> Vec<u8> {
        let mut wasm = self.prep_wasm("rtm_ext_malloc");

        let res = wasm.call(u32::encode(&size).as_slice());
        res
    }
    pub fn rtm_ext_free(&mut self, data: &[u8]) {
        self
            .prep_wasm("rtm_ext_free")
            .call(data.encode().as_slice());
    }
    pub fn rtm_ext_set_storage(&mut self, key_data: &[u8], value_data: &[u8]) {
        self
            .prep_wasm("rtm_ext_set_storage")
            .call(&(key_data, value_data).encode());
    }
    pub fn rtm_ext_get_allocated_storage(&mut self, key_data: &[u8]) -> Vec<u8> {
        self
            .prep_wasm("rtm_ext_get_allocated_storage")
            .call(&key_data.encode())
            .decode_vec()
    }
    pub fn rtm_ext_clear_storage(&mut self, key_data: &[u8]) {
        self
            .prep_wasm("rtm_ext_clear_storage")
            .call(&key_data.encode());
    }
    pub fn rtm_ext_exists_storage(&mut self, key_data: &[u8]) -> u32 {
        self
            .prep_wasm("rtm_ext_exists_storage")
            .call(&key_data.encode())
            .decode_u32()
    }
    pub fn rtm_ext_clear_prefix(&mut self, prefix_data: &[u8]) {
        self
            .prep_wasm("rtm_ext_clear_prefix")
            .call(&prefix_data.encode());
    }
    pub fn rtm_ext_storage_root(&mut self) -> Vec<u8> {
        self
            .prep_wasm("rtm_ext_storage_root")
            .call(&[])
            .decode_vec()
    }
    pub fn rtm_ext_local_storage_set(&mut self, kind: u32, key_data: &[u8], value_data: &[u8]) {
        self
            .prep_wasm("rtm_ext_local_storage_set")
            .call(&(kind, key_data, value_data).encode());
    }
    pub fn rtm_ext_local_storage_get(&mut self, kind: u32, key_data: &[u8]) -> Vec<u8> {
        self
            .prep_wasm("rtm_ext_local_storage_get")
            .call(&(kind, key_data).encode())
            .decode_vec()
    }
    pub fn rtm_ext_local_storage_compare_and_set(&mut self, kind: u32, key_data: &[u8], old_value: &[u8], new_value: &[u8]) -> u32 {
        self
            .prep_wasm("rtm_ext_local_storage_compare_and_set")
            .call(&(kind, key_data, old_value, new_value).encode())
            .decode_u32()
    }
    pub fn rtm_ext_get_storage_into(&mut self, key_data: &[u8], value_data: &[u8], value_offset: u32) -> Vec<u8> {
        self
            .prep_wasm("rtm_ext_get_storage_into")
            .call(&(key_data, value_data, value_offset).encode())
            .decode_vec()
    }
    pub fn rtm_ext_storage_changes_root(&mut self, parent_hash_data: &[u8]) -> Vec<u8> {
        self
            .prep_wasm("rtm_ext_storage_changes_root")
            .call(&parent_hash_data.encode())
            .decode_vec()
    }
}
