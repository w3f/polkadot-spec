//! Contains wrappers for the calls to the Wasm blob (Runtime) APIs related to child storage functionality.
//! Those wrappers are specific to the Parity Substrate `WasmExecutor` implementation.
//!
//! Not relevant for other implementators. Look at the `tests/` directory for the acutal tests.

use super::get_wasm_blob;

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
    pub fn rtm_ext_get_allocated_child_storage(
        &mut self,
        storage_key_data: &[u8],
        key_data: &[u8],
        written_out: &mut u32,
    ) -> Vec<u8> {
        let ptr_holder: Rc<RefCell<u32>> = Rc::new(RefCell::new(0));
        WasmExecutor::new()
            .call_with_custom_signature(
                &mut self.ext,
                1,
                &self.blob,
                "test_ext_get_allocated_child_storage",
                |alloc| {
                    let storage_key_offset = alloc(storage_key_data)?;
                    let key_offset = alloc(key_data)?;
                    let written_out_offset = alloc(&[0; 4])?;
                    *ptr_holder.borrow_mut() = written_out_offset as u32;
                    Ok(vec![
                        I32(storage_key_offset as i32),
                        I32(storage_key_data.len() as i32),
                        I32(key_offset as i32),
                        I32(key_data.len() as i32),
                        I32(written_out_offset as i32),
                    ])
                },
                |res, memory| {
                    use std::convert::TryInto;
                    if let Some(I32(r)) = res {
                        *written_out = u32::from_le_bytes(
                            memory
                                .get(*ptr_holder.borrow(), 4)
                                .unwrap()
                                .as_slice()
                                .split_at(4)
                                .0
                                .try_into()
                                .unwrap(),
                        );

                        if r == 0 {
                            return Ok(Some(vec![]));
                        }

                        memory
                            .get(r as u32, *written_out as usize)
                            .map_err(|_| Error::Runtime)
                            .map(Some)
                    } else {
                        Ok(None)
                    }
                },
            )
            .unwrap()
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