use super::utils::StorageApi;

pub fn test_set_get_storage(key: &str, value: &str) {
    let mut api = StorageApi::new();

    // Get invalid key
    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_storage(key.as_bytes(), &mut written_out);
    assert_eq!(written_out, u32::max_value());
    assert_eq!(res, [0u8; 0]);

    // Set key/value
    api.rtm_ext_set_storage(key.as_bytes(), value.as_bytes());

    // Get valid key
    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_storage(key.as_bytes(), &mut written_out);
    assert_eq!(written_out, 6);
    assert_eq!(res, value.as_bytes());
}

pub fn test_exists_storage(key: &str, value: &str) {
    let mut api = StorageApi::new();

    // Check invalid key
    let res = api.rtm_ext_exists_storage(key.as_bytes());
    assert_eq!(res, 0);

    // Set key/value
    api.rtm_ext_set_storage(key.as_bytes(), value.as_bytes());

    // Check valid key
    let res = api.rtm_ext_exists_storage(key.as_bytes());
    assert_eq!(res, 1);
}

pub fn test_clear_storage(key: &str, value: &str) {
    let mut api = StorageApi::new();

    // Set key/value
    api.rtm_ext_set_storage(key.as_bytes(), value.as_bytes());

    // Get valid key
    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_storage(key.as_bytes(), &mut written_out);
    assert_eq!(res, value.as_bytes());

    // Clear key
    api.rtm_ext_clear_storage(key.as_bytes());

    // Get invalid key
    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_storage(key.as_bytes(), &mut written_out);
    assert_eq!(res, [0; 0]);
}

pub fn test_clear_prefix() { // TODO
    let mut api = StorageApi::new();

    let key1 = String::from("Key1");
    let value1 = String::from("Value1");
    let key2 = String::from("some_prefix:Key2");
    let value2 = String::from("Value2");
    let key3 = String::from("some_prefix:Key3");
    let value3 = String::from("Value3");

    // Set keys/values
    api.rtm_ext_set_storage(key1.as_bytes(), value1.as_bytes());
    api.rtm_ext_set_storage(key2.as_bytes(), value2.as_bytes());
    api.rtm_ext_set_storage(key3.as_bytes(), value3.as_bytes());

    // Clear keys with specified prefix
    let to_delete = String::from("some_prefix:");
    api.rtm_ext_clear_prefix(to_delete.as_bytes());

    // Check deletions
    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_storage(key1.as_bytes(), &mut written_out);
    assert_eq!(res, value1.as_bytes());

    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_storage(key2.as_bytes(), &mut written_out);
    assert_eq!(res, [0; 0]);

    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_storage(key3.as_bytes(), &mut written_out);
    assert_eq!(res, [0; 0]);
}

pub fn test_set_get_child_storage(store1: &str, store2: &str, key: &str, value: &str) {
    let mut api = StorageApi::new();

    /*
    let store2 = String::from(":child_storage:default:Store2");
    let store1 = String::from(":child_storage:default:Store1");

    let key1 = String::from("Key1");
    let value1 = String::from("Value1");
    let key2 = String::from("Key2");
    let value2 = String::from("Value2");
    */

    // Get invalid key
    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_child_storage(
        store1.as_bytes(),
        key.as_bytes(),
        &mut written_out,
    );
    assert_eq!(written_out, u32::max_value());
    assert_eq!(res, [0u8; 0]);

    // Set key/value
    api.rtm_ext_set_child_storage(store1.as_bytes(), key.as_bytes(), value.as_bytes());

    // Get valid key
    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_child_storage(
        store1.as_bytes(),
        key.as_bytes(),
        &mut written_out,
    );
    assert_eq!(written_out, 6);
    assert_eq!(res, value.as_bytes());

    // Get invalid key from invalid store
    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_child_storage(
        store2.as_bytes(),
        key.as_bytes(),
        &mut written_out,
    );
    assert_eq!(written_out, u32::max_value());
    assert_eq!(res, [0; 0]);
}

pub fn test_exists_child_storage(store1: &str, store2: &str, key: &str, value: &str) {
    let mut api = StorageApi::new();

    let store1 = String::from(":child_storage:default:Store1");
    let key1 = String::from("Key1");
    let value1 = String::from("Value1");

    // Check invalid key
    let res = api.rtm_ext_exists_child_storage(store1.as_bytes(), key.as_bytes());
    assert_eq!(res, 0);

    // Set key/value
    api.rtm_ext_set_child_storage(store1.as_bytes(), key.as_bytes(), value.as_bytes());

    // Check valid key
    let res = api.rtm_ext_exists_child_storage(store1.as_bytes(), key1.as_bytes());
    assert_eq!(res, 1);

    // Check invalid key from invalid store
    let res = api.rtm_ext_exists_child_storage(store2.as_bytes(), key.as_bytes());
    assert_eq!(res, 0);
}

