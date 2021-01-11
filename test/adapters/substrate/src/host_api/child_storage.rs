use crate::host_api::utils::{str, Decoder, ParsedInput, Runtime};
use parity_scale_codec::Encode;

pub fn ext_default_child_storage_set_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key1 = input.get(0);
    let child_key2 = input.get(1);
    let key = input.get(2);
    let value = input.get(3);

    // Get invalid key
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_get_version_1",
            &(child_key1, key).encode(),
        )
        .decode_ovec();
    assert!(res.is_none());

    // Set key/value
    let _ = rtm.call(
        "rtm_ext_default_child_storage_set_version_1",
        &(child_key1, key, value).encode(),
    );

    // Get invalid key (wrong child key)
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_get_version_1",
            &(child_key2, key).encode(),
        )
        .decode_ovec();
    assert!(res.is_none());

    // Get valid key
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_get_version_1",
            &(child_key1, key).encode(),
        )
        .decode_ovec()
        .unwrap();
    assert_eq!(res, value);

    println!("{}", str(&res));
}

pub fn ext_default_child_storage_get_version_1(input: ParsedInput) {
    ext_default_child_storage_set_version_1(input)
}

pub fn ext_default_child_storage_read_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key1 = input.get(0);
    let child_key2 = input.get(1);
    let key = input.get(2);
    let value = input.get(3);
    let offset = input.get_u32(4);
    let buffer_size = input.get_u32(5);

    // Get invalid key
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_read_version_1",
            &(
                child_key1,
                key,
                offset,
                buffer_size,
            )
            .encode(),
        )
        .decode_ovec();
    assert!(res.is_none());

    // Set key/value
    let _ = rtm.call(
        "rtm_ext_default_child_storage_set_version_1",
        &(child_key1, key, value).encode(),
    );

    // Get invalid key (different child storage)
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_read_version_1",
            &(
                child_key2,
                key,
                offset,
                buffer_size,
            )
            .encode(),
        )
        .decode_ovec();
    assert!(res.is_none());

    // Get valid key
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_read_version_1",
            &(
                child_key1,
                key,
                offset,
                buffer_size,
            )
                .encode(),
        )
        .decode_ovec()
        .unwrap();

    let offset = offset as usize;
    let buffer_size = buffer_size as usize;

    if offset < value.len() {
        let end = std::cmp::min(offset + buffer_size, value.len());

        assert_eq!(res, value[offset..end].to_vec());
    } else {
        assert!(res.is_empty());
    }

    println!("{}", str(&res));
}

pub fn ext_default_child_storage_clear_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key1 = input.get(0);
    let child_key2 = input.get(1);
    let key = input.get(2);
    let value = input.get(3);

    // Set key/value
    let _ = rtm.call(
        "rtm_ext_default_child_storage_set_version_1",
        &(child_key1, key, value).encode(),
    );

    // Clear value (other child key)
    let _ = rtm.call(
        "rtm_ext_default_child_storage_clear_version_1",
        &(child_key2, key).encode(),
    );

    // Get valid key
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_get_version_1",
            &(child_key1, key).encode(),
        )
        .decode_ovec()
        .unwrap();
    assert_eq!(res, value);

    // Clear value
    let _ = rtm.call(
        "rtm_ext_default_child_storage_clear_version_1",
        &(child_key1, key).encode(),
    );

    // Get cleared value
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_get_version_1",
            &(child_key1, key).encode(),
        )
        .decode_ovec();
    assert!(res.is_none());
}

pub fn ext_default_child_storage_storage_kill_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key1 = input.get(0);
    let child_key2 = input.get(1);
    let key1 = input.get(2);
    let value1 = input.get(3);
    let key2 = input.get(4);
    let value2 = input.get(5);

    // Set key/value
    let _ = rtm.call(
        "rtm_ext_default_child_storage_set_version_1",
        &(child_key1, key1, value1).encode(),
    );

    // Set key/value
    let _ = rtm.call(
        "rtm_ext_default_child_storage_set_version_1",
        &(child_key1, key2, value2).encode(),
    );

    // Kill child (different child key)
    let _ = rtm.call(
        "rtm_ext_default_child_storage_storage_kill_version_1",
        &(child_key2).encode(),
    );

    // Get valid value
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_get_version_1",
            &(child_key1, key1).encode(),
        )
        .decode_ovec()
        .unwrap();
    assert_eq!(res, value1);

    // Get valid value
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_get_version_1",
            &(child_key1, key2).encode(),
        )
        .decode_ovec()
        .unwrap();
    assert_eq!(res, value2);

    // Kill child
    let _ = rtm.call(
        "rtm_ext_default_child_storage_storage_kill_version_1",
        &(child_key1).encode(),
    );

    // Get invalid killed value
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_get_version_1",
            &(child_key1, key1).encode(),
        )
        .decode_ovec();
    assert!(res.is_none());

    // Get invalid killed value
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_get_version_1",
            &(child_key1, key2).encode(),
        )
        .decode_ovec();
    assert!(res.is_none());
}

