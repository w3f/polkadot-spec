extern "C" {
    fn ext_print_utf8(utf8_data: *const u8, utf8_len: u32);
    fn ext_print_hex(data: *const u8, len: u32);
    fn ext_print_num(number: u64);
    fn ext_malloc(size: u32) -> u32;
    fn ext_free(addr: *mut u8);
    fn ext_set_storage(key_data: *const u8, key_len: u32, value_data: *const u8, value_len: u32);
    fn ext_set_child_storage(
        storage_key_data: *const u8,
        storage_key_len: u32,
        key_data: *const u8,
        key_len: u32,
        value_data: *const u8,
        value_len: u32,
    );
    fn ext_clear_child_storage(
        storage_key_data: *const u8,
        storage_key_len: u32,
        key_data: *const u8,
        key_len: u32,
    );
    fn ext_clear_storage(key_data: *const u8, key_len: u32);
    fn ext_exists_storage(key_data: *const u8, key_len: u32) -> u32;
    fn ext_exists_child_storage(
        storage_key_data: *const u8,
        storage_key_len: u32,
        key_data: *const u8,
        key_len: u32,
    ) -> u32;
    fn ext_clear_prefix(prefix_data: *const u8, prefix_len: u32);
    fn ext_clear_child_prefix(
        storage_key_data: *const u8,
        storage_key_len: u32,
        prefix_data: *const u8,
        prefix_len: u32,
    );
    fn ext_kill_child_storage(storage_key_data: *const u8, storage_key_len: u32);
    fn ext_get_allocated_storage(
        key_data: *const u8,
        key_len: u32,
        written_out: *mut u32,
    ) -> *mut u8;
    fn ext_get_allocated_child_storage(
        storage_key_data: *const u8,
        storage_key_len: u32,
        key_data: *const u8,
        key_len: u32,
        written_out: *mut u32,
    ) -> *mut u8;
    fn ext_get_storage_into(
        key_data: *const u8,
        key_len: u32,
        value_data: *mut u8,
        value_len: u32,
        value_offset: u32,
    ) -> u32;
    fn ext_get_child_storage_into(
        storage_key_data: *const u8,
        storage_key_len: u32,
        key_data: *const u8,
        key_len: u32,
        value_data: *mut u8,
        value_len: u32,
        value_offset: u32,
    ) -> u32;
    fn ext_storage_root(result: *mut u8);
    fn ext_child_storage_root(
        storage_key_data: *const u8,
        storage_key_len: u32,
        written_out: *mut u32,
    ) -> *mut u8;
    fn ext_storage_changes_root(
        parent_hash_data: *const u8,
        parent_hash_len: u32,
        result: *mut u8,
    ) -> u32;
    fn ext_blake2_256_enumerated_trie_root(
        values_data: *const u8,
        lens_data: *const u32,
        lens_len: u32,
        result: *mut u8,
    );
    fn ext_chain_id() -> u64;
    fn ext_twox_64(data: *const u8, len: u32, out: *mut u8);
    fn ext_twox_128(data: *const u8, len: u32, out: *mut u8);
    fn ext_twox_256(data: *const u8, len: u32, out: *mut u8);
    fn ext_blake2_128(data: *const u8, len: u32, out: *mut u8);
    fn ext_blake2_256(data: *const u8, len: u32, out: *mut u8);
    fn ext_keccak_256(data: *const u8, len: u32, out: *mut u8);
    fn ext_ed25519_public_keys(id_data: *const u8, result_len: *mut u32) -> *mut u8;
    fn ext_ed25519_verify(
        msg_data: *const u8,
        msg_len: u32,
        sig_data: *const u8,
        pubkey_data: *const u8,
    ) -> u32;
    fn ext_ed25519_generate(id_data: *const u8, seed: *const u8, seed_len: u32, out: *mut u8);
    fn ext_ed25519_sign(
        id_data: *const u8,
        pubkey_data: *const u8,
        msg_data: *const u8,
        msg_len: u32,
        out: *mut u8,
    ) -> u32;
    fn ext_sr25519_public_keys(id_data: *const u8, result_len: *mut u32) -> *mut u8;
    fn ext_sr25519_verify(
        msg_data: *const u8,
        msg_len: u32,
        sig_data: *const u8,
        pubkey_data: *const u8,
    ) -> u32;
    fn ext_sr25519_generate(id_data: *const u8, seed: *const u8, seed_len: u32, out: *mut u8);
    fn ext_sr25519_sign(
        id_data: *const u8,
        pubkey_data: *const u8,
        msg_data: *const u8,
        msg_len: u32,
        out: *mut u8,
    ) -> u32;
    fn ext_secp256k1_ecdsa_recover(
        msg_data: *const u8,
        sig_data: *const u8,
        pubkey_data: *mut u8,
    ) -> u32;
    fn ext_is_validator() -> u32;
    fn ext_submit_transaction(msg_data: *const u8, len: u32) -> u32;
    fn ext_network_state(written_out: *mut u32) -> *mut u8;
    fn ext_timestamp() -> u64;
    fn ext_sleep_until(deadline: u64);
    fn ext_random_seed(seed_data: *mut u8);
    fn ext_local_storage_set(
        kind: u32,
        key: *const u8,
        key_len: u32,
        value: *const u8,
        value_len: u32,
    );
    fn ext_local_storage_get(
        kind: u32,
        key: *const u8,
        key_len: u32,
        value_len: *mut u32,
    ) -> *mut u8;
    fn ext_local_storage_compare_and_set(
        kind: u32,
        key: *const u8,
        key_len: u32,
        old_value: *const u8,
        old_value_len: u32,
        new_value: *const u8,
        new_value_len: u32,
    ) -> u32;
    fn ext_http_request_start(
        method: *const u8,
        method_len: u32,
        url: *const u8,
        url_len: u32,
        meta: *const u8,
        meta_len: u32,
    ) -> u32;
    fn ext_http_request_add_header(
        request_id: u32,
        name: *const u8,
        name_len: u32,
        value: *const u8,
        value_len: u32,
    ) -> u32;
    fn ext_http_request_write_body(
        request_id: u32,
        chunk: *const u8,
        chunk_len: u32,
        deadline: u64,
    ) -> u32;
    fn ext_http_response_wait(ids: *const u32, ids_len: u32, statuses: *mut u32, deadline: u64);
    fn ext_http_response_headers(request_id: u32, written_out: *mut u32) -> *mut u8;
    fn ext_http_response_read_body(
        request_id: u32,
        buffer: *mut u8,
        buffer_len: u32,
        deadline: u64,
    ) -> u32;
    fn ext_sandbox_instantiate(
        dispatch_thunk_idx: u32,
        wasm_ptr: *const u8,
        wasm_len: u32,
        imports_ptr: *const u8,
        imports_len: u32,
        state: u32,
    ) -> u32;
    fn ext_sandbox_instance_teardown(instance_idx: u32);
    fn ext_sandbox_invoke(
        instance_idx: u32,
        export_ptr: *const u8,
        export_len: u32,
        args_ptr: *const u8,
        args_len: u32,
        return_val_ptr: *const u8,
        return_val_len: u32,
        state: u32,
    ) -> u32;
    fn ext_sandbox_memory_new(initial: u32, maximum: u32) -> u32;
    fn ext_sandbox_memory_get(memory_idx: u32, offset: u32, buf_ptr: *mut u8, buf_len: u32) -> u32;
    fn ext_sandbox_memory_set(
        memory_idx: u32,
        offset: u32,
        val_ptr: *const u8,
        val_len: u32,
    ) -> u32;
    fn ext_sandbox_memory_teardown(memory_idx: u32);
}

