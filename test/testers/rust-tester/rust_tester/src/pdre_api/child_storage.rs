use crate::pdre_api::utils::{Decoder, ParsedInput, Runtime};
use parity_scale_codec::Encode;

fn str<'a>(input: &'a [u8]) -> &'a str {
    std::str::from_utf8(input).unwrap()
}

pub fn ext_storage_child_get_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key1 = input.get(0);
    let child_key2 = input.get(1);
    let child_definition = input.get(2);
    let child_type = input.get_u32(3);
    let key = input.get(4);
    let value = input.get(5);

    // Get invalid key
    let res = rtm
        .call("rtm_ext_storage_child_get", &(
            child_key1,
            child_definition,
            child_type,
            key,
        ).encode())
        .decode_option();
    assert!(res.is_none());

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_child_set", &(
        child_key1,
        child_definition,
        child_type,
        key,
        value
    ).encode());

    // Get invalid key (wrong child key)
    let mut res = rtm
        .call("rtm_ext_storage_child_get", &(
            child_key2,
            child_definition,
            child_type,
            key,
        ).encode())
        .decode_option();
    assert!(res.is_none());

    // Get valid key
    let mut res = rtm
        .call("rtm_ext_storage_child_get", &(
            child_key1,
            child_definition,
            child_type,
            key,
        ).encode())
        .decode_option()
        .unwrap()
        .decode_val();
    assert_eq!(res, value);

    println!("{}", str(&res));
}

pub fn ext_storage_child_read_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key = input.get(0);
    let child_definition = input.get(1);
    let child_type = input.get_u32(2);
    let key = input.get(3);
    let value = input.get(4);
    let offset = input.get_u32(5);
    let buffer_size = input.get_u32(6);

    // Get invalid key
    let mut res = rtm
        .call("rtm_ext_storage_child_read", &(
            child_key,
            child_definition,
            child_type,
            key,
            offset,
            buffer_size
        ).encode())
        .decode_val();
    assert_eq!(res, vec![0u8; buffer_size as usize]);

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_child_set", &(
        child_key,
        child_definition,
        child_type,
        key,
        value
    ).encode());

    // Get valid key
    let mut res = rtm
        .call("rtm_ext_storage_child_read", &(
            child_key,
            child_definition,
            child_type,
            key,
            offset,
            buffer_size
        ).encode())
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

// TODO
pub fn ext_storage_set_version_1(input: ParsedInput) {
    // TODO: Remove this and just keep the "get" test?
}

pub fn ext_storage_child_clear_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key1 = input.get(0);
    let child_key2 = input.get(1);
    let child_definition = input.get(2);
    let child_type = input.get_u32(3);
    let key = input.get(4);
    let value = input.get(5);

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_child_set", &(
        child_key1,
        child_definition,
        child_type,
        key,
        value
    ).encode());

    // Clear value (other child key)
    let _ = rtm.call("rtm_ext_storage_child_clear_version_1", &(
        child_key2,
        child_definition,
        child_type,
        key,
    ).encode());

    // Get valid key
    let mut res = rtm
        .call("rtm_ext_storage_child_get", &(
            child_key1,
            child_definition,
            child_type,
            key,
        ).encode())
        .decode_option()
        .unwrap()
        .decode_val();
    assert_eq!(res, value);

    // Clear value
    let _ = rtm.call("rtm_ext_storage_child_clear_version_1", &(
        child_key1,
        child_definition,
        child_type,
        key,
    ).encode());

    // Get cleared value
    let mut res = rtm
        .call("rtm_ext_storage_child_get", &(
            child_key1,
            child_definition,
            child_type,
            key,
        ).encode())
        .decode_option();
    assert!(res.is_none());
}

pub fn ext_storage_child_storage_kill_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key = input.get(0);
    let child_definition = input.get(1);
    let child_type = input.get_u32(2);
    let key1 = input.get(3);
    let value1 = input.get(4);
    let key2 = input.get(5);
    let value2 = input.get(6);

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_child_set", &(
        child_key,
        child_definition,
        child_type,
        key1,
        value1
    ).encode());

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_child_set", &(
        child_key,
        child_definition,
        child_type,
        key2,
        value2
    ).encode());

    // Kill child
    let _ = rtm.call("rtm_ext_storage_child_storage_kill_version_1", &(
        child_key,
        child_definition,
        child_type,
    ).encode());

    // Get killed value
    let mut res = rtm
        .call("rtm_ext_storage_child_get", &(
            child_key,
            child_definition,
            child_type,
            key1,
        ).encode())
        .decode_option();
    assert!(res.is_none());

    // Get killed value
    let mut res = rtm
        .call("rtm_ext_storage_child_get", &(
            child_key,
            child_definition,
            child_type,
            key2,
        ).encode())
        .decode_option();
    assert!(res.is_none());
}

