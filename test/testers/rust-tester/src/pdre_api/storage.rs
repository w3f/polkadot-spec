use super::utils::StorageApi;
use super::ParsedInput;
use parity_scale_codec::{Encode, Decode};

fn str<'a>(input: &'a [u8]) -> &'a str {
    std::str::from_utf8(input).unwrap()
}

// Input: key, value
pub fn test_set_get_storage(input: ParsedInput) {
    let mut api = StorageApi::new();

    let key = input.get(0);
    let value = input.get(1);

    // Get invalid key
    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_storage(key, &mut written_out);
    assert_eq!(res, [0u8;0]);

    // Set key/value
    api.rtm_ext_set_storage(key, value);

    // Get valid key
    let mut written_out = 0;
    let mut res = api.rtm_ext_get_allocated_storage(key, &mut written_out);
    assert_eq!(res, value);

    println!("{}", str(&res));
}

// Input: key, value
pub fn test_exists_storage(input: ParsedInput) {
    let mut api = StorageApi::new();

    let key = input.get(0);
    let value = input.get(1);

    // Check invalid key
    let res = api.rtm_ext_exists_storage(key);
    assert_eq!(res, 0);

    // Set key/value
    api.rtm_ext_set_storage(key, value);

    // Check valid key
    let res = api.rtm_ext_exists_storage(key);
    assert_eq!(res, 1);

    println!("true");
}

// Input: key, value
pub fn test_clear_storage(input: ParsedInput) {
    let mut api = StorageApi::new();

    let key = input.get(0);
    let value = input.get(1);

    // Set key/value
    api.rtm_ext_set_storage(key, value);

    // Get valid key
    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_storage(key, &mut written_out);
    assert_eq!(written_out, value.len() as u32);
    assert_eq!(res, value);

    // Clear key
    api.rtm_ext_clear_storage(key);

    // Get invalid key
    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_storage(key, &mut written_out);
    assert_eq!(written_out, u32::max_value());
    assert_eq!(res, [0; 0]);
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
    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_storage(key1, &mut written_out);
    if key1.starts_with(prefix) {
        assert_eq!(written_out, u32::max_value());
        assert_eq!(res, [0; 0]);
        println!("Key `{}` was deleted", str(key1));
    } else {
        assert_eq!(written_out, value1.len() as u32);
        assert_eq!(res, value1);
        println!("Key `{}` remains", str(key1));
    }

    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_storage(key2, &mut written_out);
    if key2.starts_with(prefix) {
        assert_eq!(written_out, u32::max_value());
        assert_eq!(res, [0; 0]);
        println!("Key `{}` was deleted", str(key2));
    } else {
        assert_eq!(written_out, value2.len() as u32);
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

pub fn test_storage_root() {
    let mut api = StorageApi::new();

    let mut result = [0; 32];
    api.rtm_ext_storage_root(&mut result);

    // TODO...
}

// Input: key, value
pub fn test_set_get_local_storage(input: ParsedInput) {
    let mut api = StorageApi::new_with_offchain_context();

    let key1 = input.get(0);
    let value1 = input.get(1);

    api.rtm_ext_local_storage_set(2, key1, value1);

    // TODO...
}
