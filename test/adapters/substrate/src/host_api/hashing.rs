use crate::host_api::utils::{Decoder, ParsedInput, Runtime};
use parity_scale_codec::Encode;

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
