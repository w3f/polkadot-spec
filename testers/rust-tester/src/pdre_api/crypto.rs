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
    let pubkey1 = api.rtm_ext_ed25519_generate(keystore.as_bytes(), &[]);

    // Sign a message
    let signature = api.rtm_ext_ed25519_sign(keystore.as_bytes(), &pubkey1, data);

    // Verify message
    let verify = api.rtm_ext_ed25519_verify(data, signature.as_slice(), &pubkey1);
    assert_eq!(verify, 0);

    // Generate new key pair for listing
    let pubkey2 = api.rtm_ext_ed25519_generate(keystore.as_bytes(), &[]);

    // Get all public keys
    let all_pubkeys = api.rtm_ext_ed25519_public_keys(keystore.as_bytes());
    assert_eq!(all_pubkeys.len(), 64);

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
    let pubkey1 = api.rtm_ext_sr25519_generate(keystore.as_bytes(), &[]);

    // Sign a message
    let signature = api.rtm_ext_sr25519_sign(keystore.as_bytes(), &pubkey1, data);

    let verify = api.rtm_ext_sr25519_verify(data, &signature, &pubkey1);
    assert_eq!(verify, 0);

    // Generate new key pair for listing
    let pubkey2 = api.rtm_ext_sr25519_generate(keystore.as_bytes(), &[]);

    // Get all public keys
    let all_pubkeys = api.rtm_ext_sr25519_public_keys(keystore.as_bytes());
    assert_eq!(all_pubkeys.len(), 64);

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
