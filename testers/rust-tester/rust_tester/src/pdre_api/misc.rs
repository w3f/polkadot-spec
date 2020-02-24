use crate::pdre_api::utils::{Decoder, ParsedInput, Runtime, str};
use parity_scale_codec::Encode;

// TODO: Call from Julia
pub fn ext_misc_print_num_version_1(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let value = input.get(0);

    // Get valid key
    let res = rtm
        .call("rtm_ext_misc_print_num_version_1", &(value).encode());
}
