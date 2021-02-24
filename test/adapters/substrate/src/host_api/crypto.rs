use crate::host_api::utils::{str, ParsedInput, Runtime};
use parity_scale_codec::Encode;
use sp_core::ed25519;
use sp_core::sr25519;
use sp_core::crypto::key_types::DUMMY;

pub fn ext_crypto_ed25519_public_keys_version_1(rtm: Runtime, input: ParsedInput) {
    let mut rtm = rtm.with_keystore();

    // Parse inputs
    let seed1 = input.get(0);
    let seed2 = input.get(1);

    // Generate first key
    let pubkey1 = rtm.call_and_decode::<ed25519::Public>(
        "rtm_ext_crypto_ed25519_generate_version_1",
        &(DUMMY.0, Some(seed1)).encode(),
    );

    // Generate second key
    let pubkey2 = rtm.call_and_decode::<ed25519::Public>(
        "rtm_ext_crypto_ed25519_generate_version_1",
        &(DUMMY.0, Some(seed2)).encode(),
    );

    // Retrieve all known keys
    let res = rtm.call_and_decode::<Vec<ed25519::Public>>(
        "rtm_ext_crypto_ed25519_public_keys_version_1",
        &DUMMY.0.encode(),
    );

    assert_eq!(res.len(), 2);

    if pubkey1 != res[0] && pubkey1 != res[1] {
        panic!("Keystore does not include pubkey 1")
    }

    if pubkey2 != res[0] && pubkey2 != res[1] {
        panic!("Keystore does not include pubkey 2")
    }

    println!("1. Public key: {}", hex::encode(res[0]));
    println!("2. Public key: {}", hex::encode(res[1]));
}

pub fn ext_crypto_ed25519_generate_version_1(rtm: Runtime, input: ParsedInput) {
    let mut rtm = rtm.with_keystore();

    // Parse inputs
    let seed = input.get(0);

    let res = rtm.call_and_decode::<ed25519::Public>(
        "rtm_ext_crypto_ed25519_generate_version_1",
        &(DUMMY.0, Some(seed)).encode(),
    );

    // Print result
    println!("{}", hex::encode(res));
}

pub fn ext_crypto_ed25519_sign_version_1(rtm: Runtime, input: ParsedInput) {
    let mut rtm = rtm.with_keystore();

    // Parse inputs
    let seed = input.get(0);
    let msg = input.get(1);

    // Generate a key
    let pubkey = rtm.call_and_decode::<ed25519::Public>(
        "rtm_ext_crypto_ed25519_generate_version_1",
        &(DUMMY.0, Some(seed)).encode(),
    );

    // Sign message
    let res = rtm.call_and_decode::<Option<ed25519::Signature>>(
        "rtm_ext_crypto_ed25519_sign_version_1",
        &(DUMMY.0, &pubkey, msg).encode(),
    ).unwrap();

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
    let pubkey = rtm.call_and_decode::<ed25519::Public>(
        "rtm_ext_crypto_ed25519_generate_version_1",
        &(DUMMY.0, Some(seed)).encode(),
    );

    // Sign message
    let sig = rtm.call_and_decode::<Option<ed25519::Signature>>(
        "rtm_ext_crypto_ed25519_sign_version_1",
        &(DUMMY.0, &pubkey, &msg).encode(),
    ).unwrap();

    // Verify signature
    let verified = rtm.call_and_decode::<bool>(
        "rtm_ext_crypto_ed25519_verify_version_1",
        &(&sig, &msg, &pubkey).encode(),
    );

    assert_eq!(verified, true);

    // Print result
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
    let pubkey1 = rtm.call_and_decode::<sr25519::Public>(
        "rtm_ext_crypto_sr25519_generate_version_1",
        &(DUMMY.0, Some(seed1)).encode(),
    );

    // Generate second key
    let pubkey2 = rtm.call_and_decode::<sr25519::Public>(
        "rtm_ext_crypto_sr25519_generate_version_1",
        &(DUMMY.0, Some(seed2)).encode(),
    );

    let res = rtm.call_and_decode::<Vec<sr25519::Public>>(
        "rtm_ext_crypto_sr25519_public_keys_version_1",
        &DUMMY.0.encode(),
    );

    assert_eq!(res.len(), 2);

    if pubkey1 != res[0] && pubkey1 != res[1] {
        panic!("Keystore does not include pubkey 1")
    }

    if pubkey2 != res[0] && pubkey2 != res[1] {
        panic!("Keystore does not include pubkey 2")
    }

    println!("1. Public key: {}", hex::encode(res[0]));
    println!("2. Public key: {}", hex::encode(res[1]));
}

pub fn ext_crypto_sr25519_generate_version_1(rtm: Runtime, input: ParsedInput) {
    let mut rtm = rtm.with_keystore();

    // Parse inputs
    let seed = input.get(0);
    let seed_opt = if seed.is_empty() { None } else { Some(seed) };

    // Generate a key
    let res = rtm.call_and_decode::<sr25519::Public>(
        "rtm_ext_crypto_sr25519_generate_version_1",
        &(DUMMY.0, seed_opt).encode(),
    );

    // Print result
    println!("{}", hex::encode(res));
}

pub fn ext_crypto_sr25519_sign_version_1(rtm: Runtime, input: ParsedInput) {
    let mut rtm = rtm.with_keystore();

    // Parse inputs
    let seed = input.get(0);
    let msg = input.get(1);

    // Generate a key
    let pubkey = rtm.call_and_decode::<sr25519::Public>(
        "rtm_ext_crypto_sr25519_generate_version_1",
        &(DUMMY.0, Some(seed)).encode(),
    );

    // Sign message
    let res = rtm.call_and_decode::<Option<sr25519::Signature>>(
        "rtm_ext_crypto_sr25519_sign_version_1",
        &(DUMMY.0, &pubkey, msg).encode(),
    ).unwrap();

    // Print result
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
    let pubkey = rtm.call_and_decode::<sr25519::Public>(
        "rtm_ext_crypto_sr25519_generate_version_1",
        &(DUMMY.0, Some(seed)).encode(),
    );

    // Sign message
    let sig = rtm.call_and_decode::<Option<sr25519::Signature>>(
        "rtm_ext_crypto_sr25519_sign_version_1",
        &(DUMMY.0, &pubkey, &msg).encode(),
    ).unwrap();

    // Verify signature
    let verified = rtm.call_and_decode::<bool>(
        "rtm_ext_crypto_sr25519_verify_version_1",
        &(&sig, &msg, &pubkey).encode(),
    );

    assert_eq!(verified, true);

    // Print result
    println!("Message: {}", str(&msg));
    println!("Public key: {}", hex::encode(&pubkey));
    println!("Signature: {}", hex::encode(&sig));
    if verified {
        println!("GOOD SIGNATURE");
    } else {
        println!("BAD SIGNATURE");
    }
}
