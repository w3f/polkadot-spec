//! Contains wrappers for the calls to the Wasm blob (Runtime) APIs related to crypto functionality.
//! Those wrappers are specific to the Parity Substrate `WasmExecutor` implementation.
//!
//! Not relevant for other implementators. Look at the `tests/` directory for the acutal tests.

use super::{copy_u32, de_scale_u32, copy_slice, get_wasm_blob, le, wrap, CallWasm};

use parity_scale_codec::{Encode, Decode};
use substrate_primitives::testing::KeyStore;
use substrate_primitives::{Blake2Hasher, traits::{KeystoreExt}};
use substrate_state_machine::TestExternalities as CoreTestExternalities;
//pub use substrate_externalities::{Externalities, ExternalitiesExt};


type TestExternalities<H> = CoreTestExternalities<H, u64>;

pub struct CryptoApi {
    blob: Vec<u8>,
    ext: TestExternalities<Blake2Hasher>,
}

impl CryptoApi {
    pub fn new() -> Self {
        let mut ext = TestExternalities::default();
        let mut key_store = KeystoreExt(KeyStore::new());
        ext.register_extension(key_store);
        CryptoApi {
            blob: get_wasm_blob(),
            ext: ext,
        }
    }
    fn prep_wasm<'a>(&'a mut self, method: &'a str) -> CallWasm<'a> {
        CallWasm::new(&mut self.ext, &self.blob, method)
    }
    fn common_hash_fn_handler(&mut self, method: &str, data: &[u8])->Vec<u8> {
        let mut wasm = self.prep_wasm(method);
        //the data need to be scaled
        let res = wasm.call(&data.encode());
        Vec::<u8>::decode(&mut res.as_slice()).unwrap()
    }
    pub fn rtm_ext_blake2_128(&mut self, data: &[u8]) -> Vec<u8> {
        self.common_hash_fn_handler("test_ext_blake2_128", data)
    }
    pub fn rtm_ext_blake2_256(&mut self, data: &[u8]) -> Vec<u8> {
        self.common_hash_fn_handler("test_ext_blake2_256", data)
    }
    pub fn rtm_ext_twox_64(&mut self, data: &[u8]) -> Vec<u8> {
        self.common_hash_fn_handler("test_ext_twox_64", data)
    }
    pub fn rtm_ext_twox_128(&mut self, data: &[u8]) -> Vec<u8> {
        self.common_hash_fn_handler("test_ext_twox_128", data)
    }
    pub fn rtm_ext_twox_256(&mut self, data: &[u8]) -> Vec<u8> {
        self.common_hash_fn_handler("test_ext_twox_256", data)
    }
    pub fn rtm_ext_keccak_256(&mut self, data: &[u8]) -> Vec<u8> {
        self.common_hash_fn_handler("test_ext_keccak_256", data)
    }
    pub fn rtm_ext_ed25519_generate(&mut self, id_data: &[u8], seed: &[u8]) -> Vec<u8> {
        let mut wasm = self.prep_wasm("test_ext_ed25519_generate");
        let res = wasm.call(&(id_data, seed).encode());
        Vec::<u8>::decode(&mut res.as_slice()).unwrap()
    }
    pub fn rtm_ext_ed25519_sign(
        &mut self,
        id_data: &[u8],
        pubkey_data: &[u8],
        msg_data: &[u8],
    ) -> Vec<u8> {
        let mut wasm = self.prep_wasm("test_ext_ed25519_sign");
        let res = wasm.call(&(id_data, pubkey_data, msg_data).encode());
        Vec::<u8>::decode(&mut res.as_slice()).unwrap()
    }
    pub fn rtm_ext_ed25519_verify(
        &mut self,
        msg_data: &[u8],
        sig_data: &[u8],
        pubkey_data: &[u8],
    ) -> u32 {
        let mut wasm = self.prep_wasm("test_ext_ed25519_verify");
        de_scale_u32(wasm.call(&(msg_data, sig_data, pubkey_data).encode()))
            
    }
    pub fn rtm_ext_ed25519_public_keys(&mut self, id_data: &[u8]) -> Vec<u8> {
        let mut wasm = self.prep_wasm("test_ext_ed25519_public_keys");
        let res = wasm.call(&id_data.encode());
        Vec::<u8>::decode(&mut res.as_slice()).unwrap()
    }
    pub fn rtm_ext_sr25519_generate(&mut self, id_data: &[u8], seed: &[u8]) -> Vec<u8> {
        let mut wasm = self.prep_wasm("test_ext_sr25519_generate");
        let res = wasm.call(&(id_data, seed).encode());
        Vec::<u8>::decode(&mut res.as_slice()).unwrap()
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

        let res = wasm.call(&[id_data, pubkey_data, msg_data, output].encode());

        copy_slice(output_scoped, output);
        u32::decode(&mut res.as_slice()).unwrap()
    }
    pub fn rtm_ext_sr25519_verify(
        &mut self,
        msg_data: &[u8],
        sig_data: &[u8],
        pubkey_data: &[u8],
    ) -> u32 {
        let mut wasm = self.prep_wasm("test_ext_sr25519_verify");
        de_scale_u32(wasm.call(&(msg_data, sig_data, pubkey_data).encode()))
    }
    pub fn rtm_ext_sr25519_public_keys(&mut self, id_data: &[u8]) -> Vec<u8> {
        let mut wasm = self.prep_wasm("test_ext_sr25519_public_keys");
        let res = wasm.call(&id_data.encode());
        Vec::<u8>::decode(&mut res.as_slice()).unwrap()
    }
}
