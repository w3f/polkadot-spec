use crate::host_api::utils::{str, Decoder, ParsedInput, Runtime};
use parity_scale_codec::Encode;
use sp_core::crypto::key_types::DUMMY;

pub fn ext_crypto_ed25519_public_keys_version_1(rtm: Runtime, input: ParsedInput) {
    let mut rtm = rtm.with_keystore();

    // Parse inputs
    let seed1 = input.get(0);
    let seed2 = input.get(1);

    // Generate first key
    let pubkey1 = rtm
        .call(
            "rtm_ext_crypto_ed25519_generate_version_1",
            &(DUMMY.0, Some(seed1)).encode(),
        )
        .decode_vec();

    // Generate second key
    let pubkey2 = rtm
        .call(
            "rtm_ext_crypto_ed25519_generate_version_1",
            &(DUMMY.0, Some(seed2)).encode(),
        )
        .decode_vec();

    let mut res = rtm
        .call(
            "rtm_ext_crypto_ed25519_public_keys_version_1",
            &DUMMY.0.encode(),
        )
        .decode_vec();

    res.remove(0); // TODO: Check content
    assert_eq!(res.len(), 64);
    let res1 = &res[..32]; // first pubkey
    let res2 = &res[32..]; // second pubkey

    if pubkey1 != res1 && pubkey1 != res2 {
        panic!("Return value does not include pubkey")
    }

    if pubkey2 != res1 && pubkey2 != res2 {
        panic!("Return value does not include pubkey")
    }

    println!("1. Public key: {}", hex::encode(res1));
    println!("2. Public key: {}", hex::encode(res2));
}

pub fn ext_crypto_ed25519_generate_version_1(rtm: Runtime, input: ParsedInput) {
    let mut rtm = rtm.with_keystore();

    // Parse inputs
    let seed = input.get(0);

    let res = rtm
        .call(
            "rtm_ext_crypto_ed25519_generate_version_1",
            &(DUMMY.0, Some(seed)).encode(),
        )
        .decode_vec();

    println!("{}", hex::encode(res));
}

pub fn ext_crypto_ed25519_sign_version_1(rtm: Runtime, input: ParsedInput) {
    let mut rtm = rtm.with_keystore();

    // Parse inputs
    let seed = input.get(0);
    let msg = input.get(1);

    // Generate a key
    let pubkey = rtm
        .call(
            "rtm_ext_crypto_ed25519_generate_version_1",
            &(DUMMY.0, Some(seed)).encode(),
        )
        .decode_vec();

    // Sign message
    let mut res = rtm
        .call(
            "rtm_ext_crypto_ed25519_sign_version_1",
            &(DUMMY.0, &pubkey, msg).encode(),
        )
        .decode_vec();

    // Check option
    assert_eq!(res[0], 1u8);
    res.remove(0);

    println!("Message: {}", str(&msg));
    println!("Public key: {}", hex::encode(pubkey));
    println!("Signature: {}", hex::encode(res));
}

pub fn ext_crypto_ed25519_verify_version_1(rtm: Runtime, input: ParsedInput) {
    let mut rtm = rtm.with_keystore();

    // Parse inputs
    let seed = input.get(0);
    let msg = input.get(1);

    // Generate a key
    let pubkey = rtm
        .call(
            "rtm_ext_crypto_ed25519_generate_version_1",
            &(DUMMY.0, Some(seed)).encode(),
        )
        .decode_vec();

    // Sign message
    let mut sig = rtm
        .call(
            "rtm_ext_crypto_ed25519_sign_version_1",
            &(DUMMY.0, &pubkey, &msg).encode(),
        )
        .decode_vec();

    // Check option
    assert_eq!(sig[0], 1u8);
    sig.remove(0);

    // Verify signature
    let verified = rtm
        .call(
            "rtm_ext_crypto_ed25519_verify_version_1",
            &(&sig, &msg, &pubkey).encode(),
        )
        .decode_bool();
    assert_eq!(verified, true);

    println!("Message: {}", str(&msg));
    println!("Public key: {}", hex::encode(&pubkey));
    println!("Signature: {}", hex::encode(&sig));
    if verified {
        println!("GOOD SIGNATURE");
    } else {
        println!("BAD SIGNATURE");
    }
}

pub fn ext_crypto_sr25519_public_keys_version_1(rtm: Runtime, input: ParsedInput) {
    let mut rtm = rtm.with_keystore();

    // Parse inputs
    let seed1 = input.get(0);
    let seed2 = input.get(1);

    // Generate first key
    let pubkey1 = rtm
        .call(
            "rtm_ext_crypto_sr25519_generate_version_1",
            &(DUMMY.0, Some(seed1)).encode(),
        )
        .decode_vec();

    // Generate second key
    let pubkey2 = rtm
        .call(
            "rtm_ext_crypto_sr25519_generate_version_1",
            &(DUMMY.0, Some(seed2)).encode(),
        )
        .decode_vec();

    let mut res = rtm
        .call(
            "rtm_ext_crypto_sr25519_public_keys_version_1",
            &DUMMY.0.encode(),
        )
        .decode_vec();

    res.remove(0); // TODO: Check content
    assert_eq!(res.len(), 64);
    let res1 = &res[..32]; // first pubkey
    let res2 = &res[32..]; // second pubkey

    if pubkey1 != res1 && pubkey1 != res2 {
        panic!("Return value does not include pubkey")
    }

    if pubkey2 != res1 && pubkey2 != res2 {
        panic!("Return value does not include pubkey")
    }

    println!("1. Public key: {}", hex::encode(res1));
    println!("2. Public key: {}", hex::encode(res2));
}

