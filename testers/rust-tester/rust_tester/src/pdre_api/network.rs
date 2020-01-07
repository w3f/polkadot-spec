use crate::pdre_api::utils::{Runtime, Decoder};
use parity_scale_codec::Encode;

pub fn test_http() {
    let mut rtm = Runtime::new_offchain();

    // Request 1
    let req_id1 = rtm
        .call("rtm_ext_http_request_start", &("GET", "example.com", "").encode())
        .decode_u32();
    assert_eq!(req_id1, 0);

    // Request 2
    let req_id2 = rtm
        .call("rtm_ext_http_request_start", &("GET", "example.com", "").encode())
        .decode_u32();
    assert_eq!(req_id2, 1);

    // TODO...
}

pub fn test_network_state() {
    let mut rtm = Runtime::new_offchain();

    let res = rtm
        .call("rtm_ext_network_state", &[])
        .decode_vec();
    assert_eq!(res, vec![0, 0, 0]); // [PeerId, MultiaddressIPv4, MultiaddressIPv6]

    println!("Output (opaque): {:?}", res);

    // TODO...
}