#[no_mangle]
pub extern "C" fn test_ext_print_utf8(utf8_data: *const u8, utf8_len: u32) {
    unsafe {
        ext_print_utf8(utf8_data, utf8_len)
    }
}

#[no_mangle]
pub extern "C" fn test_ext_print_hex(data: *const u8, len: u32) {
    unsafe {
        ext_print_hex(data, len)
    }
}

#[no_mangle]
pub extern "C" fn test_ext_print_num(number: u64) {
    unsafe {
        ext_print_num(number)
    }
}

#[no_mangle]
pub extern "C" fn test_ext_malloc(size: u32) -> u32 {
    unsafe {
        ext_malloc(size)
    }
}

#[no_mangle]
pub extern "C" fn test_ext_free(addr: *mut u8) {
    unsafe {
        ext_free(addr);
    }
}

#[no_mangle]
pub extern "C" fn test_ext_set_storage(
    key_data: *const u8,
    key_len: u32,
    value_data: *const u8,
    value_len: u32,
) {
    unsafe {
        ext_set_storage(key_data, key_len, value_data, value_len);
    }
}

#[no_mangle]
pub extern "C" fn test_ext_set_child_storage(
    storage_key_data: *const u8,
    storage_key_len: u32,
    key_data: *const u8,
    key_len: u32,
    value_data: *const u8,
    value_len: u32,
) {
    unsafe {
        ext_set_child_storage(
            storage_key_data,
            storage_key_len,
            key_data,
            key_len,
            value_data,
            value_len,
        );
    }
}

