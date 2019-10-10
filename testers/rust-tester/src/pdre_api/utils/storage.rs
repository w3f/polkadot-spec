//! Contains wrappers for the calls to the Wasm blob (Runtime) APIs related to storage functionality.
//! Those wrappers are specific to the Parity Substrate `WasmExecutor` implementation.
//!
//! Not relevant for other implementators. Look at the `tests/` directory for the acutal tests.

use super::{copy_u32, copy_slice, get_wasm_blob, le, wrap, CallWasm};

use substrate_executor::error::Error;
use substrate_executor::WasmExecutor;
use substrate_offchain::testing::TestOffchainExt;
use substrate_primitives::Blake2Hasher;
use substrate_state_machine::TestExternalities as CoreTestExternalities;
use wasmi::RuntimeValue::I32;

use std::cell::RefCell;
use std::rc::Rc;

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
        ext.set_offchain_externalities(offchain);

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

        let res = wasm.call(
            CallWasm::gen_params(&[&le(&mut size_scoped)], &[], None),
            CallWasm::return_buffer_no_ptr(size),
        );

        res.unwrap()
    }
    pub fn rtm_ext_free(&mut self, data: &[u8]) {
        let mut wasm = self.prep_wasm("test_ext_free");

        let _ = wasm.call(
            CallWasm::gen_params(&[data], &[], None),
            CallWasm::return_none(),
        );
    }
    pub fn rtm_ext_set_storage(&mut self, key_data: &[u8], value_data: &[u8]) {
        let mut wasm = self.prep_wasm("test_ext_set_storage");

        let _ = wasm.call(
            CallWasm::gen_params(&[key_data, value_data], &[0, 1], None),
            CallWasm::return_none(),
        );
    }
    pub fn rtm_ext_get_allocated_storage(
        &mut self,
        key_data: &[u8],
        written_out: &mut u32,
    ) -> Vec<u8> {
        let mut wasm = self.prep_wasm("test_ext_get_allocated_storage");
        let ptr = wrap(0);
        let written_out_scoped = wrap(0);

        let res = wasm.call(
            CallWasm::gen_params(&[key_data, &le(written_out)], &[0], Some(ptr.clone())),
            CallWasm::return_buffer(written_out_scoped.clone(), ptr)
        );

        copy_u32(written_out_scoped, written_out);
        res.unwrap()
    }
    pub fn rtm_ext_clear_storage(&mut self, key_data: &[u8]) {
        let mut wasm = self.prep_wasm("test_ext_clear_storage");

        let _ = wasm.call(
            CallWasm::gen_params(&[key_data], &[0], None),
            CallWasm::return_none()
        );
    }
    pub fn rtm_ext_exists_storage(&mut self, key_data: &[u8]) -> u32 {
        let mut wasm = self.prep_wasm("test_ext_exists_storage");

        wasm.call(
            CallWasm::gen_params(&[key_data], &[0], None),
            CallWasm::return_value_no_buffer()
        ).unwrap()
    }
    pub fn rtm_ext_clear_prefix(&mut self, prefix_data: &[u8]) {
        let mut wasm = self.prep_wasm("test_ext_clear_prefix");

        let _ = wasm.call(
            CallWasm::gen_params(&[prefix_data], &[0], None),
            CallWasm::return_none()
        );
    }
    pub fn rtm_ext_storage_root(&mut self, output: &mut [u8]) {
        let mut wasm = self.prep_wasm("test_ext_storage_root");
        let ptr = wrap(0);
        let output_scoped = wrap(vec![0; output.len()]);

        let _ = wasm.call(
            CallWasm::gen_params(&[output], &[], Some(ptr.clone())),
            CallWasm::return_none_write_buffer(output_scoped.clone(), ptr)
        );

        copy_slice(output_scoped, output);
    }
    pub fn rtm_ext_local_storage_set(&mut self, kind: u32, key_data: &[u8], value_data: &[u8]) {
        let mut wasm = self.prep_wasm("test_ext_local_storage_set");
        let mut kind_scoped = kind;

        let _ = wasm.call(
            CallWasm::gen_params(&[&le(&mut kind_scoped), key_data, value_data], &[1, 2], None),
            CallWasm::return_none()
        );
    }
}
