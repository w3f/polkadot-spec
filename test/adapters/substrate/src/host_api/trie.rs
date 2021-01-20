use crate::host_api::utils::{Decoder, ParsedInput, Runtime};
use parity_scale_codec::Encode;

pub fn ext_trie_blake2_256_root_version_1(mut rtm: Runtime, input: ParsedInput) {
    // Parse input
    let key1 = input.get(0);
    let value1 = input.get(1);
    let key2 = input.get(2);
    let value2 = input.get(3);
    let key3 = input.get(4);
    let value3 = input.get(5);

    let trie = vec![(key1, value1), (key2, value2), (key3, value3)];

    // Get valid key
    let res = rtm
        .call("rtm_ext_trie_blake2_256_root_version_1", &(trie).encode())
        .decode_vec();

    println!("{}", hex::encode(res));
}

pub fn ext_trie_blake2_256_ordered_root_version_1(mut rtm: Runtime, input: ParsedInput) {
    // Parse input
    let value1 = input.get(0);
    let value2 = input.get(1);
    let value3 = input.get(2);

    let trie = vec![value1, value2, value3];

    // Get valid key
    let res = rtm
        .call(
            "rtm_ext_trie_blake2_256_ordered_root_version_1",
            &(trie).encode(),
        )
        .decode_vec();

    println!("{}", hex::encode(res));
}
