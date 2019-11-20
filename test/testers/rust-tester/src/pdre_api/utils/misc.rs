//! Contains wrappers for the calls to the Wasm blob (Runtime) APIs related to miscellaneous functionality.
//! Those wrappers are specific to the Parity Substrate `WasmExecutor` implementation.
//!
//! Not relevant for other implementators. Look at the `tests/` directory for the acutal tests.

use super::{CallWasm, get_wasm_blob, Decoder};

use parity_scale_codec::Encode;
use substrate_primitives::Blake2Hasher;
use substrate_state_machine::TestExternalities as CoreTestExternalities;

type TestExternalities<H> = CoreTestExternalities<H, u64>;

pub struct MiscApi {
    blob: Vec<u8>,
    ext: TestExternalities<Blake2Hasher>,
}

impl MiscApi {
    pub fn new() -> Self {
        MiscApi {
            blob: get_wasm_blob(),
            ext: TestExternalities::default(),
        }
    }
    fn prep_wasm<'a>(&'a mut self, method: &'a str) -> CallWasm<'a> {
        CallWasm::new(&mut self.ext, &self.blob, method)
    }
    pub fn rtm_ext_chain_id(&mut self) -> u64 {
        self
            .prep_wasm("rtm_ext_chain_id")
            .call(&[])
            .decode_u64()
    }
    pub fn rtm_ext_is_validator(&mut self) -> u32 {
        self
            .prep_wasm("rtm_ext_is_validator")
            .call(&[])
            .decode_u32()
    }
    pub fn rtm_ext_submit_transaction(&mut self, msg_data: &[u8]) -> u32 {
        self
            .prep_wasm("rtm_ext_submit_transaction")
            .call(&msg_data.encode())
            .decode_u32()
    }
    pub fn rtm_ext_timestamp(&mut self) -> u64 {
        self
            .prep_wasm("rtm_ext_timestamp")
            .call(&[])
            .decode_u64()
    }
    pub fn rtm_ext_sleep_until(&mut self, deadline: u64) {
        self
            .prep_wasm("rtm_ext_sleep_until")
            .call(&deadline.encode());
    }
    pub fn rtm_ext_random_seed(&mut self, seed_data: &[u8]) -> Vec<u8> {
        self
            .prep_wasm("rtm_ext_random_seed")
            .call(&seed_data.encode())
            .decode_vec()
    }
}