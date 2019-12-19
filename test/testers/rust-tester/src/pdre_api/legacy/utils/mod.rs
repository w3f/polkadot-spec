mod child_storage;
mod crypto;
mod network;
mod storage;
mod misc;

pub use network::NetworkApi;
pub use misc::MiscApi;

use parity_scale_codec::Decode;
use substrate_executor::{call_in_wasm, WasmExecutionMethod};
use substrate_offchain::testing::TestOffchainExt;
use substrate_primitives::{Blake2Hasher, {testing::KeyStore}, {traits::KeystoreExt}, {offchain::OffchainExt}};
use substrate_state_machine::TestExternalities as CoreTestExternalities;

type TestExternalities<H> = CoreTestExternalities<H, u64>;

pub struct Runtime {
    blob: Vec<u8>,
    ext: TestExternalities<Blake2Hasher>,
}

impl Runtime {
    pub fn new() -> Self {
        Runtime {
            blob: get_wasm_blob(),
            ext: TestExternalities::default(),
        }
    }
    pub fn new_keystore() -> Self {
        let mut ext = TestExternalities::default();
        let key_store = KeystoreExt(KeyStore::new());
        ext.register_extension(key_store);
        Runtime {
            blob: get_wasm_blob(),
            ext: ext,
        }
    }
    pub fn new_offchain() -> Self {
        let mut ext = TestExternalities::default();
        let (offchain, _) = TestOffchainExt::new();
        ext.register_extension(OffchainExt::new(offchain));

        Runtime {
            blob: get_wasm_blob(),
            ext: ext,
        }
    }
    pub fn call(&mut self, method: &str, data: &[u8]) -> Vec<u8> {
		let mut extext = self.ext.ext();
        call_in_wasm(method, data, WasmExecutionMethod::Interpreted, &mut extext, &self.blob, 8).unwrap()
    }
}

// Convenience function, get the wasm blob
fn get_wasm_blob() -> Vec<u8> {
    use std::fs::File;
    use std::io::prelude::*;
    
    let mut f =
    // for `run_tests.sh` in root directory
    //File::open("build/test/testers/rust-tester/x86_64-unknown-linux-gnu/debug/wbuild/legacy-pdre-tester-wasm-blob/pdre_tester_wasm_blob.compact.wasm")
    // for `cargo` inside rust-tester directory
    File::open("target/debug/wbuild/legacy-pdre-tester-wasm-blob/legacy_pdre_tester_wasm_blob.compact.wasm")
        .expect("Failed to open wasm blob in target");
    let mut buffer = Vec::new(); f.read_to_end(&mut buffer)
        .expect("Failed to load wasm blob into memory");
    buffer
}

pub trait Decoder {
    fn decode_vec(&self) -> Vec<u8>;
    fn decode_u32(&self) -> u32;
    fn decode_u64(&self) -> u64;
}

impl Decoder for Vec<u8> {
    fn decode_vec(&self) -> Vec<u8> {
        Vec::<u8>::decode(&mut self.as_slice())
            .expect("Failed to decode SCALE encoding")
    }
    fn decode_u32(&self) -> u32 {
        u32::decode(&mut self.as_slice())
            .expect("Failed to decode SCALE encoding")
    }
    fn decode_u64(&self) -> u64 {
        u64::decode(&mut self.as_slice())
            .expect("Failed to decode SCALE encoding")
    }
}

struct CallWasm<'a> {
    ext: &'a mut TestExternalities<Blake2Hasher>,
    blob: &'a [u8],
    method: &'a str,
    //create_param: Box<FnOnce(&mut dyn FnMut(&[u8]) -> Result<u32, Error>) -> Result<Vec<RuntimeValue>, Error>>,
}

impl<'a> CallWasm<'a> {
    fn new(ext: &'a mut TestExternalities<Blake2Hasher>, blob: &'a [u8], method: &'a str) -> Self {
        CallWasm {
            ext: ext,
            blob: blob,
            method: method,
        }
    }
    /// Calls the final Wasm Runtime function (this method does not get used directly)
    fn call(&mut self, scaled_data: &[u8]) -> Vec<u8>
    {
		let mut extext = self.ext.ext();

        call_in_wasm(self.method, scaled_data, WasmExecutionMethod::Interpreted, &mut extext, self.blob, 8).unwrap()
    }
}
