#![allow(dead_code)]
#![allow(unused_imports)]
use std::slice;

#[cfg(not(feature = "runtime-wasm"))]
include!(concat!(env!("OUT_DIR"), "/wasm_binary.rs"));

#[cfg(feature = "runtime-wasm")]
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


#[cfg(feature = "runtime-wasm")]
primitives::wasm_export_functions! {
    fn rtm_ext_twox_64(input: Vec<u8>) -> Vec<u8> {
        let mut api_output : [u8; 8] = [0; 8];
        unsafe {
            ext_twox_64(input.as_slice().as_ptr(),  input.len() as u32, api_output.as_mut_ptr());
        }
        api_output.to_vec()
    }

    fn rtm_ext_twox_128(input: Vec<u8>) -> Vec<u8> {
        let mut api_output : [u8; 16] = [0; 16];
        unsafe {
            ext_twox_128(input.as_slice().as_ptr(), input.len() as u32, api_output.as_mut_ptr());
        }
        api_output.to_vec()
    }

    fn rtm_ext_twox_256(input: Vec<u8>) -> Vec<u8> {
        let mut api_output : [u8; 32] = [0; 32];
        unsafe {
            ext_twox_256(input.as_slice().as_ptr(), input.len() as u32, api_output.as_mut_ptr())
        }
        api_output.to_vec()
    }

    fn rtm_ext_blake2_128(input: Vec<u8>) -> Vec<u8> {
        let mut api_output : [u8; 16] = [0; 16];
        unsafe {
            ext_blake2_128(input.as_slice().as_ptr(), input.len() as u32, api_output.as_mut_ptr())
        }
        api_output.to_vec()
    }

    fn rtm_ext_blake2_256(input: Vec<u8>) -> Vec<u8> {
        let mut api_output : [u8; 32] = [0; 32];
        unsafe {
            ext_blake2_256(input.as_slice().as_ptr(), input.len() as u32, api_output.as_mut_ptr())
        }
        api_output.to_vec()
    }

    fn rtm_ext_keccak_256(input: Vec<u8>) -> Vec<u8> {
        let mut api_output : [u8; 32] = [0; 32];
        unsafe {
            ext_keccak_256(input.as_slice().as_ptr(), input.len() as u32, api_output.as_mut_ptr())
        }
        api_output.to_vec()
    }

    fn rtm_ext_print_utf8(utf8_data: Vec<u8>) {
        unsafe {
            ext_print_utf8(utf8_data.as_ptr(), utf8_data.len() as u32);
        }
    }

    fn rtm_ext_print_hex(data: Vec<u8>) {
        unsafe {
            ext_print_hex(data.as_ptr(), data.len() as u32);
        }
    }

    fn rtm_ext_print_num(number: u64) {
        unsafe {
            ext_print_num(number);
        }
    }

    fn rtm_ext_malloc(size: u32) -> u32 {
        unsafe {
            ext_malloc(size)
        }
    }

    fn rtm_ext_free(addr: Vec<u8>) {
        let mut addr = addr;
        unsafe {
            ext_free(addr.as_mut_ptr());
        }
    }

    fn rtm_ext_set_storage(
        key_data: Vec<u8>,
        value_data: Vec<u8>,
    ) {
        unsafe {
            ext_set_storage(
                key_data.as_ptr(),
                key_data.len() as u32,
                value_data.as_ptr(),
                value_data.len() as u32
            );
        }
    }

    fn rtm_ext_set_child_storage(
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

    fn rtm_ext_clear_child_storage(
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

    fn rtm_ext_clear_storage(key_data: Vec<u8>) {
        unsafe {
            ext_clear_storage(key_data.as_ptr(), key_data.len() as u32);
        }
    }

    fn rtm_ext_exists_storage(key_data: Vec<u8>) -> u32 {
        unsafe {
            ext_exists_storage(key_data.as_ptr(), key_data.len() as u32)
        }
    }

    fn rtm_ext_exists_child_storage(
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

    fn rtm_ext_clear_prefix(prefix_data: Vec<u8>) {
        unsafe {
            ext_clear_prefix(prefix_data.as_ptr(), prefix_data.len() as u32);
        }
    }

    fn rtm_ext_clear_child_prefix(
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

    fn rtm_ext_kill_child_storage(storage_key_data: Vec<u8>) {
        unsafe {
            ext_kill_child_storage(storage_key_data.as_ptr(), storage_key_data.len() as u32);
        }
    }

    fn rtm_ext_get_allocated_storage(
        key_data: Vec<u8>
    ) -> Vec<u8> {
        let mut written_out = 0;
        unsafe {
            let ptr = ext_get_allocated_storage(
                key_data.as_ptr(),
                key_data.len() as u32,
                &mut written_out
            );

            if ptr.is_null() {
                vec![]
            } else {
                slice::from_raw_parts(ptr, written_out as usize).to_vec()
            }
        }
    }

    fn rtm_ext_get_allocated_child_storage(
        storage_key_data: Vec<u8>,
        key_data: Vec<u8>,
    ) -> Vec<u8> {
        let mut written_out = 0;
        unsafe {
            let ptr = ext_get_allocated_child_storage(
                storage_key_data.as_ptr(),
                storage_key_data.len() as u32,
                key_data.as_ptr(),
                key_data.len() as u32,
                &mut written_out,
            );

            if ptr.is_null() {
                vec![]
            } else {
                slice::from_raw_parts(ptr, written_out as usize).to_vec()
            }
        }
    }

    fn rtm_ext_get_storage_into(
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

    fn rtm_ext_get_child_storage_into(
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

    fn rtm_ext_storage_root() -> Vec<u8> {
        let mut result = vec![0; 32];
        unsafe {
            ext_storage_root(result.as_mut_ptr());
        }
        result
    }

    fn rtm_ext_child_storage_root(
        storage_key_data: Vec<u8>,
    ) -> Vec<u8> {
        let mut written_out = 0;
        unsafe {
            let ptr = ext_child_storage_root(
                storage_key_data.as_ptr(),
                storage_key_data.len() as u32,
                &mut written_out,
            );
            slice::from_raw_parts(ptr, written_out as usize).to_vec()
        }
    }

    fn rtm_ext_storage_changes_root(
        parent_hash_data: Vec<u8>,
    ) -> Vec<u8> {
        let mut result = vec![0; 32];
        unsafe {
            ext_storage_changes_root(
                parent_hash_data.as_ptr(),
                parent_hash_data.len() as u32,
                result.as_mut_ptr()
            );
        }
        result
    }

    fn rtm_ext_blake2_256_enumerated_trie_root(
        values_data: Vec<u8>,
        lens_data: Vec<u32>,
    ) -> Vec<u8> {
        let mut result = vec![0; 32];
        unsafe {
            ext_blake2_256_enumerated_trie_root(
                values_data.as_ptr(),
                lens_data.as_ptr(),
                lens_data.len() as u32,
                result.as_mut_ptr(),
            );
        }
        result
    }

    fn rtm_ext_ed25519_public_keys(
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

    fn rtm_ext_ed25519_verify(
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

    fn rtm_ext_ed25519_generate(
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

    fn rtm_ext_ed25519_sign(
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

    fn rtm_ext_sr25519_public_keys(
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

    fn rtm_ext_sr25519_verify(
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

    fn rtm_ext_sr25519_generate(
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

    fn rtm_ext_sr25519_sign(
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

    fn rtm_ext_secp256k1_ecdsa_recover(
        msg_data: Vec<u8>,
        sig_data: Vec<u8>,
    ) -> Vec<u8> {
        let mut pubkey_data = vec![0;32];
        unsafe {
            ext_secp256k1_ecdsa_recover(
                msg_data.as_ptr(),
                sig_data.as_ptr(),
                pubkey_data.as_mut_ptr(),
            );
        }
        pubkey_data
    }

    fn rtm_ext_is_validator() -> u32 {
        unsafe { ext_is_validator() }
    }

    fn rtm_ext_submit_transaction(msg_data: Vec<u8>) -> u32 {
        unsafe {
            ext_submit_transaction(
                msg_data.as_ptr(),
                msg_data.len() as u32,
            )
        }
    }

    fn rtm_ext_network_state() -> Vec<u8> {
        let mut written_out = 0;
        unsafe {
            let ptr = ext_network_state(&mut written_out);
            slice::from_raw_parts(ptr, written_out as usize).to_vec()
        }
    }

    fn rtm_ext_local_storage_set(
        kind: u32,
        key: Vec<u8>,
        value: Vec<u8>,
    ) {
        unsafe {
            ext_local_storage_set(
                kind,
                key.as_ptr(),
                key.len() as u32,
                value.as_ptr(),
                value.len() as u32,
            );
        }
    }

    fn rtm_ext_local_storage_get(
        kind: u32,
        key: Vec<u8>,
    ) -> Vec<u8> {
        let mut value_len = 0;
        unsafe {
            let ptr = ext_local_storage_get(
                kind,
                key.as_ptr(),
                key.len() as u32,
                &mut value_len,
            );

            if ptr.is_null() {
                vec![]
            } else {
                slice::from_raw_parts(ptr, value_len as usize).to_vec()
            }
        }
    }

    fn rtm_ext_local_storage_compare_and_set(
        kind: u32,
        key: Vec<u8>,
        old_value: Vec<u8>,
        new_value: Vec<u8>,
    ) -> u32 {
        unsafe {
            ext_local_storage_compare_and_set(
                kind,
                key.as_ptr(),
                key.len() as u32,
                old_value.as_ptr(),
                old_value.len() as u32,
                new_value.as_ptr(),
                new_value.len() as u32,
            )
        }
    }
}

#[cfg(feature = "runtime-wasm")]
#[no_mangle]
pub extern "C" fn rtm_ext_sandbox_instantiate(
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

#[cfg(feature = "runtime-wasm")]
#[no_mangle]
pub extern "C" fn rtm_ext_sandbox_instance_teardown(instance_idx: u32) {
    unsafe {
        ext_sandbox_instance_teardown(instance_idx);
    }
}

#[cfg(feature = "runtime-wasm")]
#[no_mangle]
pub extern "C" fn rtm_ext_sandbox_invoke(
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

#[cfg(feature = "runtime-wasm")]
#[no_mangle]
pub extern "C" fn rtm_ext_sandbox_memory_new(initial: u32, maximum: u32) -> u32 {
    unsafe { ext_sandbox_memory_new(initial, maximum) }
}

#[cfg(feature = "runtime-wasm")]
#[no_mangle]
pub extern "C" fn rtm_ext_sandbox_memory_get(
    memory_idx: u32,
    offset: u32,
    buf_ptr: *mut u8,
    buf_len: u32,
) -> u32 {
    unsafe { ext_sandbox_memory_get(memory_idx, offset, buf_ptr, buf_len) }
}

#[cfg(feature = "runtime-wasm")]
#[no_mangle]
pub extern "C" fn rtm_ext_sandbox_memory_set(
    memory_idx: u32,
    offset: u32,
    val_ptr: *const u8,
    val_len: u32,
) -> u32 {
    unsafe { ext_sandbox_memory_set(memory_idx, offset, val_ptr, val_len) }
}

#[cfg(feature = "runtime-wasm")]
#[no_mangle]
pub extern "C" fn rtm_ext_sandbox_memory_teardown(memory_idx: u32) {
    unsafe {
        ext_sandbox_memory_teardown(memory_idx);
    }
}
