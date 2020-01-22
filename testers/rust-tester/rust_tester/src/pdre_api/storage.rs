use crate::pdre_api::utils::{Decoder, ParsedInput, Runtime};
use parity_scale_codec::Encode;

fn str<'a>(input: &'a [u8]) -> &'a str {
    std::str::from_utf8(input).unwrap()
}

// Input: key, value
pub fn ext_storage_get(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let key = input.get(0);
    let value = input.get(1);

    // Get invalid key
    let res = rtm
        .call("rtm_ext_storage_get", &key.encode())
        .decode_option();
    assert!(res.is_none());

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_set", &(key, value).encode());

    // Get valid key
    let mut res = rtm
        .call("rtm_ext_storage_get", &key.encode())
        .decode_option()
        .unwrap()
        .decode_val();
    assert_eq!(res, value);

    println!("{}", str(&res));
}

// Input: key, value
pub fn ext_storage_set(input: ParsedInput) {
    // TODO
}

// Input: key, value
pub fn ext_storage_clear(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let key = input.get(0);
    let value = input.get(1);

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_set", &(key, value).encode());

    // Clear value
    let _ = rtm.call("rtm_ext_storage_clear_version_1", &key.encode());

    // Get cleared value
    let res = rtm
        .call("rtm_ext_storage_get", &key.encode())
        .decode_option();
    assert!(res.is_none());
}

// Input: key, value
pub fn ext_storage_exists(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let key = input.get(0);
    let value = input.get(1);

    // Check if key exists (invalid)
    let res = rtm
        .call("rtm_ext_storage_exists_version_1", &(key).encode())
        .decode_bool();
    assert_eq!(res, false);

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_set", &(key, value).encode());

    // Check if key exists
    let res = rtm
        .call("rtm_ext_storage_exists_version_1", &(key).encode())
        .decode_bool();
    assert_eq!(res, true);
}