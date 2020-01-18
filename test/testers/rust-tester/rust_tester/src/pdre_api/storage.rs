use crate::pdre_api::utils::{Decoder, ParsedInput, Runtime};
use parity_scale_codec::Encode;

fn str<'a>(input: &'a [u8]) -> &'a str {
    std::str::from_utf8(input).unwrap()
}

// Input: key, value
pub fn ext_storage_get(input: ParsedInput) {
    let mut rtm = Runtime::new();

    let key = input.get(0);
    let value = input.get(1);

    // Get invalid key
    let res = rtm
        .call("rtm_ext_storage_get", &key.encode());
        //.decode_vec();
    assert_eq!(res, [0u8; 0]);

    /*
    // Set key/value
    let mut data = vec![];
    data.extend_from_slice(&key);
    data.extend_from_slice(&value);
    let _ = rtm.call("rtm_ext_storage_set", &data);

    // Get valid key
    let res = rtm
        .call("rtm_ext_storage_get", &key.encode());
        //.decode_vec();
    assert_eq!(res, value);

    println!("{}", str(&res));
    */
}

// Input: key, value
pub fn ext_storage_set(input: ParsedInput) {
    // TODO
}