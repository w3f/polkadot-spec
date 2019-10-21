use super::utils::CryptoApi;
use super::ParsedInput;

use substrate_primitives::hashing::{twox_128, twox_256, twox_64};

// Input: data
pub fn test_blake2_128(input: ParsedInput) {
    let mut api = CryptoApi::new();
    let data = input.get(0);

    let output = api.rtm_ext_blake2_128(data);
    println!("{}", hex::encode(output));
}

// Input: data
pub fn test_blake2_256(input: ParsedInput) {
    let mut api = CryptoApi::new();
    let data = input.get(0);
 
    let output = api.rtm_ext_blake2_256(data);

    println!("{}", hex::encode(output));
}

// Input: data
pub fn test_twox_64(input: ParsedInput) {
    let mut api = CryptoApi::new();
    let data = input.get(0);

    let output = api.rtm_ext_twox_64(data);
    assert_eq!(twox_64(data), output.as_slice());

    println!("{}", hex::encode(output));
}

// Input: data
pub fn test_twox_128(input: ParsedInput) {
    let mut api = CryptoApi::new();
    let data = input.get(0);

    let output = api.rtm_ext_twox_128(data);
    assert_eq!(twox_128(data), output.as_slice());

    println!("{}", hex::encode(output));
}

// Input: data
pub fn test_twox_256(input: ParsedInput) {
    let mut api = CryptoApi::new();
    let data = input.get(0);

    let output =  api.rtm_ext_twox_256(data);
    assert_eq!(twox_256(data), output.as_slice());

    println!("{}", hex::encode(output));
}

// Input: data
pub fn test_keccak_256(input: ParsedInput) {
    let mut api = CryptoApi::new();
    let data = input.get(0);

    let output = api.rtm_ext_keccak_256(data);

    println!("{}", hex::encode(output));
}

// Input: data
pub fn test_ed25519(input: ParsedInput) {
    let mut api = CryptoApi::new();
    let data = input.get(0);

    // Generate key pair
    let keystore = String::from("dumy");
    let mut pubkey1 = [0; 32];
    api.rtm_ext_ed25519_generate(keystore.as_bytes(), &[], &mut pubkey1);

    // Sign a message
    let mut signature = [0; 64];
    let res = api.rtm_ext_ed25519_sign(keystore.as_bytes(), &pubkey1, data, &mut signature);
    assert_eq!(res, 0);

    // Verify message
    let verify = api.rtm_ext_ed25519_verify(data, &signature, &pubkey1);
    assert_eq!(verify, 0);

    // Generate new key pair for listing
    let mut pubkey2 = [0; 32]; // will get generated
    api.rtm_ext_ed25519_generate(keystore.as_bytes(), &[], &mut pubkey2);

    // Get all public keys
    let mut result_len: u32 = 0;
    let all_pubkeys = api.rtm_ext_ed25519_public_keys(keystore.as_bytes(), &mut result_len);
    //assert_eq!(result_len, 65); // Why 65 and not 64?

    println!("Public key 1: {}", hex::encode(pubkey1));
    println!("Input/message: {}", std::str::from_utf8(data).unwrap());
    println!("Signature: {}", hex::encode(&signature[..]));
    if verify == 0 {
        println!("GOOD SIGNATURE");
    } else {
        println!("BAD SIGNATURE");
    }
    println!("Public key 2: {}", hex::encode(pubkey2));
    println!("All public keys : {}", hex::encode(&all_pubkeys[1..]));
}

// Input: data
pub fn test_sr25519(input: ParsedInput) {
    let mut api = CryptoApi::new();
    let data = input.get(0);

    // Generate key pair
    let keystore = String::from("dumy");
    let mut pubkey1 = [0; 32];
    api.rtm_ext_sr25519_generate(keystore.as_bytes(), &[], &mut pubkey1);

    // Sign a message
    let mut signature = [0; 64];
    let res = api.rtm_ext_sr25519_sign(keystore.as_bytes(), &pubkey1, data, &mut signature);
    assert_eq!(res, 0);

    let verify = api.rtm_ext_sr25519_verify(data, &signature, &pubkey1);
    assert_eq!(verify, 0);

    // Generate new key pair for listing
    let mut pubkey2 = [0; 32]; // will get generated
    api.rtm_ext_sr25519_generate(keystore.as_bytes(), &[], &mut pubkey2);

    // Get all public keys
    let mut result_len: u32 = 0;
    let all_pubkeys = api.rtm_ext_sr25519_public_keys(keystore.as_bytes(), &mut result_len);
    assert_eq!(result_len, 65);

    println!("Public key 1: {}", hex::encode(pubkey1));
    println!("Input/message: {}", std::str::from_utf8(data).unwrap());
    println!("Signature: {}", hex::encode(&signature[..]));
    if verify == 0 {
        println!("GOOD SIGNATURE");
    } else {
        println!("BAD SIGNATURE");
    }
    println!("Public key 2: {}", hex::encode(pubkey2));
    println!("All public keys : {}", hex::encode(&all_pubkeys[1..]));
}
