//! Contains wrappers for the calls to the Wasm blob (Runtime) APIs related to child storage functionality.
//! Those wrappers are specific to the Parity Substrate `WasmExecutor` implementation.
//!
//! Not relevant for other implementators. Look at the `tests/` directory for the acutal tests.

use super::{copy_u32, get_wasm_blob, le, wrap, CallWasm};

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
        let ptr = wrap(0);
        let written_out_scoped = wrap(0);

        let res = wasm.call(
            CallWasm::gen_params(&[storage_key_data, key_data, &le(written_out)], &[0, 1], Some(ptr.clone())),
            CallWasm::return_buffer(written_out_scoped.clone(), ptr),
        );

        copy_u32(written_out_scoped, written_out);
        res.unwrap()
    }
    pub fn rtm_ext_set_child_storage(
        &mut self,
        storage_key_data: &[u8],
        key_data: &[u8],
        value_data: &[u8],
    ) {
        let mut wasm = self.prep_wasm("test_ext_set_child_storage");
        let _ = wasm.call(
            CallWasm::gen_params(&[storage_key_data, key_data, value_data], &[0, 1, 2], None),
            CallWasm::return_none(),
        );
    }
    pub fn rtm_ext_clear_child_storage(&mut self, storage_key_data: &[u8], key_data: &[u8]) {
        let mut wasm = self.prep_wasm("test_ext_clear_child_storage");
        let _ = wasm.call(
            CallWasm::gen_params(&[storage_key_data, key_data], &[0, 1], None),
            CallWasm::return_none(),
        );
    }
    pub fn rtm_ext_exists_child_storage(
        &mut self,
        storage_key_data: &[u8],
        key_data: &[u8],
    ) -> u32 {
        let mut wasm = self.prep_wasm("test_ext_exists_child_storage");
        wasm.call(
            CallWasm::gen_params(&[storage_key_data, key_data], &[0, 1], None),
            CallWasm::return_value_no_buffer(),
        ).unwrap()
    }
    pub fn rtm_ext_clear_child_prefix(&mut self, storage_key_data: &[u8], prefix_data: &[u8]) {
        let mut wasm = self.prep_wasm("test_ext_clear_child_prefix");
        let _ = wasm.call(
            CallWasm::gen_params(&[storage_key_data, prefix_data], &[0, 1], None),
            CallWasm::return_none(),
        );
    }
    pub fn rtm_ext_kill_child_storage(&mut self, storage_key_data: &[u8]) {
        let mut wasm = self.prep_wasm("test_ext_kill_child_storage");
        let _ = wasm.call(
            CallWasm::gen_params(&[storage_key_data], &[0], None),
            CallWasm::return_none(),
        );
    }
}
