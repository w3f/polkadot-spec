use crate::pdre_api::utils::{Decoder, ParsedInput, Runtime};
use parity_scale_codec::Encode;
// TODO: Spec key types
use sp_core::crypto::key_types::DUMMY;

fn str<'a>(input: &'a [u8]) -> &'a str {
    std::str::from_utf8(input).unwrap()
}

// TODO: Test this with generating keys
pub fn ext_crypto_ed25519_public_keys_version_1() {
    let mut rtm = Runtime::new_keystore();

    let res = rtm
        .call(
            "rtm_ext_crypto_ed25519_public_keys_version_1",
            &DUMMY.0.encode()
        )
        .decode_vec();
}

// TODO: Spec that seed is Option<>
// TODO: Spec that seed value needs to be valid utf8
// TODO: Spec return value (32byte array)
pub fn ext_crypto_ed25519_generate_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new_keystore();

    let seed = input.get(0);

    let res = rtm
        .call(
            "rtm_ext_crypto_ed25519_generate_version_1",
            &(DUMMY.0, Some(seed)).encode(),
        )
        .decode_val();

    println!("{}", hex::encode(res));
}

// TODO: Spec return type (64byte array)
// TODO: Spec pubkey parameter (32byte array)
pub fn ext_crypto_ed25519_sign_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new_keystore();

    let seed = input.get(0);
    let msg = input.get(1);

    // Generate a key
    let pubkey = rtm
        .call(
            "rtm_ext_crypto_ed25519_generate_version_1",
            &(DUMMY.0, Some(seed)).encode(),
        )
        .decode_val();

    // Sign message
    let res = rtm
        .call(
            "rtm_ext_crypto_ed25519_sign_version_1",
            &(DUMMY.0, pubkey, msg).encode(),
        )
        .decode_val();

    println!("{}", hex::encode(res));
}