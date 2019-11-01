//! Contains wrappers for the calls to the Wasm blob (Runtime) APIs related to networking functionality.
//! Those wrappers are specific to the Parity Substrate `WasmExecutor` implementation.
//!
//! Not relevant for other implementators. Look at the `tests/` directory for the acutal tests.

use super::{copy_u32, get_wasm_blob, le, wrap, CallWasm};

use parking_lot::RwLock;
use substrate_offchain::testing::{PendingRequest, State, TestOffchainExt};
use substrate_primitives::Blake2Hasher;
use substrate_state_machine::TestExternalities as CoreTestExternalities;

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
    #[allow(unused)] // TODO
    /// Set the expected HTTP request for testing HTTP functionality
    pub fn dbg_http_expect_request(&mut self, id: u16, expected: PendingRequest) {
        let mut inner = self.state.as_ref().unwrap().write();
        inner.expect_request(id, expected);
    }
    fn prep_wasm<'a>(&'a mut self, method: &'a str) -> CallWasm<'a> {
        CallWasm::new(&mut self.ext, &self.blob, method)
    }
    pub fn rtm_ext_http_request_start(&mut self, method: &[u8], url: &[u8], meta: &[u8]) -> u32 {
        let mut wasm = self.prep_wasm("test_ext_http_request_start");
        wasm.call(
            CallWasm::gen_params(&[method, url, meta], &[0, 1, 2], None),
            CallWasm::return_value_no_buffer(),
        ).unwrap()
    }
    pub fn rtm_ext_network_state(&mut self, written_out: &mut u32) -> Vec<u8> {
        let mut wasm = self.prep_wasm("test_ext_network_state");
        let ptr = wrap(0);
        let written_out_scoped = wrap(0);

        let res = wasm.call(
            CallWasm::gen_params(&[&le(written_out)], &[], Some(ptr.clone())),
            CallWasm::return_buffer(written_out_scoped.clone(), ptr)
        );

        copy_u32(written_out_scoped, written_out);
        res.unwrap()
    }
    #[allow(unused)] // temporarly
    pub fn rtm_ext_http_request_add_header(
        &mut self,
        request_id: u32,
        name: &[u8],
        value: &[u8],
    ) -> u32 {
        let _ = request_id;
        let _ = name;
        let _ = value;
        0

        // TODO...
    }
    #[allow(unused)] // temporarly
    pub fn rtm_ext_http_response_wait(&mut self, ids: &[u32], statuses: &mut [u8], deadline: u64) {
        let _ = ids;
        let _ = statuses;
        let _ = deadline;

        // TODO...
    }
}
