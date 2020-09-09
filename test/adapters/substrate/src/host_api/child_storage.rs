use crate::host_api::utils::{str, Decoder, ParsedInput, Runtime};
use parity_scale_codec::Encode;

pub fn ext_storage_child_set_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key1 = input.get(0);
    let child_key2 = input.get(1);
    let child_definition = input.get(2);
    let child_type = input.get_u32(3);
    let key = input.get(4);
    let value = input.get(5);

    // Get invalid key
    let res = rtm
        .call(
            "rtm_ext_storage_child_get_version_1",
            &(child_key1, child_definition, child_type, key).encode(),
        )
        .decode_ovec();
    assert!(res.is_none());

    // Set key/value
    let _ = rtm.call(
        "rtm_ext_storage_child_set_version_1",
        &(child_key1, child_definition, child_type, key, value).encode(),
    );

    // Get invalid key (wrong child key)
    let res = rtm
        .call(
            "rtm_ext_storage_child_get_version_1",
            &(child_key2, child_definition, child_type, key).encode(),
        )
        .decode_ovec();
    assert!(res.is_none());

    // Get valid key
    let res = rtm
        .call(
            "rtm_ext_storage_child_get_version_1",
            &(child_key1, child_definition, child_type, key).encode(),
        )
        .decode_ovec()
        .unwrap();
    assert_eq!(res, value);

    println!("{}", str(&res));
}

pub fn ext_storage_child_get_version_1(input: ParsedInput) {
    ext_storage_child_set_version_1(input)
}

pub fn ext_storage_child_read_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key1 = input.get(0);
    let child_key2 = input.get(1);
    let child_definition = input.get(2);
    let child_type = input.get_u32(3);
    let key = input.get(4);
    let value = input.get(5);
    let offset = input.get_u32(6);
    let buffer_size = input.get_u32(7);

    // Get invalid key
    let res = rtm
        .call(
            "rtm_ext_storage_child_read_version_1",
            &(
                child_key1,
                child_definition,
                child_type,
                key,
                offset,
                buffer_size,
            )
                .encode(),
        )
        .decode_vec();
    assert_eq!(res, vec![0u8; buffer_size as usize]);

    // Set key/value
    let _ = rtm.call(
        "rtm_ext_storage_child_set_version_1",
        &(child_key1, child_definition, child_type, key, value).encode(),
    );

    // Get invalid key (different child storage)
    let res = rtm
        .call(
            "rtm_ext_storage_child_read_version_1",
            &(
                child_key2,
                child_definition,
                child_type,
                key,
                offset,
                buffer_size,
            )
            .encode(),
        )
        .decode_vec();
    assert_eq!(res, vec![0u8; buffer_size as usize]);

    // Get valid key
    let res = rtm
        .call(
            "rtm_ext_storage_child_read_version_1",
            &(
                child_key1,
                child_definition,
                child_type,
                key,
                offset,
                buffer_size,
            )
                .encode(),
        )
        .decode_vec();

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

pub fn ext_storage_child_clear_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key1 = input.get(0);
    let child_key2 = input.get(1);
    let child_definition = input.get(2);
    let child_type = input.get_u32(3);
    let key = input.get(4);
    let value = input.get(5);

    // Set key/value
    let _ = rtm.call(
        "rtm_ext_storage_child_set_version_1",
        &(child_key1, child_definition, child_type, key, value).encode(),
    );

    // Clear value (other child key)
    let _ = rtm.call(
        "rtm_ext_storage_child_clear_version_1",
        &(child_key2, child_definition, child_type, key).encode(),
    );

    // Get valid key
    let res = rtm
        .call(
            "rtm_ext_storage_child_get_version_1",
            &(child_key1, child_definition, child_type, key).encode(),
        )
        .decode_ovec()
        .unwrap();
    assert_eq!(res, value);

    // Clear value
    let _ = rtm.call(
        "rtm_ext_storage_child_clear_version_1",
        &(child_key1, child_definition, child_type, key).encode(),
    );

    // Get cleared value
    let res = rtm
        .call(
            "rtm_ext_storage_child_get_version_1",
            &(child_key1, child_definition, child_type, key).encode(),
        )
        .decode_ovec();
    assert!(res.is_none());
}