#[no_mangle]
pub extern "C" fn test_ext_clear_child_storage(
    storage_key_data: *const u8,
    storage_key_len: u32,
    key_data: *const u8,
    key_len: u32,
) {
    unsafe {
        ext_clear_child_storage(storage_key_data, storage_key_len, key_data, key_len);
    }
}

#[no_mangle]
pub extern "C" fn test_ext_clear_storage(key_data: *const u8, key_len: u32) {
    unsafe {
        ext_clear_storage(key_data, key_len);
    }
}

#[no_mangle]
pub extern "C" fn test_ext_exists_storage(key_data: *const u8, key_len: u32) -> u32 {
    unsafe {
        ext_exists_storage(key_data, key_len)
    }
}

#[no_mangle]
pub extern "C" fn test_ext_exists_child_storage(
    storage_key_data: *const u8,
    storage_key_len: u32,
    key_data: *const u8,
    key_len: u32,
) -> u32 {
    unsafe {
        ext_exists_child_storage(storage_key_data, storage_key_len, key_data, key_len)
    }
}

#[no_mangle]
pub extern "C" fn test_ext_clear_prefix(prefix_data: *const u8, prefix_len: u32) {
    unsafe {
        ext_clear_prefix(prefix_data, prefix_len);
    }
}

#[no_mangle]
pub extern "C" fn test_ext_clear_child_prefix(
    storage_key_data: *const u8,
    storage_key_len: u32,
    prefix_data: *const u8,
    prefix_len: u32,
) {
    unsafe {
        ext_clear_child_prefix(storage_key_data, storage_key_len, prefix_data, prefix_len);
    }
}

#[no_mangle]
pub extern "C" fn test_ext_kill_child_storage(storage_key_data: *const u8, storage_key_len: u32) {
    unsafe {
        ext_kill_child_storage(storage_key_data, storage_key_len);
    }
}

#[no_mangle]
pub extern "C" fn test_ext_get_allocated_storage(
    key_data: *const u8,
    key_len: u32,
    written_out: *mut u32,
) -> u32 {
    let output;
    unsafe {
        output = ext_get_allocated_storage(key_data, key_len, written_out);
    }

    if output.is_null() {
        0
    } else {
        output as u32
    }
}

#[no_mangle]
pub extern "C" fn test_ext_get_allocated_child_storage(
    storage_key_data: *const u8,
    storage_key_len: u32,
    key_data: *const u8,
    key_len: u32,
    written_out: *mut u32,
) -> u32 {
    let output;
    unsafe {
        output = ext_get_allocated_child_storage(
            storage_key_data,
            storage_key_len,
            key_data,
            key_len,
            written_out,
        )
    }

    if output.is_null() {
        0
    } else {
        output as u32
    }
}

