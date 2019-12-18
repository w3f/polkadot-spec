use crate::pdre_api::ParsedInput;
use super::utils::{Runtime, Decoder, StorageApi};

use parity_scale_codec::Encode;

fn str<'a>(input: &'a [u8]) -> &'a str {
    std::str::from_utf8(input).unwrap()
}

// Input: key, value
pub fn test_set_get_storage(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let key = input.get(0);
    let value = input.get(1);

    // Get invalid key
    let res = rtm
        .call("rtm_ext_get_allocated_storage", &key.encode())
        .decode_vec();
    assert_eq!(res, [0u8;0]);

    // Set key/value
    let _ = rtm.call("rtm_ext_set_storage", &(key, value).encode());

    // Get valid key
    let res = rtm
        .call("rtm_ext_get_allocated_storage", &key.encode())
        .decode_vec();
    assert_eq!(res, value);

    println!("{}", str(&res));
}

// Input: key, value, offset
pub fn test_set_get_storage_into(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let key = input.get(0);
    let value = input.get(1);
    let offset = std::str::from_utf8(input.get(2)).unwrap().parse::<usize>().unwrap();

    // Prepare for comparison, set the min required length
    let empty = if offset > value.len() {
        vec![0u8;0]
    } else {
        vec![0; value.len() - offset]
    };

    // Invalid access
    let res = rtm
        .call("rtm_ext_get_storage_into",&(key, &empty, offset as u32).encode())
        .decode_vec();
    assert_eq!(res, empty);

    // Set key/value
    let _ = rtm.call("rtm_ext_set_storage", &(key, value).encode());

    // Get key with offset
    let res = rtm
        .call("rtm_ext_get_storage_into",&(key, &empty, offset as u32).encode())
        .decode_vec();
    if offset > value.len() {
        assert_eq!(*res.as_slice(), [0u8;0]);
    } else {
        assert_eq!(*res.as_slice(), value[(offset as usize)..]);
    };

    println!("{}", str(&res));
}

// Input: key, value
pub fn test_exists_storage(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let key = input.get(0);
    let value = input.get(1);

    // Check invalid key
    let res = rtm
        .call("rtm_ext_exists_storage", &key.encode())
        .decode_u32();
    assert_eq!(res, 0);

    // Set key/value
    let _ = rtm.call("rtm_ext_set_storage", &(key, value).encode());


    // Check valid key
    let res = rtm
        .call("rtm_ext_exists_storage", &key.encode())
        .decode_u32();
    assert_eq!(res, 1);

    println!("true");
}

// Input: key, value
pub fn test_clear_storage(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let key = input.get(0);
    let value = input.get(1);

    // Set key/value
    let _ = rtm.call("rtm_ext_set_storage", &(key, value).encode());

    // Get valid key
    let res = rtm
        .call("rtm_ext_get_allocated_storage", &key.encode())
        .decode_vec();
    assert_eq!(res, value);

    // Clear key
    let _ = rtm.call("rtm_ext_clear_storage", &key.encode());

    // Get invalid key
    let res = rtm
        .call("rtm_ext_get_allocated_storage", &key.encode())
        .decode_vec();
    assert_eq!(res, [0u8;0]);
}

// Input: prefix, key1, value1, key2, value2
pub fn test_clear_prefix(input: ParsedInput) {
    let mut api = StorageApi::new();

    let prefix = input.get(0);
    let key1 = input.get(1);
    let value1 = input.get(2);
    let key2 = input.get(3);
    let value2 = input.get(4);

    // Set keys/values
    api.rtm_ext_set_storage(key1, value1);
    api.rtm_ext_set_storage(key2, value2);

    // Clear keys with specified prefix
    api.rtm_ext_clear_prefix(prefix);

    // Check deletions
    let res = api.rtm_ext_get_allocated_storage(key1);
    if key1.starts_with(prefix) {
        assert_eq!(res, [0u8;0]);
        println!("Key `{}` was deleted", str(key1));
    } else {
        assert_eq!(res, value1);
        println!("Key `{}` remains", str(key1));
    }

    let res = api.rtm_ext_get_allocated_storage(key2);
    if key2.starts_with(prefix) {
        assert_eq!(res, [0u8;0]);
        println!("Key `{}` was deleted", str(key2));
    } else {
        assert_eq!(res, value2);
        println!("Key `{}` remains", str(key2));
    }
}