pub fn ext_crypto_sr25519_generate_version_1(rtm: Runtime, input: ParsedInput) {
    let mut rtm = rtm.with_keystore();

    // Parse inputs
    let seed = input.get(0);
    let seed_opt = if seed.is_empty() { None } else { Some(seed) };

    // Generate a key
    let res = rtm
        .call(
            "rtm_ext_crypto_sr25519_generate_version_1",
            &(DUMMY.0, seed_opt).encode(),
        )
        .decode_vec();

    println!("{}", hex::encode(res));
}

pub fn ext_crypto_sr25519_sign_version_1(rtm: Runtime, input: ParsedInput) {
    let mut rtm = rtm.with_keystore();

    // Parse inputs
    let seed = input.get(0);
    let msg = input.get(1);

    // Generate a key
    let pubkey = rtm
        .call(
            "rtm_ext_crypto_sr25519_generate_version_1",
            &(DUMMY.0, Some(seed)).encode(),
        )
        .decode_vec();

    // Sign message
    let mut res = rtm
        .call(
            "rtm_ext_crypto_sr25519_sign_version_1",
            &(DUMMY.0, &pubkey, msg).encode(),
        )
        .decode_vec();

    // Check option
    assert_eq!(res[0], 1u8);
    res.remove(0);

    println!("Message: {}", str(&msg));
    println!("Public key: {}", hex::encode(pubkey));
    println!("Signature: {}", hex::encode(res));
}

pub fn ext_crypto_sr25519_verify_version_1(rtm: Runtime, input: ParsedInput) {
    let mut rtm = rtm.with_keystore();

    // Parse inputs
    let seed = input.get(0);
    let msg = input.get(1);

    // Generate a key
    let pubkey = rtm
        .call(
            "rtm_ext_crypto_sr25519_generate_version_1",
            &(DUMMY.0, Some(seed)).encode(),
        )
        .decode_vec();

    // Sign message
    let mut sig = rtm
        .call(
            "rtm_ext_crypto_sr25519_sign_version_1",
            &(DUMMY.0, &pubkey, &msg).encode(),
        )
        .decode_vec();

    // Check option
    assert_eq!(sig[0], 1u8);
    sig.remove(0);

    let verified = rtm
        .call(
            "rtm_ext_crypto_sr25519_verify_version_1",
            &(&sig, &msg, &pubkey).encode(),
        )
        .decode_bool();

    assert_eq!(verified, true);

    println!("Message: {}", str(&msg));
    println!("Public key: {}", hex::encode(&pubkey));
    println!("Signature: {}", hex::encode(&sig));
    if verified {
        println!("GOOD SIGNATURE");
    } else {
        println!("BAD SIGNATURE");
    }
}

pub fn ext_hashing_keccak_256_version_1(mut rtm: Runtime, input: ParsedInput) {
    let data = input.get(0);

    let res = rtm
        .call("rtm_ext_hashing_keccak_256_version_1", &(data).encode())
        .decode_vec();

    println!("{}", hex::encode(res));
}

pub fn ext_hashing_sha2_256_version_1(mut rtm: Runtime, input: ParsedInput) {
    let data = input.get(0);

    let res = rtm
        .call("rtm_ext_hashing_sha2_256_version_1", &(data).encode())
        .decode_vec();

    println!("{}", hex::encode(res));
}

pub fn ext_hashing_blake2_128_version_1(mut rtm: Runtime, input: ParsedInput) {
    let data = input.get(0);

    let res = rtm
        .call("rtm_ext_hashing_blake2_128_version_1", &(data).encode())
        .decode_vec();

    println!("{}", hex::encode(res));
}

pub fn ext_hashing_blake2_256_version_1(mut rtm: Runtime, input: ParsedInput) {
    let data = input.get(0);

    let res = rtm
        .call("rtm_ext_hashing_blake2_256_version_1", &(data).encode())
        .decode_vec();

    println!("{}", hex::encode(res));
}

pub fn ext_hashing_twox_256_version_1(mut rtm: Runtime, input: ParsedInput) {
    let data = input.get(0);

    let res = rtm
        .call("rtm_ext_hashing_twox_256_version_1", &(data).encode())
        .decode_vec();

    println!("{}", hex::encode(res));
}

pub fn ext_hashing_twox_128_version_1(mut rtm: Runtime, input: ParsedInput) {
    let data = input.get(0);

    let res = rtm
        .call("rtm_ext_hashing_twox_128_version_1", &(data).encode())
        .decode_vec();

    println!("{}", hex::encode(res));
}

pub fn ext_hashing_twox_64_version_1(mut rtm: Runtime, input: ParsedInput) {
    let data = input.get(0);

    let res = rtm
        .call("rtm_ext_hashing_twox_64_version_1", &(data).encode())
        .decode_vec();

    println!("{}", hex::encode(res));
}