#[no_mangle]
pub extern "C" fn test_ext_get_storage_into(
    key_data: *const u8,
    key_len: u32,
    value_data: *mut u8,
    value_len: u32,
    value_offset: u32,
) -> u32 {
    unsafe { ext_get_storage_into(key_data, key_len, value_data, value_len, value_offset) }
}

#[no_mangle]
pub extern "C" fn test_ext_get_child_storage_into(
    storage_key_data: *const u8,
    storage_key_len: u32,
    key_data: *const u8,
    key_len: u32,
    value_data: *mut u8,
    value_len: u32,
    value_offset: u32,
) -> u32 {
    unsafe {
        ext_get_child_storage_into(
            storage_key_data,
            storage_key_len,
            key_data,
            key_len,
            value_data,
            value_len,
            value_offset,
        )
    }
}

#[no_mangle]
pub extern "C" fn test_ext_storage_root(result: *mut u8) {
    unsafe {
        ext_storage_root(result);
    }
}

#[no_mangle]
pub extern "C" fn test_ext_child_storage_root(
    storage_key_data: *const u8,
    storage_key_len: u32,
    written_out: *mut u32,
) -> *mut u8 {
    unsafe { ext_child_storage_root(storage_key_data, storage_key_len, written_out) }
}

#[no_mangle]
pub extern "C" fn test_ext_storage_changes_root(
    parent_hash_data: *const u8,
    parent_hash_len: u32,
    result: *mut u8,
) -> u32 {
    unsafe { ext_storage_changes_root(parent_hash_data, parent_hash_len, result) }
}

#[no_mangle]
pub extern "C" fn test_ext_blake2_256_enumerated_trie_root(
    values_data: *const u8,
    lens_data: *const u32,
    lens_len: u32,
    result: *mut u8,
) {
    unsafe {
        ext_blake2_256_enumerated_trie_root(values_data, lens_data, lens_len, result);
    }
}

#[no_mangle]
pub extern "C" fn test_ext_chain_id() -> u64 {
    unsafe { ext_chain_id() }
}

#[no_mangle]
pub extern "C" fn test_ext_twox_64(data: *const u8, len: u32, output: *mut u8) {
    unsafe {
        ext_twox_64(data, len, output)
    }
}

#[no_mangle]
pub extern "C" fn test_ext_twox_128(data: *const u8, len: u32, output: *mut u8) {
    unsafe {
        ext_twox_128(data, len, output)
    }
}

#[no_mangle]
pub extern "C" fn test_ext_twox_256(data: *const u8, len: u32, output: *mut u8) {
    unsafe {
        ext_twox_256(data, len, output)
    }
}

#[no_mangle]
pub extern "C" fn test_ext_blake2_128(data: *const u8, len: u32, output: *mut u8) {
    unsafe {
        ext_blake2_128(data, len, output)
    }
}

#[no_mangle]
pub extern "C" fn test_ext_blake2_256(data: *const u8, len: u32, output: *mut u8) {
    unsafe {
        ext_blake2_256(data, len, output)
    }
}

#[no_mangle]
pub extern "C" fn test_ext_keccak_256(data: *const u8, len: u32, output: *mut u8) {
    unsafe {
        ext_keccak_256(data, len, output)
    }
}

#[no_mangle]
pub extern "C" fn test_ext_ed25519_public_keys(
    id_data: *const u8,
    result_len: *mut u32,
) -> *mut u8 {
    unsafe { ext_ed25519_public_keys(id_data, result_len) }
}

#[no_mangle]
pub extern "C" fn test_ext_ed25519_verify(
    msg_data: *const u8,
    msg_len: u32,
    sig_data: *const u8,
    pubkey_data: *const u8,
) -> u32 {
    unsafe { ext_ed25519_verify(msg_data, msg_len, sig_data, pubkey_data) }
}

#[no_mangle]
pub extern "C" fn test_ext_ed25519_generate(
    id_data: *const u8,
    seed: *const u8,
    seed_len: u32,
    out: *mut u8,
) {
    unsafe { ext_ed25519_generate(id_data, seed, seed_len, out) }
}

