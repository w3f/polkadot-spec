use crate::pdre_api::utils::{Decoder, ParsedInput, Runtime};
use parity_scale_codec::Encode;

pub fn test_chain_id() {
    let mut rtm = Runtime::new();

    let _res = rtm.call("rtm_ext_chain_id", &[]).decode_u64();
    // TODO...
}

pub fn test_is_validator() {
    let mut rtm = Runtime::new();

    let _res = rtm.call("rtm_ext_is_validator", &[]).decode_u32();
    // TODO...
}

pub fn test_submit_transaction(_input: ParsedInput) {
    let mut rtm = Runtime::new();

    let msg_data: &[u8] = &[];

    let _res = rtm
        .call("rtm_ext_submit_transaction", &msg_data.encode())
        .decode_u32();
    // TODO...
}

pub fn test_timestamp() {
    let mut rtm = Runtime::new();

    let _res = rtm.call("rtm_ext_timestamp", &[]).decode_u64();
    // TODO...
}

pub fn test_sleep_until(_input: ParsedInput) {
    let mut rtm = Runtime::new();

    let deadline = 0;

    let _res = rtm.call("rtm_ext_sleep_until", &deadline.encode());
    // TODO...
}

pub fn test_random_seed() {
    let mut rtm = Runtime::new();

    let seed_data: &[u8] = &[];

    let _res = rtm.call("rtm_ext_random_seed", &seed_data.encode());
    // TODO...
}