pub fn test_clear_child_storage(store1: &str, store2: &str, key: &str, value: &str) {
    let mut api = StorageApi::new();

    /*
    let store1 = String::from(":child_storage:default:Store1");
    let key1 = String::from("Key1");
    let value1 = String::from("Value1");
    */

    // Set key/value
    api.rtm_ext_set_child_storage(store1.as_bytes(), key.as_bytes(), value.as_bytes());
    api.rtm_ext_set_child_storage(store2.as_bytes(), key.as_bytes(), value.as_bytes());

    // Get valid keys
    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_child_storage(
        store1.as_bytes(),
        key.as_bytes(),
        &mut written_out,
    );
    // TODO: check len of written_out
    assert_eq!(res, value.as_bytes());

    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_child_storage(
        store2.as_bytes(),
        key.as_bytes(),
        &mut written_out,
    );
    assert_eq!(res, value.as_bytes());

    // Clear key
    api.rtm_ext_clear_child_storage(store1.as_bytes(), key.as_bytes());

    // Get invalid key
    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_child_storage(
        store1.as_bytes(),
        key.as_bytes(),
        &mut written_out,
    );
    assert_eq!(res, [0; 0]);

    // Get valid key from other store
    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_child_storage(
        store2.as_bytes(),
        key.as_bytes(),
        &mut written_out,
    );
    assert_eq!(res, value.as_bytes());
}

pub fn test_clear_child_prefix() { // TODO
    let mut api = StorageApi::new();

    let store1 = String::from(":child_storage:default:Store1");
    let store2 = String::from(":child_storage:default:Store2");

    let key1 = String::from("some_prefix:Key1");
    let value1 = String::from("Value1");
    let key2 = String::from("some_prefix:Key2");
    let value2 = String::from("Value2");

    // Set keys/values for each store
    api.rtm_ext_set_child_storage(store1.as_bytes(), key1.as_bytes(), value1.as_bytes());
    api.rtm_ext_set_child_storage(store1.as_bytes(), key2.as_bytes(), value2.as_bytes());
    api.rtm_ext_set_child_storage(store2.as_bytes(), key1.as_bytes(), value1.as_bytes());
    api.rtm_ext_set_child_storage(store2.as_bytes(), key2.as_bytes(), value2.as_bytes());

    // Clear keys with specified prefix
    let to_delete = String::from("some_prefix:");
    api.rtm_ext_clear_child_prefix(store2.as_bytes(), to_delete.as_bytes());

    // Check deletions (only keys from `store2` are got deleted)
    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_child_storage(
        store1.as_bytes(),
        key1.as_bytes(),
        &mut written_out,
    );
    assert_eq!(res, value1.as_bytes());

    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_child_storage(
        store1.as_bytes(),
        key2.as_bytes(),
        &mut written_out,
    );
    assert_eq!(res, value2.as_bytes());

    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_child_storage(
        store2.as_bytes(),
        key1.as_bytes(),
        &mut written_out,
    );
    assert_eq!(res, [0; 0]);

    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_child_storage(
        store2.as_bytes(),
        key2.as_bytes(),
        &mut written_out,
    );
    assert_eq!(res, [0; 0]);
}

pub fn test_kill_child_storage(store1: &str, store2: &str, key: &str, value: &str) {
    let mut api = StorageApi::new();

    /*
    let store1 = String::from(":child_storage:default:Store1");

    let key1 = String::from("Key1");
    let value1 = String::from("Value1");
    let key2 = String::from("Key2");
    let value2 = String::from("Value2");
    */

    // Set key/values
    api.rtm_ext_set_child_storage(store1.as_bytes(), key.as_bytes(), value.as_bytes());
    api.rtm_ext_set_child_storage(store2.as_bytes(), key.as_bytes(), value.as_bytes());

    // Kill the child
    api.rtm_ext_kill_child_storage(store1.as_bytes());

    // Get invalid key
    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_child_storage(
        store1.as_bytes(),
        key.as_bytes(),
        &mut written_out,
    );
    assert_eq!(res, [0; 0]);

    // Get valid key from other store
    let mut written_out = 0;
    let res = api.rtm_ext_get_allocated_child_storage(
        store2.as_bytes(),
        key.as_bytes(),
        &mut written_out,
    );
    assert_eq!(res, value.as_bytes());
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

pub fn test_set_get_local_storage() {
    let mut api = StorageApi::new_with_offchain_context();

    let key1 = String::from("Key1");
    let value1 = String::from("Value1");

    api.rtm_ext_local_storage_set(2, key1.as_bytes(), value1.as_bytes());

    // TODO...
}
