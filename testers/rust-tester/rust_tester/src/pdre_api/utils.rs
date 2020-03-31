use clap::Values;
use parity_scale_codec::Decode;
use sc_executor::{
    WasmExecutor,
    CallInWasm,
    WasmExecutionMethod,
    sp_wasm_interface::HostFunctions,
};
use sp_io::SubstrateHostFunctions;
use sp_core::offchain::testing::TestOffchainExt;
use sp_core::{offchain::OffchainExt, testing::KeyStore, traits::KeystoreExt, Blake2Hasher};
use sp_state_machine::TestExternalities as CoreTestExternalities;

type TestExternalities<H> = CoreTestExternalities<H, u64>;

pub fn str<'a>(input: &'a [u8]) -> &'a str {
    std::str::from_utf8(input).unwrap()
}

pub struct ParsedInput<'a>(Vec<&'a str>);

impl<'a> ParsedInput<'a> {
    pub fn get(&self, index: usize) -> &[u8] {
        if let Some(ret) = self.0.get(index) {
            ret.as_bytes()
        } else {
            panic!("failed to get index, wrong input data provided for the test function");
        }
    }
    pub fn get_u32(&self, index: usize) -> u32 {
        if let Some(ret) = self.0.get(index) {
            ret.parse().expect("failed to parse parameter as u32")
        } else {
            panic!("failed to get index, wrong input data provided for the test function");
        }
    }
}

impl<'a> From<Values<'a>> for ParsedInput<'a> {
    fn from(input: Values<'a>) -> Self {
        ParsedInput(input.collect())
    }
}

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
    #[allow(dead_code)]
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

        WasmExecutor::new(
            WasmExecutionMethod::Interpreted,
            Some(8), // heap_pages
            SubstrateHostFunctions::host_functions(),
            false, // allow_missing_func_import
            8 // max_runtime_instances
        ).call_in_wasm(
            &self.blob,
            None, // Optional<Hash>
            method,
            data,
             &mut extext,
        ).unwrap()
    }
}

// Convenience function, get the wasm blob
fn get_wasm_blob() -> Vec<u8> {
    use std::fs::File;
    use std::io::prelude::*;

    let mut f =
    // for `build_tests.sh` in root directory
    File::open("test/testers/rust-tester/target/debug/wbuild/wasm-blob/wasm_blob.compact.wasm")
    // for `cargo` inside rust-tester directory
    //File::open("target/debug/wbuild/wasm-blob/wasm_blob.compact.wasm")
        .expect("Failed to open wasm blob in target");
    let mut buffer = Vec::new();
    f.read_to_end(&mut buffer)
        .expect("Failed to load wasm blob into memory");
    buffer
}

pub trait Decoder {
    fn decode_val(&self) -> Vec<u8>;
    fn decode_option(&self) -> Option<Vec<u8>>;
    fn decode_bool(&self) -> bool;
}

impl Decoder for Vec<u8> {
    fn decode_val(&self) -> Vec<u8> {
        Vec::<u8>::decode(&mut self.as_slice()).expect("Failed to decode SCALE encoding")
    }
    fn decode_option(&self) -> Option<Vec<u8>> {
        let mut option =
            Vec::<u8>::decode(&mut self.as_slice()).expect("Failed to decode SCALE encoding");
        match option[0] {
            0 => {
                if option.len() > 1 {
                    panic!("The None value appends additional data");
                }
                None
            }
            1 => {
                option.remove(0);
                Some(option)
            }
            _ => panic!("Not a valid Option value"),
        }
    }
    fn decode_bool(&self) -> bool {
        bool::decode(&mut self.as_slice()).expect("Failed to decode SCALE encoding")
    }
}
