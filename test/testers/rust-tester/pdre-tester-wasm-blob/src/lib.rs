use std::slice;

use substrate_primitives::{wasm_export_functions, Blake2Hasher};
use parity_scale_codec::{Encode, Decode};

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

#[cfg(not(feature = "std"))]

wasm_export_functions! {
    fn test_ext_twox_64(input: Vec<u8>) -> Vec<u8> {
        let mut api_output : [u8; 8] = [0; 8];
        unsafe {
            ext_twox_64(input.as_slice().as_ptr(),  input.len() as u32, api_output.as_mut_ptr());
        }
        api_output.to_vec()
    }

	fn test_ext_twox_128(input: Vec<u8>) -> Vec<u8> {
        let mut api_output : [u8; 16] = [0; 16];
        unsafe {
		    ext_twox_128(input.as_slice().as_ptr(), input.len() as u32, api_output.as_mut_ptr());
        }
        api_output.to_vec()
	}

    fn test_ext_twox_256(input: Vec<u8>) -> Vec<u8> {
        let mut api_output : [u8; 32] = [0; 32];
        unsafe {
            ext_twox_256(input.as_slice().as_ptr(), input.len() as u32, api_output.as_mut_ptr())
        }
        api_output.to_vec()
    }

    fn test_ext_blake2_128(input: Vec<u8>) -> Vec<u8> {
        let mut api_output : [u8; 16] = [0; 16];
        unsafe {
            ext_blake2_128(input.as_slice().as_ptr(), input.len() as u32, api_output.as_mut_ptr())
        }
        api_output.to_vec()
    }
    
    fn test_ext_blake2_256(input: Vec<u8>) -> Vec<u8> {
        let mut api_output : [u8; 32] = [0; 32];
        unsafe {
            ext_blake2_256(input.as_slice().as_ptr(), input.len() as u32, api_output.as_mut_ptr())
        }
        api_output.to_vec()
    }
    
    fn test_ext_keccak_256(input: Vec<u8>) -> Vec<u8> {
        let mut api_output : [u8; 32] = [0; 32];
        unsafe {
            ext_keccak_256(input.as_slice().as_ptr(), input.len() as u32, api_output.as_mut_ptr())
        }
        api_output.to_vec()
    }
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

wasm_export_functions! {
    fn test_ext_set_storage(
        key_data: Vec<u8>,
        value_data: Vec<u8>,
    ) {
        unsafe {
            ext_set_storage(key_data.as_ptr(), key_data.len() as u32, value_data.as_ptr(), value_data.len() as u32);
        }
    }

    fn test_ext_set_child_storage(
        storage_key_data: Vec<u8>,
        key_data: Vec<u8>,
        value_data: Vec<u8>,
    ) {
        unsafe {
            ext_set_child_storage(
                storage_key_data.as_ptr(),
                storage_key_data.len() as u32,
                key_data.as_ptr(),
                key_data.len() as u32,
                value_data.as_ptr(),
                value_data.len() as u32,
            );
        }
    }

    fn test_ext_clear_child_storage(
        storage_key_data: Vec<u8>,
        key_data: Vec<u8>,
    ) {
        unsafe {
            ext_clear_child_storage(
                storage_key_data.as_ptr(),
                storage_key_data.len() as u32,
                key_data.as_ptr(),
                key_data.len() as u32,
            );
        }
    }

    fn test_ext_clear_storage(key_data: Vec<u8>) {
        unsafe {
            ext_clear_storage(key_data.as_ptr(), key_data.len() as u32);
        }
    }

    fn test_ext_exists_storage(key_data: Vec<u8>) -> u32 {
        unsafe {
            ext_exists_storage(key_data.as_ptr(), key_data.len() as u32)
        }
    }

    fn test_ext_exists_child_storage(
        storage_key_data: Vec<u8>,
        key_data: Vec<u8>,
    ) -> u32 {
        unsafe {
            ext_exists_child_storage(
                storage_key_data.as_ptr(),
                storage_key_data.len() as u32,
                key_data.as_ptr(),
                key_data.len() as u32,
            )
        }
    }

    fn test_ext_clear_prefix(prefix_data: Vec<u8>) {
        unsafe {
            ext_clear_prefix(prefix_data.as_ptr(), prefix_data.len() as u32);
        }
    }

    fn test_ext_clear_child_prefix(
        storage_key_data: Vec<u8>,
        prefix_data: Vec<u8>,
    ) {
        unsafe {
            ext_clear_child_prefix(
                storage_key_data.as_ptr(),
                storage_key_data.len() as u32,
                prefix_data.as_ptr(),
                prefix_data.len() as u32,
            );
        }
    }

    fn test_ext_kill_child_storage(storage_key_data: Vec<u8>) {
        unsafe {
            ext_kill_child_storage(storage_key_data.as_ptr(), storage_key_data.len() as u32);
        }
    }

    fn test_ext_get_allocated_storage(
        key_data: Vec<u8>
    ) -> Vec<u8> {
        let mut written_out = 0;
        unsafe {
            let out = ext_get_allocated_storage(key_data.as_ptr(), key_data.len() as u32, &mut written_out);
            if out.is_null() {
                vec![]
            } else {
                slice::from_raw_parts(out, written_out as usize).to_vec()
            }
        }
    }

    fn test_ext_get_allocated_child_storage(
        storage_key_data: Vec<u8>,
        key_data: Vec<u8>,
    ) -> Vec<u8> {
        let mut written_out = 0;
        unsafe {
            let out = ext_get_allocated_child_storage(
                storage_key_data.as_ptr(),
                storage_key_data.len() as u32,
                key_data.as_ptr(),
                key_data.len() as u32,
                &mut written_out,
            );

            if out.is_null() {
                vec![]
            } else {
                slice::from_raw_parts(out, written_out as usize).to_vec()
            }
        }
    }

    fn test_ext_get_storage_into(
        key_data: Vec<u8>,
        value_data: Vec<u8>,
        value_offset: u32,
    ) -> Vec<u8> {
        let mut value_data = value_data;
        unsafe {
            ext_get_storage_into(
                key_data.as_ptr(),
                key_data.len() as u32,
                value_data.as_mut_ptr(),
                value_data.len() as u32,
                value_offset
            );
        }
        value_data
    }

    fn test_ext_get_child_storage_into(
        storage_key_data: Vec<u8>,
        key_data: Vec<u8>,
        value_data: Vec<u8>,
        value_offset: u32,
    ) -> Vec<u8> {
        let mut value_data = value_data;
        unsafe {
            ext_get_child_storage_into(
                storage_key_data.as_ptr(),
                storage_key_data.len() as u32,
                key_data.as_ptr(),
                key_data.len() as u32,
                value_data.as_mut_ptr(),
                value_data.len() as u32,
                value_offset,
            );
        }
        value_data
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


wasm_export_functions! {
    fn test_ext_ed25519_public_keys(
        id_data: Vec<u8>,
    ) -> Vec<u8> {
        let mut written_out = 0;
        unsafe {
            let out = ext_ed25519_public_keys(
                id_data.as_ptr(),
                &mut written_out,
            );
            if out.is_null() {
                vec![]
            } else {
                slice::from_raw_parts(out, written_out as usize).to_vec()
            }
        }
    }

    fn test_ext_ed25519_verify(
        msg_data: Vec<u8>,
        sig_data: Vec<u8>,
        pubkey_data: Vec<u8>,
    ) -> u32 {
        unsafe {
            ext_ed25519_verify(
                msg_data.as_ptr(),
                msg_data.len() as u32,
                sig_data.as_ptr(),
                pubkey_data.as_ptr(),
            )
        }
    }

    fn test_ext_ed25519_generate(
        id_data: Vec<u8>,
        seed: Vec<u8>,
    ) -> Vec<u8> {
        let mut out = vec![];
        unsafe {
            ext_ed25519_generate(
                id_data.as_ptr(),
                seed.as_ptr(),
                seed.len() as u32,
                out.as_mut_ptr()
            );
            slice::from_raw_parts(out.as_ptr(), 32).to_vec()
        }
    }

    fn test_ext_ed25519_sign(
        id_data: Vec<u8>,
        pubkey_data: Vec<u8>,
        msg_data: Vec<u8>,
    ) -> Vec<u8> {
        let mut out = vec![];
        unsafe {
            ext_ed25519_sign(
                id_data.as_ptr(),
                pubkey_data.as_ptr(),
                msg_data.as_ptr(),
                msg_data.len() as u32,
                out.as_mut_ptr(),
            );
            slice::from_raw_parts(out.as_ptr(), 64).to_vec()
        }
    }

    fn test_ext_sr25519_public_keys(
        id_data: Vec<u8>,
    ) -> Vec<u8> {
        let mut written_out = 0;
        unsafe {
            let out = ext_sr25519_public_keys(
                id_data.as_ptr(),
                &mut written_out,
            );
            if out.is_null() {
                vec![]
            } else {
                slice::from_raw_parts(out, written_out as usize).to_vec()
            }
        }
    }

    fn test_ext_sr25519_verify(
        msg_data: Vec<u8>,
        sig_data: Vec<u8>,
        pubkey_data: Vec<u8>,
    ) -> u32 {
        unsafe {
            ext_sr25519_verify(
                msg_data.as_ptr(),
                msg_data.len() as u32,
                sig_data.as_ptr(),
                pubkey_data.as_ptr(),
            )
        }
    }

    fn test_ext_sr25519_generate(
        id_data: Vec<u8>,
        seed: Vec<u8>,
    ) -> Vec<u8> {
        let mut out = vec![];
        unsafe {
            ext_sr25519_generate(
                id_data.as_ptr(),
                seed.as_ptr(),
                seed.len() as u32,
                out.as_mut_ptr(),
            );
            slice::from_raw_parts(out.as_ptr(), 32).to_vec()
        }
    }

    fn test_ext_sr25519_sign(
        id_data: Vec<u8>,
        pubkey_data: Vec<u8>,
        msg_data: Vec<u8>,
    ) -> Vec<u8> {
        let mut out = vec![];
        unsafe {
            ext_sr25519_sign(
                id_data.as_ptr(),
                pubkey_data.as_ptr(),
                msg_data.as_ptr(),
                msg_data.len() as u32,
                out.as_mut_ptr(),
            );
            slice::from_raw_parts(out.as_ptr(), 64).to_vec()
        }
    }
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
