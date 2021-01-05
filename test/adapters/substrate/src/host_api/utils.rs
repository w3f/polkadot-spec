use clap::Values;
use std::sync::Arc;
use parity_scale_codec::Decode;
use sc_executor::{
    WasmExecutor,
    CallInWasm,
    WasmExecutionMethod,
    sp_wasm_interface::HostFunctions,
};
use sp_io::SubstrateHostFunctions;
use sp_core::{
    offchain::testing::TestOffchainExt,
    offchain::OffchainExt,
    traits::MissingHostFunctions,
    Blake2Hasher,
};
use sp_keystore::{KeystoreExt, testing::KeyStore};
use sp_state_machine::TestExternalities as CoreTestExternalities;

use runtime::WASM_BINARY;

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

impl<'a> From<Option<Values<'a>>> for ParsedInput<'a> {
    fn from(input: Option<Values<'a>>) -> Self {
        match input {
            Some(v) => ParsedInput(v.collect()),
            None => ParsedInput(Vec::new()),
        }
    }
}

pub struct Runtime {
    blob: Vec<u8>,
    ext: TestExternalities<Blake2Hasher>,
}

impl Runtime {
    pub fn new() -> Self {
        Runtime {
            blob: WASM_BINARY.unwrap().to_vec(),
            ext: TestExternalities::default(),
        }
    }
    pub fn new_keystore() -> Self {
        let mut ext = TestExternalities::default();
        let key_store = KeystoreExt(Arc::new(KeyStore::new()));
        ext.register_extension(key_store);
        Runtime {
            blob: WASM_BINARY.unwrap().to_vec(),
            ext: ext,
        }
    }
    #[allow(dead_code)]
    pub fn new_offchain() -> Self {
        let mut ext = TestExternalities::default();
        let (offchain, _) = TestOffchainExt::new();
        ext.register_extension(OffchainExt::new(offchain));

        Runtime {
            blob: WASM_BINARY.unwrap().to_vec(),
            ext: ext,
        }
    }
    pub fn call(&mut self, method: &str, data: &[u8]) -> Vec<u8> {
        let mut extext = self.ext.ext();

        WasmExecutor::new(
            WasmExecutionMethod::Interpreted,
            Some(8), // heap_pages
            SubstrateHostFunctions::host_functions(),
            8 // max_runtime_instances
        ).call_in_wasm(
            &self.blob,
            None, // Optional<Hash>
            method,
            data,
            &mut extext,
            MissingHostFunctions::Disallow,
        ).unwrap()
    }
}

pub trait Decoder {
    fn decode_bool(&self) -> bool;
    fn decode_vec(&self) -> Vec<u8>;
    fn decode_ovec(&self) -> Option<Vec<u8>>;
    fn decode_vecvec(&self) -> Vec<Vec<u8>>;
}

impl Decoder for Vec<u8> {
    fn decode_bool(&self) -> bool {
        Decode::decode(&mut self.as_slice()).expect("Failed to decode SCALE encoding")
    }
    fn decode_vec(&self) -> Vec<u8> {
        Decode::decode(&mut self.as_slice()).expect("Failed to decode SCALE encoding")
    }
    fn decode_ovec(&self) -> Option<Vec<u8>> {
        Decode::decode(&mut self.as_slice()).expect("Failed to decode SCALE encoding")
    }
    fn decode_vecvec(&self) -> Vec<Vec<u8>> {
        Decode::decode(&mut self.as_slice()).expect("Failed to decode SCALE encoding")
    }
}
