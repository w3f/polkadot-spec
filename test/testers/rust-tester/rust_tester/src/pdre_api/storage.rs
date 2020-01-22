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

// Input: prefix, key1, value1, key2, value2
pub fn ext_storage_clear_prefix(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let prefix = input.get(0);
    let key1 = input.get(1);
    let value1 = input.get(2);
    let key2 = input.get(3);
    let value2 = input.get(4);

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_set", &(key1, value1).encode());
    // Set key/value
    let _ = rtm.call("rtm_ext_storage_set", &(key2, value2).encode());

    // Clear value
    let _ = rtm.call("rtm_ext_storage_clear_prefix_version_1", &prefix.encode());

    // Check first key
    let res = rtm
        .call("rtm_ext_storage_get", &key1.encode())
        .decode_option();
    if key1.starts_with(prefix) {
        assert!(res.is_none());
    } else {
        let val = res.unwrap().decode_val();
        assert_eq!(val, value1);
        println!("{}", str(&val));
    }

    // Check second key
    let res = rtm
        .call("rtm_ext_storage_get", &key2.encode())
        .decode_option();
    if key2.starts_with(prefix) {
        assert!(res.is_none());
    } else {
        let val = res.unwrap().decode_val();
        assert_eq!(val, value2);
        println!("{}", str(&val));
    }
}