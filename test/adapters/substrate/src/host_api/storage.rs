use crate::host_api::utils::{str, Decoder, ParsedInput, Runtime};
use parity_scale_codec::Encode;

pub fn test_storage_init() {
    let mut rtm = Runtime::new();

    // Compute and print storage root on init
    let res = rtm.call("rtm_ext_storage_root_version_1", &[]).decode_val();

    println!("{}", hex::encode(res));
}

pub fn ext_storage_set_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let key = input.get(0);
    let value = input.get(1);

    // Get invalid key
    let res = rtm
        .call("rtm_ext_storage_get_version_1", &key.encode())
        .decode_option();
    assert!(res.is_none());

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_set_version_1", &(key, value).encode());

    // Get valid key
    let res = rtm
        .call("rtm_ext_storage_get_version_1", &key.encode())
        .decode_option()
        .unwrap()
        .decode_val();
    assert_eq!(res, value);

    println!("{}", str(&res));
}

pub fn ext_storage_get_version_1(input: ParsedInput) {
    ext_storage_set_version_1(input)
}

pub fn ext_storage_read_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let key = input.get(0);
    let value = input.get(1);
    let offset = input.get_u32(2);
    let buffer_size = input.get_u32(3);

    // Get invalid key
    let res = rtm
        .call(
            "rtm_ext_storage_read_version_1",
            &(key, offset, buffer_size).encode(),
        )
        .decode_val();
    assert_eq!(res, vec![0u8; buffer_size as usize]);

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_set_version_1", &(key, value).encode());

    // Get valid key
    let res = rtm
        .call(
            "rtm_ext_storage_read_version_1",
            &(key, offset, buffer_size).encode(),
        )
        .decode_val();

    let offset = offset as usize;
    let buffer_size = buffer_size as usize;

    if offset < value.len() {
        // Make sure `to_compare` does not exceed the length of the actual value
        let mut to_compare;
        if offset + buffer_size > value.len() {
            to_compare = value[(offset)..value.len()].to_vec();
        } else {
            to_compare = value[(offset)..(offset + buffer_size)].to_vec();
        }

        // If the buffer is bigger than `to_compare`, fill the rest with zeroes
        while to_compare.len() < buffer_size as usize {
            to_compare.push(0);
        }

        assert_eq!(res, to_compare);
    } else {
        assert_eq!(res, vec![0; buffer_size])
    }

    println!("{}", str(&res).trim_matches(char::from(0)));
}

pub fn ext_storage_clear_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let key = input.get(0);
    let value = input.get(1);

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_set_version_1", &(key, value).encode());
    let _ = rtm.call("rtm_ext_storage_clear_version_1", &key.encode());

    // Get cleared value
    let res = rtm
        .call("rtm_ext_storage_get_version_1", &key.encode())
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
    let _ = rtm.call("rtm_ext_storage_set_version_1", &(key, value).encode());

    // Check if key exists
    let res = rtm
        .call("rtm_ext_storage_exists_version_1", &(key).encode())
        .decode_bool();
    assert_eq!(res, true);
    println!("true");
}

pub fn ext_storage_clear_prefix_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let prefix = input.get(0);
    let key1 = input.get(1);
    let value1 = input.get(2);
    let key2 = input.get(3);
    let value2 = input.get(4);

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_set_version_1", &(key1, value1).encode());
    let _ = rtm.call("rtm_ext_storage_set_version_1", &(key2, value2).encode());
    let _ = rtm.call("rtm_ext_storage_clear_prefix_version_1", &prefix.encode());

    // Check first key
    let res = rtm
        .call("rtm_ext_storage_get_version_1", &key1.encode())
        .decode_option();
    if key1.starts_with(prefix) {
        assert!(res.is_none());
    } else {
        let val = res.unwrap().decode_val();
        assert_eq!(val, value1);
    }

    // Check second key
    let res = rtm
        .call("rtm_ext_storage_get_version_1", &key2.encode())
        .decode_option();
    if key2.starts_with(prefix) {
        assert!(res.is_none());
    } else {
        let val = res.unwrap().decode_val();
        assert_eq!(val, value2);
    }
}

pub fn ext_storage_root_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let key1 = input.get(0);
    let value1 = input.get(1);
    let key2 = input.get(2);
    let value2 = input.get(3);

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_set_version_1", &(key1, value1).encode());
    let _ = rtm.call("rtm_ext_storage_set_version_1", &(key2, value2).encode());

    // Get root
    let res = rtm.call("rtm_ext_storage_root_version_1", &[]).decode_val();

    println!("{}", hex::encode(res));
}

pub fn ext_storage_next_key_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let key1 = input.get(0);
    let value1 = input.get(1);
    let key2 = input.get(2);
    let value2 = input.get(3);

    // Keep track of the ordering of the keys
    let mut track = vec![];
    track.push(key1);
    track.push(key2);
    track.sort();

    // No next key available
    let res = rtm
        .call("rtm_ext_storage_next_key_version_1", &key1.encode())
        .decode_option();
    assert!(res.is_none());

    let res = rtm
        .call("rtm_ext_storage_next_key_version_1", &key2.encode())
        .decode_option();
    assert!(res.is_none());

    // Set key/value
    let _ = rtm.call("rtm_ext_storage_set_version_1", &(key1, value1).encode());
    let _ = rtm.call("rtm_ext_storage_set_version_1", &(key2, value2).encode());

    // Try to read next key
    let res = rtm
        .call("rtm_ext_storage_next_key_version_1", &key1.encode())
        .decode_option();
    if key1 == track[0] {
        assert_eq!(res.unwrap().decode_val(), key2);
        println!("{}", str(&key2));
    } else {
        assert!(res.is_none());
    }

    // Try to read next key
    let res = rtm
        .call("rtm_ext_storage_next_key_version_1", &key2.encode())
        .decode_option();
    if key2 == track[0] {
        assert_eq!(res.unwrap().decode_val(), key1);
        println!("{}", str(&key1));
    } else {
        assert!(res.is_none());
    }
}
