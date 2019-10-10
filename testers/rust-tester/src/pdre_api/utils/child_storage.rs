//! Contains wrappers for the calls to the Wasm blob (Runtime) APIs related to child storage functionality.
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
        WasmExecutor::new()
            .call_with_custom_signature(
                &mut self.ext,
                1,
                &self.blob,
                "test_ext_set_child_storage",
                |alloc| {
                    let storage_key_offset = alloc(storage_key_data)?;
                    let key_offset = alloc(key_data)?;
                    let value_offset = alloc(value_data)?;
                    Ok(vec![
                        I32(storage_key_offset as i32),
                        I32(storage_key_data.len() as i32),
                        I32(key_offset as i32),
                        I32(key_data.len() as i32),
                        I32(value_offset as i32),
                        I32(value_data.len() as i32),
                    ])
                },
                |_, _| Ok(Some(())),
            )
            .unwrap()
    }
    pub fn rtm_ext_clear_child_storage(&mut self, storage_key_data: &[u8], key_data: &[u8]) {
        WasmExecutor::new()
            .call_with_custom_signature(
                &mut self.ext,
                1,
                &self.blob,
                "test_ext_clear_child_storage",
                |alloc| {
                    let storage_key_offset = alloc(storage_key_data)?;
                    let key_offset = alloc(key_data)?;
                    Ok(vec![
                        I32(storage_key_offset as i32),
                        I32(storage_key_data.len() as i32),
                        I32(key_offset as i32),
                        I32(key_data.len() as i32),
                    ])
                },
                |_, _| Ok(Some(())),
            )
            .unwrap()
    }
    pub fn rtm_ext_exists_child_storage(
        &mut self,
        storage_key_data: &[u8],
        key_data: &[u8],
    ) -> u32 {
        WasmExecutor::new()
            .call_with_custom_signature(
                &mut self.ext,
                1,
                &self.blob,
                "test_ext_exists_child_storage",
                |alloc| {
                    let storage_key_offset = alloc(storage_key_data)?;
                    let key_offset = alloc(key_data)?;
                    Ok(vec![
                        I32(storage_key_offset as i32),
                        I32(storage_key_data.len() as i32),
                        I32(key_offset as i32),
                        I32(key_data.len() as i32),
                    ])
                },
                |res, _| {
                    if let Some(I32(r)) = res {
                        Ok(Some(r as u32))
                    } else {
                        Ok(None)
                    }
                },
            )
            .unwrap()
    }
    pub fn rtm_ext_clear_child_prefix(&mut self, storage_key_data: &[u8], prefix_data: &[u8]) {
        WasmExecutor::new()
            .call_with_custom_signature(
                &mut self.ext,
                1,
                &self.blob,
                "test_ext_clear_child_prefix",
                |alloc| {
                    let storage_key_offset = alloc(storage_key_data)?;
                    let prefix_offset = alloc(prefix_data)?;
                    Ok(vec![
                        I32(storage_key_offset as i32),
                        I32(storage_key_data.len() as i32),
                        I32(prefix_offset as i32),
                        I32(prefix_data.len() as i32),
                    ])
                },
                |_, _| Ok(Some(())),
            )
            .unwrap()
    }
    pub fn rtm_ext_kill_child_storage(&mut self, storage_key_data: &[u8]) {
        WasmExecutor::new()
            .call_with_custom_signature(
                &mut self.ext,
                1,
                &self.blob,
                "test_ext_kill_child_storage",
                |alloc| {
                    let storage_key_offset = alloc(storage_key_data)?;
                    Ok(vec![
                        I32(storage_key_offset as i32),
                        I32(storage_key_data.len() as i32),
                    ])
                },
                |_, _| Ok(Some(())),
            )
            .unwrap()
    }
}