pub fn ext_storage_child_exists_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key1 = input.get(0);
    let child_key2 = input.get(1);
    let child_definition = input.get(2);
    let child_type = input.get_u32(3);
    let key = input.get(4);
    let value = input.get(5);

    // Check if key exists (invalid)
    let res = rtm
        .call("rtm_ext_storage_child_exists_version_1", &(
            child_key1,
            child_definition,
            child_type,
            key
        ).encode())
        .decode_bool();
    assert_eq!(res, false);

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_child_set", &(
        child_key1,
        child_definition,
        child_type,
        key,
        value
    ).encode());

    // Check if key exists (invalid, different child key)
    let res = rtm
        .call("rtm_ext_storage_child_exists_version_1", &(
            child_key2,
            child_definition,
            child_type,
            key
        ).encode())
        .decode_bool();
    assert_eq!(res, false);

    // Check if key exists
    let res = rtm
        .call("rtm_ext_storage_child_exists_version_1", &(
            child_key1,
            child_definition,
            child_type,
            key
        ).encode())
        .decode_bool();
    assert_eq!(res, true);

    println!("true");
}

pub fn ext_storage_child_clear_prefix_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key1 = input.get(0);
    let child_key2 = input.get(1);
    let child_definition = input.get(2);
    let child_type = input.get_u32(3);
    let prefix = input.get(4);
    let key1 = input.get(5);
    let value1 = input.get(6);
    let key2 = input.get(7);
    let value2 = input.get(8);

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_child_set", &(
        child_key1,
        child_definition,
        child_type,
        key1,
        value1
    ).encode());

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_child_set", &(
        child_key1,
        child_definition,
        child_type,
        key2,
        value2
    ).encode());

    // Clear value (different key)
    let _ = rtm.call("rtm_ext_storage_child_clear_prefix_version_1", &(
        child_key2,
        child_definition,
        child_type,
        prefix
    ).encode());

    // Clear value
    let _ = rtm.call("rtm_ext_storage_child_clear_prefix_version_1", &(
        child_key1,
        child_definition,
        child_type,
        prefix
    ).encode());

    // Check first key
    let res = rtm
        .call("rtm_ext_storage_child_get", &(
            child_key1,
            child_definition,
            child_type,
            key1
        ).encode())
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
        .call("rtm_ext_storage_child_get", &(
            child_key1,
            child_definition,
            child_type,
            key2
        ).encode())
        .decode_option();
    if key2.starts_with(prefix) {
        assert!(res.is_none());
    } else {
        let val = res.unwrap().decode_val();
        assert_eq!(val, value2);
        println!("{}", str(&val));
    }
}

pub fn ext_storage_child_root_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key1 = input.get(0);
    let child_key2 = input.get(1);
    let child_definition = input.get(2);
    let child_type = input.get_u32(3);
    let key1 = input.get(4);
    let value1 = input.get(5);
    let key2 = input.get(6);
    let value2 = input.get(7);

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_child_set", &(
        child_key1,
        child_definition,
        child_type,
        key1,
        value1
    ).encode());

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_child_set", &(
        child_key1,
        child_definition,
        child_type,
        key2,
        value2
    ).encode());

    // Set key/value (different child key)
    /* TODO: Inserting this will cause the root hash to change.
                Wait for new changes before testing again.
    let _ = rtm.call("rtm_ext_storage_child_set", &(
        child_key2,
        child_definition,
        child_type,
        key2,
        value1
    ).encode());
    */

    // Get root
    let res = rtm
        .call("rtm_ext_storage_child_root_version_1", &child_key1.encode())
        .decode_val();

    println!("{}", hex::encode(res));
}

pub fn ext_storage_child_next_key_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key1 = input.get(0);
    let child_key2 = input.get(1);
    let child_definition = input.get(2);
    let child_type = input.get_u32(3);
    let key1 = input.get(4);
    let value1 = input.get(5);
    let key2 = input.get(6);
    let value2 = input.get(7);

    // No next key available
    let res = rtm
        .call("rtm_ext_storage_child_next_key_version_1", &(
            child_key1,
            child_definition,
            child_type,
            key1
        ).encode())
        .decode_option();
    assert!(res.is_none());

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_child_set", &(
        child_key1,
        child_definition,
        child_type,
        key1,
        value1
    ).encode());
    let _ = rtm.call("rtm_ext_storage_child_set", &(
        child_key1,
        child_definition,
        child_type,
        key2,
        value2
    ).encode());

    // Get valid next key
    let res = rtm
        .call("rtm_ext_storage_child_next_key_version_1", &(
            child_key1,
            child_definition,
            child_type,
            key1
        ).encode())
        .decode_option()
        .unwrap()
        .decode_val();
    assert_eq!(res, key2);

    // Get valid next key (same key, second try)
    let res = rtm
        .call("rtm_ext_storage_child_next_key_version_1", &(
            child_key1,
            child_definition,
            child_type,
            key1
        ).encode())
        .decode_option()
        .unwrap()
        .decode_val();
    assert_eq!(res, key2);

    // Get invalid next key (different child key)
    let res = rtm
        .call("rtm_ext_storage_child_next_key_version_1", &(
            child_key2,
            child_definition,
            child_type,
            key1
        ).encode())
        .decode_option();
    assert!(res.is_none());

    // Get invalid next keyj
    let res = rtm
        .call("rtm_ext_storage_child_next_key_version_1", &(
            child_key1,
            child_definition,
            child_type,
            key2
        ).encode())
        .decode_option();
    assert!(res.is_none());
}
