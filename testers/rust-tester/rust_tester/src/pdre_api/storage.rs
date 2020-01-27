use crate::pdre_api::utils::{Decoder, ParsedInput, Runtime};
use parity_scale_codec::Encode;

fn str<'a>(input: &'a [u8]) -> &'a str {
    std::str::from_utf8(input).unwrap()
}

pub fn ext_storage_get_version_1(input: ParsedInput) {
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

// TODO: assert in wasm, make sure returned length matches buffer length
pub fn ext_storage_read_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let key = input.get(0);
    let value = input.get(1);
    let offset = input.get_u32(2);
    let buffer_size = input.get_u32(3);

    // Get invalid key
    let mut res = rtm
        .call("rtm_ext_storage_read", &(key, offset, buffer_size).encode())
        .decode_val();
    assert_eq!(res, vec![0u8; buffer_size as usize]);

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_set", &(key, value).encode());

    // Get valid key
    let mut res = rtm
        .call("rtm_ext_storage_read", &(key, offset, buffer_size).encode())
        .decode_val();

    // Verify the return value includes the initial value (in regard to the offset)
    assert!(res.starts_with(&value[offset as usize ..]));
    // Verify the remaining values are all zeros
    assert_eq!(
        &res[value.len()..],
        vec![0u8; buffer_size as usize-value.len()].as_slice()
    );

    println!("{}", str(&res));
}

pub fn ext_storage_set_version_1(input: ParsedInput) {
    // TODO: Remove this and just keep the "get" test?
}

pub fn ext_storage_clear_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let key = input.get(0);
    let value = input.get(1);

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_set", &(key, value).encode());
    let _ = rtm.call("rtm_ext_storage_clear_version_1", &key.encode());

    // Get cleared value
    let res = rtm
        .call("rtm_ext_storage_get", &key.encode())
        .decode_option();
    assert!(res.is_none());
}

pub fn ext_storage_exists_version_1(input: ParsedInput) {
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

pub fn ext_storage_clear_prefix_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let prefix = input.get(0);
    let key1 = input.get(1);
    let value1 = input.get(2);
    let key2 = input.get(3);
    let value2 = input.get(4);

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_set", &(key1, value1).encode());
    let _ = rtm.call("rtm_ext_storage_set", &(key2, value2).encode());
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

pub fn ext_storage_root_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let key1 = input.get(0);
    let value1 = input.get(1);
    let key2 = input.get(2);
    let value2 = input.get(3);

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_set", &(key1, value1).encode());
    let _ = rtm.call("rtm_ext_storage_set", &(key2, value2).encode());

    // Get root
    let res = rtm
        .call("rtm_ext_storage_root_version_1", &[])
        .decode_val();

    println!("{}", hex::encode(res));
}

pub fn ext_storage_next_key_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let key1 = input.get(0);
    let value1 = input.get(1);
    let key2 = input.get(2);
    let value2 = input.get(3);
    let key3 = input.get(4);
    let value3 = input.get(5);

    // No next key available
    let res = rtm
        .call("rtm_ext_storage_next_key_version_1", &key1.encode())
        .decode_option();
    assert!(res.is_none());

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_set", &(key1, value1).encode());
    let _ = rtm.call("rtm_ext_storage_set", &(key2, value2).encode());
    let _ = rtm.call("rtm_ext_storage_set", &(key3, value3).encode());

    // Get next key
    let res = rtm
        .call("rtm_ext_storage_next_key_version_1", &key1.encode())
        .decode_option()
        .unwrap()
        .decode_val();
    assert_eq!(res, key2);

    let res = rtm
        .call("rtm_ext_storage_next_key_version_1", &key2.encode())
        .decode_option()
        .unwrap()
        .decode_val();
    assert_eq!(res, key3);

    // No next key available
    let res = rtm
        .call("rtm_ext_storage_next_key_version_1", &key3.encode())
        .decode_option();
    assert!(res.is_none());
}
