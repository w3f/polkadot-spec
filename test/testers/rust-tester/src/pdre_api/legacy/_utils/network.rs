//! Contains wrappers for the calls to the Wasm blob (Runtime) APIs related to networking functionality.
//! Those wrappers are specific to the Parity Substrate `WasmExecutor` implementation.
//!
//! Not relevant for other implementators. Look at the `tests/` directory for the acutal tests.

use super::{CallWasm, get_wasm_blob, Decoder};

use parity_scale_codec::Encode;

use parking_lot::RwLock;
use sp_offchain::testing::{PendingRequest, State, TestOffchainExt};
use sp_core::{Blake2Hasher, {offchain::OffchainExt}};
use sp_state_machine::TestExternalities as CoreTestExternalities;

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
		ext.register_extension(OffchainExt::new(offchain));

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
        self
            .prep_wasm("rtm_ext_http_request_start")
            .call(&[method, url, meta].encode())
            .decode_u32()
    }
    pub fn rtm_ext_network_state(&mut self) -> Vec<u8> {
        self
            .prep_wasm("rtm_ext_network_state")
            .call(&[])
            .decode_vec()
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
