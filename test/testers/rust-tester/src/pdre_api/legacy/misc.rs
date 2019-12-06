use crate::pdre_api::ParsedInput;
use super::utils::MiscApi;

pub fn test_chain_id() {
    let mut api = MiscApi::new();

    let _res = api.rtm_ext_chain_id();
    // TODO...
}

pub fn test_is_validator() {
    let mut api = MiscApi::new();

    let _res = api.rtm_ext_is_validator();
    // TODO...
}

pub fn test_submit_transaction(_input: ParsedInput) {
    let mut api = MiscApi::new();

    let msg_data = [];

    let _res = api.rtm_ext_submit_transaction(&msg_data);
    // TODO...
}

pub fn test_timestamp() {
    let mut api = MiscApi::new();

    let _res = api.rtm_ext_timestamp();
    // TODO...
}

pub fn test_sleep_until(_input: ParsedInput) {
    let mut api = MiscApi::new();

    let deadline = 0;

    let _res = api.rtm_ext_sleep_until(deadline);
    // TODO...
}

pub fn test_random_seed() {
    let mut api = MiscApi::new();

    let seed_data = [];

    let _res = api.rtm_ext_random_seed(&seed_data);
    // TODO...
}