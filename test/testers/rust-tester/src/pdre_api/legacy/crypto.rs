use crate::pdre_api::ParsedInput;
use super::utils::{Runtime, Decoder, CryptoApi};
use parity_scale_codec::Encode;

use substrate_primitives::hashing::{twox_128, twox_256, twox_64};

// Input: data
pub fn test_blake2_128(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let data = input.get(0);

    let output = rtm
        .call("rtm_ext_blake2_128", &data.encode())
        .decode_vec();
    println!("{}", hex::encode(output));
}

// Input: data
pub fn test_blake2_256(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let data = input.get(0);
 
    let output = rtm
        .call("rtm_ext_blake2_256", &data.encode())
        .decode_vec();

    println!("{}", hex::encode(output));
}

pub fn test_blake2_256_enumerated_trie_root(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let value1 = input.get(0);
    let value2 = input.get(1);
    let lens_data = vec![value1.len() as u32, value2.len() as u32];

    let res = rtm
        .call("rtm_ext_blake2_256_enumerated_trie_root", &([value1, value2].concat(), lens_data).encode())
        .decode_vec();
    println!("{}", hex::encode(res));
}

// Input: data
pub fn test_twox_64(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let data = input.get(0);

    let output = rtm
        .call("rtm_ext_twox_64", &data.encode())
        .decode_vec();
    assert_eq!(twox_64(data), output.as_slice());

    println!("{}", hex::encode(output));
}

// Input: data
pub fn test_twox_128(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let data = input.get(0);

    let output = rtm
        .call("rtm_ext_twox_128", &data.encode())
        .decode_vec();
    assert_eq!(twox_128(data), output.as_slice());

    println!("{}", hex::encode(output));
}

// Input: data
pub fn test_twox_256(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let data = input.get(0);

    let output = rtm
        .call("rtm_ext_twox_256", &data.encode())
        .decode_vec();
    assert_eq!(twox_256(data), output.as_slice());

    println!("{}", hex::encode(output));
}

// Input: data
pub fn test_keccak_256(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let data = input.get(0);

    let output = rtm
        .call("rtm_ext_keccak_256", &data.encode())
        .decode_vec();
    println!("{}", hex::encode(output));
}

// Input: data
pub fn test_ed25519(input: ParsedInput) {
    let mut rtm = Runtime::new_keystore();

    let data = input.get(0);

    // Generate key pair
    let keystore = String::from("dumy");
    let pubkey1 = rtm
        .call("rtm_ext_ed25519_generate", &(&keystore, "").encode())
        .decode_vec();

    // Sign a message
    let signature = rtm
        .call("rtm_ext_ed25519_sign", &(&keystore, &pubkey1, &data).encode())
        .decode_vec();

    // Verify message
    let verify = rtm
        .call("rtm_ext_ed25519_verify", &(&data, &signature, &pubkey1).encode())
        .decode_u32();
    assert_eq!(verify, 0);

    // Generate new key pair for listing
    let pubkey2 = rtm
        .call("rtm_ext_ed25519_generate", &(&keystore, "").encode())
        .decode_vec();

    // Get all public keys
    let all_pubkeys = rtm
        .call("rtm_ext_ed25519_public_keys", &keystore.encode())
        .decode_vec();
    assert_eq!(all_pubkeys.len(), 65);

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
    let mut rtm = Runtime::new_keystore();

    let data = input.get(0);

    // Generate key pair
    let keystore = String::from("dumy");
    let pubkey1 = rtm
        .call("rtm_ext_sr25519_generate", &(&keystore, "").encode())
        .decode_vec();

    // Sign a message
    let signature = rtm
        .call("rtm_ext_sr25519_sign", &(&keystore, &pubkey1, &data).encode())
        .decode_vec();

    let verify = rtm
        .call("rtm_ext_sr25519_verify", &(&data, &signature, &pubkey1).encode())
        .decode_u32();
    assert_eq!(verify, 0);

    // Generate new key pair for listing
    let pubkey2 = rtm
        .call("rtm_ext_sr25519_generate", &(&keystore, "").encode())
        .decode_vec();

    // Get all public keys
    let all_pubkeys = rtm
        .call("rtm_ext_sr25519_public_keys", &keystore.encode())
        .decode_vec();
    assert_eq!(all_pubkeys.len(), 65);

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

// Input: message, signature, pubkey
pub fn test_secp256k1_ecdsa_recover(input: ParsedInput) {
    let mut rtm = Runtime::new_keystore();

    let msg_data = input.get(0);
    let sig_data = hex::decode(input.get(1)).expect("Failed hex decoding of input");
    let expected = hex::decode(input.get(2)).expect("Failed hex decoding of input");

    let recovered = rtm
        .call("rtm_ext_secp256k1_ecdsa_recover", &(&msg_data, &sig_data).encode())
        .decode_vec();

    assert_eq!(expected, recovered.as_slice());
}