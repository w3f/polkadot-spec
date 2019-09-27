//! Contains wrappers for the calls to the Wasm blob (Runtime) APIs related to networking functionality.
//! Those wrappers are specific to the Parity Substrate `WasmExecutor` implementation.
//!
//! Not relevant for other implementators. Look at the `tests/` directory for the acutal tests.

use super::get_wasm_blob;

use parking_lot::RwLock;
use substrate_executor::error::Error;
use substrate_executor::WasmExecutor;
use substrate_offchain::testing::{PendingRequest, State, TestOffchainExt};
use substrate_primitives::Blake2Hasher;
use substrate_state_machine::TestExternalities as CoreTestExternalities;
use wasmi::RuntimeValue::{I32, I64};

use std::cell::RefCell;
use std::rc::Rc;
use std::sync::Arc;

type TestExternalities<H> = CoreTestExternalities<H, u64>;

pub struct NetworkApi {
    blob: Vec<u8>,
    ext: TestExternalities<Blake2Hasher>,
    state: Option<Arc<RwLock<State>>>,
}

impl NetworkApi {
    pub fn new_with_offchain_context() -> Self {
        let mut ext = TestExternalities::default();
        let (offchain, state) = TestOffchainExt::new();
        ext.set_offchain_externalities(offchain);

        NetworkApi {
            blob: get_wasm_blob(),
            ext: ext,
            state: Some(state),
        }
    }
    #[allow(unused)]
    /// Set the expected HTTP request for testing HTTP functionality
    pub fn dbg_http_expect_request(&mut self, id: u16, expected: PendingRequest) {
        let mut inner = self.state.as_ref().unwrap().write();
        inner.expect_request(id, expected);
    }
    pub fn rtm_ext_http_request_start(&mut self, method: &[u8], url: &[u8], meta: &[u8]) -> u32 {
        WasmExecutor::new()
            .call_with_custom_signature(
                &mut self.ext,
                1,
                &self.blob,
                "test_ext_http_request_start",
                |alloc| {
                    let method_offset = alloc(method)?;
                    let url_offset = alloc(url)?;
                    let meta_offset = alloc(meta)?;
                    Ok(vec![
                        I32(method_offset as i32),
                        I32(method.len() as i32),
                        I32(url_offset as i32),
                        I32(url.len() as i32),
                        I32(meta_offset as i32),
                        I32(meta.len() as i32),
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
    pub fn rtm_ext_network_state(&mut self, written_out: &mut u32) -> Vec<u8> {
        let ptr_holder: Rc<RefCell<u32>> = Rc::new(RefCell::new(0));
        WasmExecutor::new()
            .call_with_custom_signature(
                &mut self.ext,
                1,
                &self.blob,
                "test_ext_network_state",
                |alloc| {
                    let written_out_offset = alloc(&[0, 4])?;
                    *ptr_holder.borrow_mut() = written_out_offset as u32;
                    Ok(vec![I32(written_out_offset as i32)])
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
    pub fn rtm_ext_http_request_add_header(
        &mut self,
        request_id: u32,
        name: &[u8],
        value: &[u8],
    ) -> u32 {
        WasmExecutor::new()
            .call_with_custom_signature(
                &mut self.ext,
                1,
                &self.blob,
                "test_ext_http_request_add_header",
                |alloc| {
                    let name_offset = alloc(name)?;
                    let value_offset = alloc(value)?;
                    Ok(vec![
                        I32(request_id as i32),
                        I32(name_offset as i32),
                        I32(name.len() as i32),
                        I32(value_offset as i32),
                        I32(value.len() as i32),
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
    pub fn rtm_ext_http_response_wait(&mut self, ids: &[u32], statuses: &mut [u8], deadline: u64) {
        let ptr_holder: Rc<RefCell<u32>> = Rc::new(RefCell::new(0));
        let ids_len = ids.len() * 4; // 4-bytes per id
        WasmExecutor::new()
            .call_with_custom_signature(
                &mut self.ext,
                1,
                &self.blob,
                "test_ext_http_response_wait",
                |alloc| {
                    // Prepare IDs
                    let mut b_ids = vec![];
                    for id in ids {
                        b_ids.extend_from_slice(&id.to_le_bytes());
                    }
                    let ids_offset = alloc(b_ids.as_slice())?;

                    let statuses_offset = alloc(vec![0; ids_len].as_slice())?;
                    *ptr_holder.borrow_mut() = statuses_offset as u32;
                    Ok(vec![
                        I32(ids_offset as i32),
                        I32(b_ids.len() as i32),
                        I32(statuses_offset as i32),
                        I64(deadline.to_le() as i64),
                    ])
                },
                |_, memory| {
                    statuses.copy_from_slice(
                        memory
                            .get(*ptr_holder.borrow(), ids_len)
                            .map_err(|_| Error::Runtime)?
                            .as_slice(),
                    );
                    Ok(Some(()))
                },
            )
            .unwrap()
    }
}
