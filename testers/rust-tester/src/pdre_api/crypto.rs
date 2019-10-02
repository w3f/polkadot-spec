use super::utils::CryptoApi;

use substrate_primitives::hashing::{twox_128, twox_256, twox_64};

pub fn test_blake2_128(input: &str) {
    let mut api = CryptoApi::new();

    let mut output = [0; 16];

    api.rtm_ext_blake2_128(input.as_bytes(), &mut output);
    assert_eq!(
        hex::decode("b9f759e8bba7215c55babf022740e70e").unwrap(),
        output
    );
}

pub fn test_blake2_256(input: &str) {
    let mut api = CryptoApi::new();

    let mut output = [0; 32];

    api.rtm_ext_blake2_256(input.as_bytes(), &mut output);
    assert_eq!(
        hex::decode("205b104b5db516e0a7b61b0243cfc0a7dee470d831e1707ebb99ae6bbd1ca70c").unwrap(),
        output
    );
}

pub fn test_twox_64(input: &str) {
    let mut api = CryptoApi::new();

    let mut output = [0; 8];

    api.rtm_ext_twox_64(input.as_bytes(), &mut output);
    assert_eq!(twox_64(input.as_bytes()), output);

    println!("> testing TwoX 64-bit hash");
    println!("  - Input : {}", input);
    println!("  - Output : {}", hex::encode(output));
}

pub fn test_twox_128(input: &str) {
    let mut api = CryptoApi::new();

    let mut output = [0; 16];

    api.rtm_ext_twox_128(input.as_bytes(), &mut output);
    assert_eq!(twox_128(input.as_bytes()), output);

    println!("> testing TwoX 128-bit hash");
    println!("  - Input : {}", input);
    println!("  - Output : {}", hex::encode(output));
}

pub fn test_twox_256(input: &str) {
    let mut api = CryptoApi::new();

    let mut output = [0; 32];

    api.rtm_ext_twox_256(input.as_bytes(), &mut output);
    assert_eq!(twox_256(input.as_bytes()), output);

    println!("> testing TwoX 256-bit hash");
    println!("  - Input : {}", input);
    println!("  - Output : {}", hex::encode(output));
}

pub fn test_keccak_256(input: &str) {
    let mut api = CryptoApi::new();

    let mut output = [0; 32];

    api.rtm_ext_keccak_256(input.as_bytes(), &mut output);
    assert_eq!(
        hex::decode("de58a0bbe5d87cf47773472428863d8d7e52c6f9251288660bbbef7afa2a6286").unwrap(),
        output
    );
}

pub fn test_ed25519(input: &str) { // message
    let mut api = CryptoApi::new();

    // Generate key pair
    let keystore = String::from("dumy");
    let mut pubkey1 = [0; 32]; // will get generated

    api.rtm_ext_ed25519_generate(keystore.as_bytes(), &[], &mut pubkey1);

    // Sign a message
    let mut signature = [0; 64]; // will get generated

    let res = api.rtm_ext_ed25519_sign(
        keystore.as_bytes(),
        &pubkey1,
        input.as_bytes(),
        &mut signature,
    );
    assert_eq!(res, 0);

    // Verify message
    let verify = api.rtm_ext_ed25519_verify(input.as_bytes(), &signature, &pubkey1);
    assert_eq!(verify, 0);

    // Generate new key pair for listing
    let mut pubkey2 = [0; 32]; // will get generated
    api.rtm_ext_ed25519_generate(keystore.as_bytes(), &[], &mut pubkey2);

    // Get all public keys
    let mut result_len: u32 = 0;
    let all_pubkeys = api.rtm_ext_ed25519_public_keys(keystore.as_bytes(), &mut result_len);
    //assert_eq!(result_len, 65); // Why 65 and not 64?

    println!("> testing ed25519 keys");
    println!("  - public key 1: {}", hex::encode(pubkey1));
    println!("  - input/message: {}", input);
    println!("  - signature: {}", hex::encode(&signature[..]));
    print!("  - signature valid?: ");
    if verify == 0 {
        println!("GOOD SIGNATURE");
    } else {
        println!("BAD SIGNATURE");
    }
    println!("  - public key 2: {}", hex::encode(pubkey2));
    println!("  - all public keys : {}", hex::encode(&all_pubkeys[1..])); // TODO; should be [..]
}

pub fn test_sr25519(input: &str) {
    let mut api = CryptoApi::new();

    // Generate key pair
    let keystore = String::from("dumy");
    let mut pubkey1 = [0; 32]; // will get generated

    api.rtm_ext_sr25519_generate(keystore.as_bytes(), &[], &mut pubkey1);

    // Sign a message
    let mut signature = [0; 64]; // will get generated

    let res = api.rtm_ext_sr25519_sign(
        keystore.as_bytes(),
        &pubkey1,
        input.as_bytes(),
        &mut signature,
    );
    assert_eq!(res, 0);

    let verify = api.rtm_ext_sr25519_verify(input.as_bytes(), &signature, &pubkey1);
    assert_eq!(verify, 0);

    // Generate new key pair for listing
    let mut pubkey2 = [0; 32]; // will get generated
    api.rtm_ext_sr25519_generate(keystore.as_bytes(), &[], &mut pubkey2);

    // Get all public keys
    let mut result_len: u32 = 0;
    let all_pubkeys = api.rtm_ext_sr25519_public_keys(keystore.as_bytes(), &mut result_len);
    assert_eq!(result_len, 65);

    println!("> testing sr25519 keys");
    println!("  - public key 1: {}", hex::encode(pubkey1));
    println!("  - input/message: {}", input);
    println!("  - signature: {}", hex::encode(&signature[..]));
    print!("  - signature valid?: ");
    if verify == 0 {
        println!("GOOD SIGNATURE");
    } else {
        println!("BAD SIGNATURE");
    }
    println!("  - public key 2: {}", hex::encode(pubkey2));
    println!("  - all public keys : {}", hex::encode(&all_pubkeys[1..])); // TODO; should be [..]
}