pub fn ext_storage_child_storage_kill_version_1(input: ParsedInput) {
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
    let _ = rtm.call(
        "rtm_ext_storage_child_set_version_1",
        &(child_key1, child_definition, child_type, key1, value1).encode(),
    );

    // Set key/value
    let _ = rtm.call(
        "rtm_ext_storage_child_set_version_1",
        &(child_key1, child_definition, child_type, key2, value2).encode(),
    );

    // Kill child (different child key)
    let _ = rtm.call(
        "rtm_ext_storage_child_storage_kill_version_1",
        &(child_key2, child_definition, child_type).encode(),
    );

    // Get valid value
    let res = rtm
        .call(
            "rtm_ext_storage_child_get_version_1",
            &(child_key1, child_definition, child_type, key1).encode(),
        )
        .decode_ovec()
        .unwrap();
    assert_eq!(res, value1);

    // Get valid value
    let res = rtm
        .call(
            "rtm_ext_storage_child_get_version_1",
            &(child_key1, child_definition, child_type, key2).encode(),
        )
        .decode_ovec()
        .unwrap();
    assert_eq!(res, value2);

    // Kill child
    let _ = rtm.call(
        "rtm_ext_storage_child_storage_kill_version_1",
        &(child_key1, child_definition, child_type).encode(),
    );

    // Get invalid killed value
    let res = rtm
        .call(
            "rtm_ext_storage_child_get_version_1",
            &(child_key1, child_definition, child_type, key1).encode(),
        )
        .decode_ovec();
    assert!(res.is_none());

    // Get invalid killed value
    let res = rtm
        .call(
            "rtm_ext_storage_child_get_version_1",
            &(child_key1, child_definition, child_type, key2).encode(),
        )
        .decode_ovec();
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
        .call(
            "rtm_ext_storage_child_exists_version_1",
            &(child_key1, child_definition, child_type, key).encode(),
        )
        .decode_bool();
    assert_eq!(res, false);

    // Set key/value
    let _ = rtm.call(
        "rtm_ext_storage_child_set_version_1",
        &(child_key1, child_definition, child_type, key, value).encode(),
    );

    // Check if key exists (invalid, different child key)
    let res = rtm
        .call(
            "rtm_ext_storage_child_exists_version_1",
            &(child_key2, child_definition, child_type, key).encode(),
        )
        .decode_bool();
    assert_eq!(res, false);

    // Check if key exists
    let res = rtm
        .call(
            "rtm_ext_storage_child_exists_version_1",
            &(child_key1, child_definition, child_type, key).encode(),
        )
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
    let _ = rtm.call(
        "rtm_ext_storage_child_set_version_1",
        &(child_key1, child_definition, child_type, key1, value1).encode(),
    );

    // Set key/value
    let _ = rtm.call(
        "rtm_ext_storage_child_set_version_1",
        &(child_key1, child_definition, child_type, key2, value2).encode(),
    );

    // Clear value (different key)
    let _ = rtm.call(
        "rtm_ext_storage_child_clear_prefix_version_1",
        &(child_key2, child_definition, child_type, prefix).encode(),
    );

    // Clear value
    let _ = rtm.call(
        "rtm_ext_storage_child_clear_prefix_version_1",
        &(child_key1, child_definition, child_type, prefix).encode(),
    );

    // Check first key
    let res = rtm
        .call(
            "rtm_ext_storage_child_get_version_1",
            &(child_key1, child_definition, child_type, key1).encode(),
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
            "rtm_ext_storage_child_get_version_1",
            &(child_key1, child_definition, child_type, key2).encode(),
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

pub fn ext_storage_child_root_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let child_key1 = input.get(0);
    let _child_key2 = input.get(1);
    let child_definition = input.get(2);
    let child_type = input.get_u32(3);
    let key1 = input.get(4);
    let value1 = input.get(5);
    let key2 = input.get(6);
    let value2 = input.get(7);

    // Set key/value
    let _ = rtm.call(
        "rtm_ext_storage_child_set_version_1",
        &(child_key1, child_definition, child_type, key1, value1).encode(),
    );

    // Set key/value
    let _ = rtm.call(
        "rtm_ext_storage_child_set_version_1",
        &(child_key1, child_definition, child_type, key2, value2).encode(),
    );

    // Set key/value (different child key)
    /* TODO: Inserting this will cause the root hash to change.
                Wait for new changes before testing again.
    let _ = rtm.call("rtm_ext_storage_child_set_version_1", &(
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
        .decode_vec();

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

    // Keep track of the ordering of the keys
    let mut track = vec![];
    track.push(key1);
    track.push(key2);
    track.sort();

    // No next key available
    let res = rtm
        .call(
            "rtm_ext_storage_child_next_key_version_1",
            &(child_key1, child_definition, child_type, key1).encode(),
        )
        .decode_ovec();
    assert!(res.is_none());

    // Set key/value
    let _ = rtm.call(
        "rtm_ext_storage_child_set_version_1",
        &(child_key1, child_definition, child_type, key1, value1).encode(),
    );
    let _ = rtm.call(
        "rtm_ext_storage_child_set_version_1",
        &(child_key1, child_definition, child_type, key2, value2).encode(),
    );

    // Try to read next key
    let res = rtm
        .call(
            "rtm_ext_storage_child_next_key_version_1",
            &(child_key1, child_definition, child_type, key1).encode(),
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
            "rtm_ext_storage_child_next_key_version_1",
            &(child_key1, child_definition, child_type, key2).encode(),
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
            "rtm_ext_storage_child_next_key_version_1",
            &(child_key2, child_definition, child_type, key1).encode(),
        )
        .decode_ovec();
    assert!(res.is_none());

    // Get invalid next key (different child key)
    let res = rtm
        .call(
            "rtm_ext_storage_child_next_key_version_1",
            &(child_key2, child_definition, child_type, key2).encode(),
        )
        .decode_ovec();
    assert!(res.is_none());
}
