use clap::Values;
use parity_scale_codec::Decode;
use executor::{call_in_wasm, WasmExecutionMethod};
use primitives::{offchain::OffchainExt, testing::KeyStore, traits::KeystoreExt, Blake2Hasher};
use state_machine::TestExternalities as CoreTestExternalities;
use offchain::testing::TestOffchainExt;

use runtime::WASM_BINARY;

type TestExternalities<H> = CoreTestExternalities<H, u64>;

pub struct ParsedInput<'a>(Vec<&'a str>);

impl<'a> ParsedInput<'a> {
    pub fn get(&self, index: usize) -> &[u8] {
        if let Some(ret) = self.0.get(index) {
            ret.as_bytes()
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
            blob: WASM_BINARY.to_vec(),
            ext: TestExternalities::default(),
        }
    }
    pub fn new_keystore() -> Self {
        let mut ext = TestExternalities::default();
        let key_store = KeystoreExt(KeyStore::new());
        ext.register_extension(key_store);
        Runtime {
            blob: WASM_BINARY.to_vec(),
            ext: ext,
        }
    }
    pub fn new_offchain() -> Self {
        let mut ext = TestExternalities::default();
        let (offchain, _) = TestOffchainExt::new();
        ext.register_extension(OffchainExt::new(offchain));

        Runtime {
            blob: WASM_BINARY.to_vec(),
            ext: ext,
        }
    }
    pub fn call(&mut self, method: &str, data: &[u8]) -> Vec<u8> {
        let mut extext = self.ext.ext();
        call_in_wasm(
            method,
            data,
            WasmExecutionMethod::Interpreted,
            &mut extext,
            &self.blob,
            8,
        )
        .unwrap()
    }
}

pub trait Decoder {
    fn decode_vec(&self) -> Vec<u8>;
    fn decode_u32(&self) -> u32;
    fn decode_u64(&self) -> u64;
}

impl Decoder for Vec<u8> {
    fn decode_vec(&self) -> Vec<u8> {
        Vec::<u8>::decode(&mut self.as_slice()).expect("Failed to decode SCALE encoding")
    }
    fn decode_u32(&self) -> u32 {
        u32::decode(&mut self.as_slice()).expect("Failed to decode SCALE encoding")
    }
    fn decode_u64(&self) -> u64 {
        u64::decode(&mut self.as_slice()).expect("Failed to decode SCALE encoding")
    }
}
