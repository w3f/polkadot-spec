//! Contains wrappers for the calls to the Wasm blob (Runtime) APIs related to crypto functionality.
//! Those wrappers are specific to the Parity Substrate `WasmExecutor` implementation.
//!
//! Not relevant for other implementators. Look at the `tests/` directory for the acutal tests.

use super::{copy_u32, copy_slice, get_wasm_blob, le, wrap, CallWasm};

use substrate_executor::error::Error;
use substrate_executor::WasmExecutor;
use substrate_primitives::testing::KeyStore;
use substrate_primitives::Blake2Hasher;
use substrate_state_machine::TestExternalities as CoreTestExternalities;
use wasmi::RuntimeValue::I32;

use std::cell::RefCell;
use std::rc::Rc;

type TestExternalities<H> = CoreTestExternalities<H, u64>;

pub struct CryptoApi {
    blob: Vec<u8>,
    ext: TestExternalities<Blake2Hasher>,
}

impl CryptoApi {
    pub fn new() -> Self {
        let mut ext = TestExternalities::default();
        ext.set_keystore(KeyStore::new());
        CryptoApi {
            blob: get_wasm_blob(),
            ext: ext,
        }
    }
    fn prep_wasm<'a>(&'a mut self, method: &'a str) -> CallWasm<'a> {
        CallWasm::new(&mut self.ext, &self.blob, method)
    }
    fn common_hash_fn_handler(&mut self, method: &str, data: &[u8], output: &mut [u8]) {
        let mut wasm = self.prep_wasm(method);

        let ptr = wrap(0);
        let output_scoped = wrap(vec![0; output.len()]);

        let res = wasm.call(
            CallWasm::gen_params(&[data, output], &[0], Some(ptr.clone())),
            CallWasm::return_none_write_buffer(output_scoped.clone(), ptr),
        );

        copy_slice(output_scoped, output);
        res.unwrap()
    }
    pub fn rtm_ext_blake2_128(&mut self, data: &[u8], output: &mut [u8]) {
        self.common_hash_fn_handler("test_ext_blake2_128", data, output)
    }
    pub fn rtm_ext_blake2_256(&mut self, data: &[u8], output: &mut [u8]) {
        self.common_hash_fn_handler("test_ext_blake2_256", data, output)
    }
    pub fn rtm_ext_twox_64(&mut self, data: &[u8], output: &mut [u8]) {
        self.common_hash_fn_handler("test_ext_twox_64", data, output)
    }
    pub fn rtm_ext_twox_128(&mut self, data: &[u8], output: &mut [u8]) {
        self.common_hash_fn_handler("test_ext_twox_128", data, output)
    }
    pub fn rtm_ext_twox_256(&mut self, data: &[u8], output: &mut [u8]) {
        self.common_hash_fn_handler("test_ext_twox_256", data, output)
    }
    pub fn rtm_ext_keccak_256(&mut self, data: &[u8], output: &mut [u8]) {
        self.common_hash_fn_handler("test_ext_keccak_256", data, output)
    }
    pub fn rtm_ext_ed25519_generate(&mut self, id_data: &[u8], seed: &[u8], output: &mut [u8]) {
        let mut wasm = self.prep_wasm("test_ext_ed25519_generate");

        let ptr = wrap(0);
        let output_scoped = wrap(vec![0; output.len()]);

        let _ = wasm.call(
            CallWasm::gen_params(&[id_data, seed, output], &[1], Some(ptr.clone())),
            CallWasm::return_none_write_buffer(output_scoped.clone(), ptr),
        );

        copy_slice(output_scoped, output);
    }
    pub fn rtm_ext_ed25519_sign(
        &mut self,
        id_data: &[u8],
        pubkey_data: &[u8],
        msg_data: &[u8],
        output: &mut [u8],
    ) -> u32 {
        let mut wasm = self.prep_wasm("test_ext_ed25519_sign");

        let ptr = wrap(0);
        let output_scoped = wrap(vec![0; output.len()]);

        let res = wasm.call(
            CallWasm::gen_params(
                &[id_data, pubkey_data, msg_data, output],
                &[2],
                Some(ptr.clone()),
            ),
            CallWasm::return_value_write_buffer(output_scoped.clone(), ptr),
        );

        copy_slice(output_scoped, output);
        res.unwrap()
    }
    pub fn rtm_ext_ed25519_verify(
        &mut self,
        msg_data: &[u8],
        sig_data: &[u8],
        pubkey_data: &[u8],
    ) -> u32 {
        let mut wasm = self.prep_wasm("test_ext_ed25519_verify");

        let res = wasm.call(
            CallWasm::gen_params(&[msg_data, sig_data, pubkey_data], &[0], None),
            CallWasm::return_value_no_buffer(),
        );

        res.unwrap()
    }
    pub fn rtm_ext_ed25519_public_keys(&mut self, id_data: &[u8], written_out: &mut u32) -> Vec<u8> {
        let mut wasm = self.prep_wasm("test_ext_ed25519_public_keys");

        let ptr = wrap(0);
        let written_out_scoped = wrap(0);

        let res = wasm.call(
            CallWasm::gen_params(
                &[id_data, &le(written_out)],
                &[],
                Some(ptr.clone()),
            ),
            CallWasm::return_buffer(written_out_scoped.clone(), ptr),
        );

        copy_u32(written_out_scoped, written_out);
        res.unwrap()
    }
    pub fn rtm_ext_sr25519_generate(&mut self, id_data: &[u8], seed: &[u8], output: &mut [u8]) {
        let mut wasm = self.prep_wasm("test_ext_sr25519_generate");

        let ptr = wrap(0);
        let output_scoped = wrap(vec![0; output.len()]);

        let res = wasm.call(
            CallWasm::gen_params(&[id_data, seed, output], &[1], Some(ptr.clone())),
            CallWasm::return_none_write_buffer(output_scoped.clone(), ptr),
        );

        copy_slice(output_scoped, output);
        res.unwrap()
    }
    pub fn rtm_ext_sr25519_sign(
        &mut self,
        id_data: &[u8],
        pubkey_data: &[u8],
        msg_data: &[u8],
        output: &mut [u8],
    ) -> u32 {
        let mut wasm = self.prep_wasm("test_ext_sr25519_sign");

        let ptr = wrap(0);
        let output_scoped = wrap(vec![0; output.len()]);

        let res = wasm.call(
            CallWasm::gen_params(
                &[id_data, pubkey_data, msg_data, output],
                &[2],
                Some(ptr.clone()),
            ),
            CallWasm::return_value_write_buffer(output_scoped.clone(), ptr),
        );

        copy_slice(output_scoped, output);
        res.unwrap()
    }
    pub fn rtm_ext_sr25519_verify(
        &mut self,
        msg_data: &[u8],
        sig_data: &[u8],
        pubkey_data: &[u8],
    ) -> u32 {
        let mut wasm = self.prep_wasm("test_ext_sr25519_verify");

        let res = wasm.call(
            CallWasm::gen_params(&[msg_data, sig_data, pubkey_data], &[0], None),
            CallWasm::return_value_no_buffer(),
        );

        res.unwrap()
    }
    pub fn rtm_ext_sr25519_public_keys(&mut self, id_data: &[u8], written_out: &mut u32) -> Vec<u8> {
        let mut wasm = self.prep_wasm("test_ext_sr25519_public_keys");

        let ptr = wrap(0);
        let written_out_scoped = wrap(0);

        let res = wasm.call(
            CallWasm::gen_params(
                &[id_data, &le(written_out)],
                &[],
                Some(ptr.clone()),
            ),
            CallWasm::return_buffer(written_out_scoped.clone(), ptr),
        );

        copy_u32(written_out_scoped, written_out);
        res.unwrap()
    }
}
