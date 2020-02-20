use crate::pdre_api::utils::{Decoder, ParsedInput, Runtime, str};
use parity_scale_codec::Encode;

pub fn ext_allocator_malloc_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let value = input.get(0);

    // Get invalid key
    let res = rtm
        .call("rtm_allocator_malloc_version_1", &(value.len() as u32).encode())
        .decode_val();
    assert_eq!(res, value);

    println!("{}", str(&res));
}

pub fn ext_allocator_free_version_1(input: ParsedInput) {
    ext_allocator_malloc_version_1(input)
}