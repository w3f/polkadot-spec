use crate::pdre_api::utils::{str, Decoder, ParsedInput, Runtime};
use parity_scale_codec::Encode;

/// The Wasm function tests both the allocation and freeing of the buffer
pub fn ext_allocator_malloc_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let value = input.get(0);

    // Get invalid key
    let res = rtm
        .call("rtm_ext_allocator_malloc_version_1", &value.encode())
        .decode_val();
    assert_eq!(res, value);

    println!("{}", str(&res));
}

pub fn ext_allocator_free_version_1(input: ParsedInput) {
    ext_allocator_malloc_version_1(input)
}