#[no_mangle]
pub extern "C" fn test_ext_ed25519_sign(
    id_data: *const u8,
    pubkey_data: *const u8,
    msg_data: *const u8,
    msg_len: u32,
    out: *mut u8,
) -> u32 {
    unsafe {
        ext_ed25519_sign(id_data, pubkey_data, msg_data, msg_len, out)
    }
}

#[no_mangle]
pub extern "C" fn test_ext_sr25519_public_keys(
    id_data: *const u8,
    result_len: *mut u32,
) -> *mut u8 {
    unsafe { ext_sr25519_public_keys(id_data, result_len) }
}

#[no_mangle]
pub extern "C" fn test_ext_sr25519_verify(
    msg_data: *const u8,
    msg_len: u32,
    sig_data: *const u8,
    pubkey_data: *const u8,
) -> u32 {
    unsafe { ext_sr25519_verify(msg_data, msg_len, sig_data, pubkey_data) }
}

#[no_mangle]
pub extern "C" fn test_ext_sr25519_generate(
    id_data: *const u8,
    seed: *const u8,
    seed_len: u32,
    out: *mut u8,
) {
    unsafe {
        ext_sr25519_generate(id_data, seed, seed_len, out);
    }
}

#[no_mangle]
pub extern "C" fn test_ext_sr25519_sign(
    id_data: *const u8,
    pubkey_data: *const u8,
    msg_data: *const u8,
    msg_len: u32,
    out: *mut u8,
) -> u32 {
    unsafe { ext_sr25519_sign(id_data, pubkey_data, msg_data, msg_len, out) }
}

#[no_mangle]
pub extern "C" fn test_ext_secp256k1_ecdsa_recover(
    msg_data: *const u8,
    sig_data: *const u8,
    pubkey_data: *mut u8,
) -> u32 {
    unsafe { ext_secp256k1_ecdsa_recover(msg_data, sig_data, pubkey_data) }
}

#[no_mangle]
pub extern "C" fn test_ext_is_validator(input_data: *mut u8, input_len: u32) -> u64 {
    unsafe { ext_is_validator().into() }
}

#[no_mangle]
pub extern "C" fn test_ext_submit_transaction(msg_data: *const u8, len: u32) -> u32 {
    unsafe { ext_submit_transaction(msg_data, len) }
}

#[no_mangle]
pub extern "C" fn test_ext_network_state(written_out: *mut u32) -> *mut u8 {
    unsafe { ext_network_state(written_out) }
}

#[no_mangle]
pub extern "C" fn test_ext_timestamp() -> u64 {
    unsafe { ext_timestamp() }
}

#[no_mangle]
pub extern "C" fn test_ext_sleep_until(deadline: u64) {
    unsafe {
        ext_sleep_until(deadline);
    }
}

#[no_mangle]
pub extern "C" fn test_ext_random_seed(seed_data: *mut u8) {
    unsafe {
        ext_random_seed(seed_data);
    }
}

#[no_mangle]
pub extern "C" fn test_ext_local_storage_set(
    kind: u32,
    key: *const u8,
    key_len: u32,
    value: *const u8,
    value_len: u32,
) {
    unsafe {
        ext_local_storage_set(kind, key, key_len, value, value_len);
    }
}

#[no_mangle]
pub extern "C" fn test_ext_local_storage_get(
    kind: u32,
    key: *const u8,
    key_len: u32,
    value_len: *mut u32,
) -> *mut u8 {
    unsafe { ext_local_storage_get(kind, key, key_len, value_len) }
}

#[no_mangle]
pub extern "C" fn test_ext_local_storage_compare_and_set(
    kind: u32,
    key: *const u8,
    key_len: u32,
    old_value: *const u8,
    old_value_len: u32,
    new_value: *const u8,
    new_value_len: u32,
) -> u32 {
    unsafe {
        ext_local_storage_compare_and_set(
            kind,
            key,
            key_len,
            old_value,
            old_value_len,
            new_value,
            new_value_len,
        )
    }
}