pub fn test_allocate_storage() {
    let mut api = StorageApi::new();

    let address = api.rtm_ext_malloc((44 as u32).to_le());

    // TODO...

    api.rtm_ext_free(&address);
}

// Input: key1, value1, key2, value2
pub fn test_storage_root(input: ParsedInput) {
    let mut api = StorageApi::new();

    let key1 = input.get(0);
    let value1 = input.get(1);
    let key2 = input.get(2);
    let value2 = input.get(3);

    api.rtm_ext_set_storage(key1, value1);
    api.rtm_ext_set_storage(key2, value2);

    let root = api.rtm_ext_storage_root();
    println!("{}", hex::encode(root));
}

// Input: hash
pub fn test_storage_changes_root(input: ParsedInput) {
    let parent_hash_data = input.get(0);

    let mut api = StorageApi::new();
    let root = api.rtm_ext_storage_changes_root(&parent_hash_data);
    println!("{}", hex::encode(root));
}

// Input: key, value
pub fn test_set_get_local_storage(input: ParsedInput) {
    let mut api = StorageApi::new_with_offchain_context();

    let key = input.get(0);
    let value = input.get(1);

    // Test invalid persistant storage
    let res = api.rtm_ext_local_storage_get(1, key);
    assert_eq!(res, [0u8;0]);

    // Test valid persistant storage
    api.rtm_ext_local_storage_set(1, key, value);
    let res = api.rtm_ext_local_storage_get(1, key);
    assert_eq!(res.as_slice(), value);

    print!("{},", str(&res)); // Result of persistant storage

    // Test invalid local storage
    let res = api.rtm_ext_local_storage_get(2, key);
    assert_eq!(res, [0u8;0]);

    // Test valid local storage
    api.rtm_ext_local_storage_set(2, key, value);
    let res = api.rtm_ext_local_storage_get(2, key);
    assert_eq!(res.as_slice(), value);

    println!("{}", str(&res)); // Result of local storage

    // Invalid cross access
    // -> make sure keys set in persistant storage cannot be access by local storage (and vice-versa)
    let key1 = "somekey1".as_bytes();
    let value1 = "somevalue1".as_bytes();

    let key2 = "somekey2".as_bytes();
    let value2 = "somevalue2".as_bytes();

    api.rtm_ext_local_storage_set(1, key1, value1);
    api.rtm_ext_local_storage_set(2, key2, value2);

    let res = api.rtm_ext_local_storage_get(1, key2);
    assert_eq!(res, [0u8;0]);

    let res = api.rtm_ext_local_storage_get(2, key1);
    assert_eq!(res, [0u8;0]);
}

// Input: key, old_value, new_value
pub fn test_local_storage_compare_and_set(input: ParsedInput) {
    let mut api = StorageApi::new_with_offchain_context();

    let key = input.get(0);
    let old_value = input.get(1);
    let new_value = input.get(2);

    // Test invalid key
    let res = api.rtm_ext_local_storage_compare_and_set(1, key, old_value, new_value);
    assert_eq!(res, 1);

    api.rtm_ext_local_storage_set(1, key, old_value);

    // Test invalid value
    let res = api.rtm_ext_local_storage_compare_and_set(1, key, new_value, new_value);
    assert_eq!(res, 1);

    // Test valid value
    let res = api.rtm_ext_local_storage_compare_and_set(1, key, old_value, new_value);
    assert_eq!(res, 0);

    let res = api.rtm_ext_local_storage_get(1, key);
    assert_eq!(res, new_value);

    println!("{}", str(new_value));

    // Invalid cross access
    // -> make sure keys set in persistant storage cannot be access by local storage (and vice-versa)
    let key1 = "somekey1".as_bytes();
    let value1 = "somevalue1".as_bytes();

    let key2 = "somekey2".as_bytes();
    let value2 = "somevalue2".as_bytes();

    api.rtm_ext_local_storage_set(1, key1, value1);
    api.rtm_ext_local_storage_set(2, key2, value2);

    let res = api.rtm_ext_local_storage_compare_and_set(1, key2, value1, new_value);
    assert_eq!(res, 1);

    let res = api.rtm_ext_local_storage_compare_and_set(2, key1, value2, new_value);
    assert_eq!(res, 1);
}