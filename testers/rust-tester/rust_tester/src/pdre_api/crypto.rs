use crate::pdre_api::utils::{Decoder, ParsedInput, Runtime};
use parity_scale_codec::Encode;
// TODO: Spec key types
use sp_core::crypto::key_types::DUMMY;

fn str<'a>(input: &'a [u8]) -> &'a str {
    std::str::from_utf8(input).unwrap()
}

// TODO: Test this with generating keys
pub fn ext_crypto_ed25519_public_keys_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new_keystore();

    let seed1 = input.get(0);
    let seed2 = input.get(1);

    // Generate first key
    let pubkey1 = rtm
        .call(
            "rtm_ext_crypto_ed25519_generate_version_1",
            &(DUMMY.0, Some(seed1)).encode(),
        )
        .decode_val();

    // Generate second key
    let pubkey2 = rtm
        .call(
            "rtm_ext_crypto_ed25519_generate_version_1",
            &(DUMMY.0, Some(seed2)).encode(),
        )
        .decode_val();

    let res = rtm
        .call(
            "rtm_ext_crypto_ed25519_public_keys_version_1",
            &DUMMY.0.encode()
        )
        //.decode_val()
        .decode_vec();

    assert_eq!(res.len(), 2);
    //assert!(res.contains(&pubkey1));
    //assert!(res.contains(&pubkey2));

    for pubkey in res {
        println!("{}", hex::encode(&pubkey));
    }
}

// TODO: Spec that seed is Option<>
// TODO: Spec seed value (and needs to be valid utf8)
// TODO: Spec seed data is encoded
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

// TODO
pub fn ext_crypto_ed25519_verify_version_1(input: ParsedInput) {
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
    let sig = rtm
        .call(
            "rtm_ext_crypto_ed25519_sign_version_1",
            &(DUMMY.0, &pubkey, &msg).encode(),
        )
        .decode_val();

    let verified = rtm
        .call(
            "rtm_ext_crypto_ed25519_verify_version_1",
            &(&sig, &msg, &pubkey).encode(),
        )
        .decode_bool();

    assert_eq!(verified, true);
    println!("true")
}

// TODO
pub fn ext_crypto_sr25519_public_keys_version_1(input: ParsedInput) {

}

// TODO: Spec that seed is Option<>
// TODO: Spec seed value (and needs to be valid utf8)
// TODO: Spec seed data is encoded
// TODO: Spec return value (32byte array)
pub fn ext_crypto_sr25519_generate_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new_keystore();

    let seed = input.get(0);
    let seed_opt = if seed.is_empty() {
        None
    } else {
        Some(seed)
    };

    // Generate a key
    let res = rtm
        .call(
            "rtm_ext_crypto_sr25519_generate_version_1",
            &(DUMMY.0, seed_opt).encode(),
        )
        .decode_val();

    println!("{}", hex::encode(res));
}

// TODO: Spec return type (64byte array)
// TODO: Spec pubkey parameter (32byte array)
pub fn ext_crypto_sr25519_sign_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new_keystore();

    let seed = input.get(0);
    let msg = input.get(1);

    // Generate a key
    let pubkey = rtm
        .call(
            "rtm_ext_crypto_sr25519_generate_version_1",
            &(DUMMY.0, Some(seed)).encode(),
        )
        .decode_val();

    // Sign message
    let res = rtm
        .call(
            "rtm_ext_crypto_sr25519_sign_version_1",
            &(DUMMY.0, pubkey, msg).encode(),
        )
        .decode_val();

    println!("{}", hex::encode(res));
}

// TODO
pub fn ext_crypto_sr25519_verify_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new_keystore();

    let seed = input.get(0);
    let msg = input.get(1);

    // Generate a key
    let pubkey = rtm
        .call(
            "rtm_ext_crypto_sr25519_generate_version_1",
            &(DUMMY.0, Some(seed)).encode(),
        )
        .decode_val();

    // Sign message
    let sig = rtm
        .call(
            "rtm_ext_crypto_sr25519_sign_version_1",
            &(DUMMY.0, &pubkey, &msg).encode(),
        )
        .decode_val();

    let verified = rtm
        .call(
            "rtm_ext_crypto_sr25519_verify_version_1",
            &(&sig, &msg, &pubkey).encode(),
        )
        .decode_bool();

    assert_eq!(verified, true);
    println!("true")
}
