//! Contains wrappers for the calls to the Wasm blob (Runtime) APIs related to storage functionality.
//! Those wrappers are specific to the Parity Substrate `WasmExecutor` implementation.
//!
//! Not relevant for other implementators. Look at the `tests/` directory for the acutal tests.

use super::{copy_u32, copy_slice, de_scale_u32, get_wasm_blob, le, wrap, CallWasm};

use parity_scale_codec::{Encode, Decode};

use substrate_offchain::testing::TestOffchainExt;
use substrate_primitives::{Blake2Hasher, {offchain::OffchainExt}};
use substrate_state_machine::TestExternalities as CoreTestExternalities;

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
        let mut wasm = self.prep_wasm("test_ext_malloc");
        let mut size_scoped = size;

        let res = wasm.call(u32::encode(&size).as_slice());
        res
    }
    pub fn rtm_ext_free(&mut self, data: &[u8]) {
        let mut wasm = self.prep_wasm("test_ext_free");
        let _ = wasm.call(data.encode().as_slice());
    }
    pub fn rtm_ext_set_storage(&mut self, key_data: &[u8], value_data: &[u8]) {
        let mut wasm = self.prep_wasm("test_ext_set_storage");
        let _ = wasm.call(&[key_data, value_data].encode());
    }
    pub fn rtm_ext_get_allocated_storage(
        &mut self,
        key_data: &[u8],
        written_out: &mut u32,
    ) -> Vec<u8> {
        let mut wasm = self.prep_wasm("test_ext_get_allocated_storage");
        let ptr = wrap(0);
        let written_out_scoped = wrap(0);

        let res = wasm.call(&[key_data, &le(written_out)].encode());

        copy_u32(written_out_scoped, written_out);
        res
    }
    pub fn rtm_ext_clear_storage(&mut self, key_data: &[u8]) {
        let mut wasm = self.prep_wasm("test_ext_clear_storage");
        let _ = wasm.call(&[key_data].encode());
    }
    pub fn rtm_ext_exists_storage(&mut self, key_data: &[u8]) -> u32 {
        let mut wasm = self.prep_wasm("test_ext_exists_storage");
        de_scale_u32(wasm.call(&key_data))
    }
    pub fn rtm_ext_clear_prefix(&mut self, prefix_data: &[u8]) {
        let mut wasm = self.prep_wasm("test_ext_clear_prefix");
        let _ = wasm.call(&[prefix_data].encode());
    }
    pub fn rtm_ext_storage_root(&mut self, output: &mut [u8]) {
        let mut wasm = self.prep_wasm("test_ext_storage_root");
        let ptr = wrap(0);
        let output_scoped = wrap(vec![0; output.len()]);

        let _ = wasm.call(output.encode().as_slice());

        copy_slice(output_scoped, output);
    }
    pub fn rtm_ext_local_storage_set(&mut self, kind: u32, key_data: &[u8], value_data: &[u8]) {
        let mut wasm = self.prep_wasm("test_ext_local_storage_set");
        let mut kind_scoped = kind;

        let _ = wasm.call(&[&le(&mut kind_scoped), key_data, value_data].encode());
    }
}