pub fn ext_default_child_storage_exists_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key1 = input.get(0);
    let child_key2 = input.get(1);
    let key = input.get(2);
    let value = input.get(3);

    // Check if key exists (invalid)
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_exists_version_1",
            &(child_key1, key).encode(),
        )
        .decode_bool();
    assert_eq!(res, false);

    // Set key/value
    let _ = rtm.call(
        "rtm_ext_default_child_storage_set_version_1",
        &(child_key1, key, value).encode(),
    );

    // Check if key exists (invalid, different child key)
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_exists_version_1",
            &(child_key2, key).encode(),
        )
        .decode_bool();
    assert_eq!(res, false);

    // Check if key exists
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_exists_version_1",
            &(child_key1, key).encode(),
        )
        .decode_bool();
    assert_eq!(res, true);

    println!("true");
}

pub fn ext_default_child_storage_clear_prefix_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key1 = input.get(0);
    let child_key2 = input.get(1);
    let prefix = input.get(2);
    let key1 = input.get(3);
    let value1 = input.get(4);
    let key2 = input.get(5);
    let value2 = input.get(6);

    // Set key/value
    let _ = rtm.call(
        "rtm_ext_default_child_storage_set_version_1",
        &(child_key1, key1, value1).encode(),
    );

    // Set key/value
    let _ = rtm.call(
        "rtm_ext_default_child_storage_set_version_1",
        &(child_key1, key2, value2).encode(),
    );

    // Clear value (different key)
    let _ = rtm.call(
        "rtm_ext_default_child_storage_clear_prefix_version_1",
        &(child_key2, prefix).encode(),
    );

    // Clear value
    let _ = rtm.call(
        "rtm_ext_default_child_storage_clear_prefix_version_1",
        &(child_key1, prefix).encode(),
    );

    // Check first key
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_get_version_1",
            &(child_key1, key1).encode(),
        )
        .decode_ovec();
    if key1.starts_with(prefix) {
        assert!(res.is_none());
    } else {
        let val = res.unwrap();
        assert_eq!(val, value1);
        println!("{}", str(&val));
    }

    // Check second key
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_get_version_1",
            &(child_key1, key2).encode(),
        )
        .decode_ovec();
    if key2.starts_with(prefix) {
        assert!(res.is_none());
    } else {
        let val = res.unwrap();
        assert_eq!(val, value2);
        println!("{}", str(&val));
    }
}

pub fn ext_default_child_storage_root_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key1 = input.get(0);
    let child_key2 = input.get(1);
    let key1 = input.get(2);
    let value1 = input.get(3);
    let key2 = input.get(4);
    let value2 = input.get(5);

    // Set key1 to value1
    let _ = rtm.call(
        "rtm_ext_default_child_storage_set_version_1",
        &(child_key1, key1, value1).encode(),
    );

    // Set key2 to value2
    let _ = rtm.call(
        "rtm_ext_default_child_storage_set_version_1",
        &(child_key1, key2, value2).encode(),
    );

    // Set key1 to value2 (different child key)
    let _ = rtm.call(
        "rtm_ext_default_child_storage_set_version_1",
        &(child_key2, key1, value2).encode()
    );

    // Set key2 to value1 (different child key)
    let _ = rtm.call(
        "rtm_ext_default_child_storage_set_version_1",
        &(child_key2, key2, value1).encode()
    );

    // Get root
    let res = rtm
        .call("rtm_ext_default_child_storage_root_version_1", &child_key1.encode())
        .decode_vec();

    println!("{}", hex::encode(res));
}

pub fn ext_default_child_storage_next_key_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key1 = input.get(0);
    let child_key2 = input.get(1);
    let key1 = input.get(2);
    let value1 = input.get(3);
    let key2 = input.get(4);
    let value2 = input.get(5);

    // Keep track of the ordering of the keys
    let mut track = vec![];
    track.push(key1);
    track.push(key2);
    track.sort();

    // No next key available
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_next_key_version_1",
            &(child_key1, key1).encode(),
        )
        .decode_ovec();
    assert!(res.is_none());

    // Set key/value
    let _ = rtm.call(
        "rtm_ext_default_child_storage_set_version_1",
        &(child_key1, key1, value1).encode(),
    );
    let _ = rtm.call(
        "rtm_ext_default_child_storage_set_version_1",
        &(child_key1, key2, value2).encode(),
    );

    // Try to read next key
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_next_key_version_1",
            &(child_key1, key1).encode(),
        )
        .decode_ovec();
    if key1 == track[0] {
        assert_eq!(res.unwrap(), key2);
        println!("{}", str(&key2));
    } else {
        assert!(res.is_none());
    }

    // Try to read next key
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_next_key_version_1",
            &(child_key1, key2).encode(),
        )
        .decode_ovec();
    if key2 == track[0] {
        assert_eq!(res.unwrap(), key1);
        println!("{}", str(&key1));
    } else {
        assert!(res.is_none());
    }

    // Get invalid next key (different child key)
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_next_key_version_1",
            &(child_key2, key1).encode(),
        )
        .decode_ovec();
    assert!(res.is_none());

    // Get invalid next key (different child key)
    let res = rtm
        .call(
            "rtm_ext_default_child_storage_next_key_version_1",
            &(child_key2, key2).encode(),
        )
        .decode_ovec();
    assert!(res.is_none());
}