#[no_mangle]
pub extern "C" fn test_ext_http_request_start(
    method: *const u8,
    method_len: u32,
    url: *const u8,
    url_len: u32,
    meta: *const u8,
    meta_len: u32,
) -> u32 {
    unsafe { ext_http_request_start(method, method_len, url, url_len, meta, meta_len) }
}

#[no_mangle]
pub extern "C" fn test_ext_http_request_add_header(
    request_id: u32,
    name: *const u8,
    name_len: u32,
    value: *const u8,
    value_len: u32,
) -> u32 {
    unsafe { ext_http_request_add_header(request_id, name, name_len, value, value_len) }
}

#[no_mangle]
pub extern "C" fn test_ext_http_request_write_body(
    request_id: u32,
    chunk: *const u8,
    chunk_len: u32,
    deadline: u64,
) -> u32 {
    unsafe { ext_http_request_write_body(request_id, chunk, chunk_len, deadline) }
}

#[no_mangle]
pub extern "C" fn test_ext_http_response_wait(
    ids: *const u32,
    ids_len: u32,
    statuses: *mut u32,
    deadline: u64,
) {
    unsafe {
        ext_http_response_wait(ids, ids_len, statuses, deadline);
    }
}

#[no_mangle]
pub extern "C" fn test_ext_http_response_headers(
    request_id: u32,
    written_out: *mut u32,
) -> *mut u8 {
    unsafe { ext_http_response_headers(request_id, written_out) }
}

#[no_mangle]
pub extern "C" fn test_ext_http_response_read_body(
    request_id: u32,
    buffer: *mut u8,
    buffer_len: u32,
    deadline: u64,
) -> u32 {
    unsafe { ext_http_response_read_body(request_id, buffer, buffer_len, deadline) }
}

#[no_mangle]
pub extern "C" fn test_ext_sandbox_instantiate(
    dispatch_thunk_idx: u32,
    wasm_ptr: *const u8,
    wasm_len: u32,
    imports_ptr: *const u8,
    imports_len: u32,
    state: u32,
) -> u32 {
    unsafe {
        ext_sandbox_instantiate(
            dispatch_thunk_idx,
            wasm_ptr,
            wasm_len,
            imports_ptr,
            imports_len,
            state,
        )
    }
}

#[no_mangle]
pub extern "C" fn test_ext_sandbox_instance_teardown(instance_idx: u32) {
    unsafe {
        ext_sandbox_instance_teardown(instance_idx);
    }
}

#[no_mangle]
pub extern "C" fn test_ext_sandbox_invoke(
    instance_idx: u32,
    export_ptr: *const u8,
    export_len: u32,
    args_ptr: *const u8,
    args_len: u32,
    return_val_ptr: *const u8,
    return_val_len: u32,
    state: u32,
) -> u32 {
    unsafe {
        ext_sandbox_invoke(
            instance_idx,
            export_ptr,
            export_len,
            args_ptr,
            args_len,
            return_val_ptr,
            return_val_len,
            state,
        )
    }
}

#[no_mangle]
pub extern "C" fn test_ext_sandbox_memory_new(initial: u32, maximum: u32) -> u32 {
    unsafe { ext_sandbox_memory_new(initial, maximum) }
}

#[no_mangle]
pub extern "C" fn test_ext_sandbox_memory_get(
    memory_idx: u32,
    offset: u32,
    buf_ptr: *mut u8,
    buf_len: u32,
) -> u32 {
    unsafe { ext_sandbox_memory_get(memory_idx, offset, buf_ptr, buf_len) }
}

#[no_mangle]
pub extern "C" fn test_ext_sandbox_memory_set(
    memory_idx: u32,
    offset: u32,
    val_ptr: *const u8,
    val_len: u32,
) -> u32 {
    unsafe { ext_sandbox_memory_set(memory_idx, offset, val_ptr, val_len) }
}

#[no_mangle]
pub extern "C" fn test_ext_sandbox_memory_teardown(memory_idx: u32) {
    unsafe {
        ext_sandbox_memory_teardown(memory_idx);
    }
}