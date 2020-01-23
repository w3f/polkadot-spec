use crate::pdre_api::utils::{Decoder, ParsedInput, Runtime};
use parity_scale_codec::Encode;
// TODO: Spec key types
use sp_core::crypto::key_types::DUMMY;

fn str<'a>(input: &'a [u8]) -> &'a str {
    std::str::from_utf8(input).unwrap()
}

// Input: key, value
// TODO: How to test this with generating keys
pub fn ext_crypto_ed25519_public_keys_version_1() {
    let mut rtm = Runtime::new_keystore();

    let res = rtm
        .call(
            "rtm_ext_crypto_ed25519_public_keys_version_1",
            &DUMMY.0.encode()
        )
        .decode_vec();
}