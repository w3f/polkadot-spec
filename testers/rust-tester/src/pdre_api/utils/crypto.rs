//! Contains wrappers for the calls to the Wasm blob (Runtime) APIs related to crypto functionality.
//! Those wrappers are specific to the Parity Substrate `WasmExecutor` implementation.
//!
//! Not relevant for other implementators. Look at the `tests/` directory for the acutal tests.

use super::{CallWasm, get_wasm_blob, Decoder};

use parity_scale_codec::Encode;
use sp_core::testing::KeyStore;
use sp_core::{Blake2Hasher, traits::{KeystoreExt}};
use sp_state_machine::TestExternalities as CoreTestExternalities;

type TestExternalities<H> = CoreTestExternalities<H, u64>;

pub struct CryptoApi {
    blob: Vec<u8>,
    ext: TestExternalities<Blake2Hasher>,
}

impl CryptoApi {
    pub fn new() -> Self {
        let mut ext = TestExternalities::default();
        let key_store = KeystoreExt(KeyStore::new());
        ext.register_extension(key_store);
        CryptoApi {
            blob: get_wasm_blob(),
            ext: ext,
        }
    }
    fn prep_wasm<'a>(&'a mut self, method: &'a str) -> CallWasm<'a> {
        CallWasm::new(&mut self.ext, &self.blob, method)
    }
    fn common_hash_fn_handler(&mut self, method: &str, data: &[u8]) -> Vec<u8> {
        self
            .prep_wasm(method)
            .call(&data.encode())
            .decode_vec()
    }
    pub fn rtm_ext_blake2_128(&mut self, data: &[u8]) -> Vec<u8> {
        self.common_hash_fn_handler("rtm_ext_blake2_128", data)
    }
    pub fn rtm_ext_blake2_256(&mut self, data: &[u8]) -> Vec<u8> {
        self.common_hash_fn_handler("rtm_ext_blake2_256", data)
    }
    pub fn rtm_ext_twox_64(&mut self, data: &[u8]) -> Vec<u8> {
        self.common_hash_fn_handler("rtm_ext_twox_64", data)
    }
    pub fn rtm_ext_twox_128(&mut self, data: &[u8]) -> Vec<u8> {
        self.common_hash_fn_handler("rtm_ext_twox_128", data)
    }
    pub fn rtm_ext_twox_256(&mut self, data: &[u8]) -> Vec<u8> {
        self.common_hash_fn_handler("rtm_ext_twox_256", data)
    }
    pub fn rtm_ext_keccak_256(&mut self, data: &[u8]) -> Vec<u8> {
        self.common_hash_fn_handler("rtm_ext_keccak_256", data)
    }
    pub fn rtm_ext_ed25519_generate(&mut self, id_data: &[u8], seed: &[u8]) -> Vec<u8> {
        self
            .prep_wasm("rtm_ext_ed25519_generate")
            .call(&(id_data, seed).encode())
            .decode_vec()
    }
    pub fn rtm_ext_ed25519_sign(
        &mut self,
        id_data: &[u8],
        pubkey_data: &[u8],
        msg_data: &[u8],
    ) -> Vec<u8> {
        self
            .prep_wasm("rtm_ext_ed25519_sign")
            .call(&(id_data, pubkey_data, msg_data).encode())
            .decode_vec()
    }
    pub fn rtm_ext_ed25519_verify(
        &mut self,
        msg_data: &[u8],
        sig_data: &[u8],
        pubkey_data: &[u8],
    ) -> u32 {
        self
            .prep_wasm("rtm_ext_ed25519_verify")
            .call(&(msg_data, sig_data, pubkey_data).encode())
            .decode_u32()
            
    }
    pub fn rtm_ext_ed25519_public_keys(&mut self, id_data: &[u8]) -> Vec<u8> {
        self
            .prep_wasm("rtm_ext_ed25519_public_keys")
            .call(&id_data.encode())
            .decode_vec()
    }
    pub fn rtm_ext_sr25519_generate(&mut self, id_data: &[u8], seed: &[u8]) -> Vec<u8> {
        self
            .prep_wasm("rtm_ext_sr25519_generate")
            .call(&(id_data, seed).encode())
            .decode_vec()
    }
    pub fn rtm_ext_sr25519_sign(
        &mut self,
        id_data: &[u8],
        pubkey_data: &[u8],
        msg_data: &[u8],
    ) -> Vec<u8> {
        self
            .prep_wasm("rtm_ext_sr25519_sign")
            .call(&(id_data, pubkey_data, msg_data).encode())
            .decode_vec()
    }
    pub fn rtm_ext_sr25519_verify(
        &mut self,
        msg_data: &[u8],
        sig_data: &[u8],
        pubkey_data: &[u8],
    ) -> u32 {
        self
            .prep_wasm("rtm_ext_sr25519_verify")
            .call(&(msg_data, sig_data, pubkey_data).encode())
            .decode_u32()
    }
    pub fn rtm_ext_sr25519_public_keys(&mut self, id_data: &[u8]) -> Vec<u8> {
        self
            .prep_wasm("rtm_ext_sr25519_public_keys")
            .call(&id_data.encode())
            .decode_vec()
    }
    pub fn rtm_ext_blake2_256_enumerated_trie_root(
        &mut self,
        values_data: &[u8],
        lens_data: &[u32],
    ) -> Vec<u8> {
        self
            .prep_wasm("rtm_ext_blake2_256_enumerated_trie_root")
            .call(&(values_data, lens_data).encode())
            .decode_vec()
    }
    pub fn rtm_ext_secp256k1_ecdsa_recover(
        &mut self,
        msg_data: &[u8],
        sig_data: &[u8],
    ) -> Vec<u8> {
        self
            .prep_wasm("rtm_ext_secp256k1_ecdsa_recover")
            .call(&(msg_data, sig_data).encode())
            .decode_vec()
    }
}