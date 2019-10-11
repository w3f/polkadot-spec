use super::utils::NetworkApi;

//use substrate_offchain::testing::PendingRequest;

pub fn test_http() {
    let mut api = NetworkApi::new_with_offchain_context();

    // Request 1
    let req_id1 = api.rtm_ext_http_request_start("GET".as_bytes(), "example.com".as_bytes(), &[]);
    assert_eq!(req_id1, 0);

    // Request 2
    let req_id2 = api.rtm_ext_http_request_start("GET".as_bytes(), "example.com".as_bytes(), &[]);
    assert_eq!(req_id2, 1);

    // TODO...
}

pub fn test_network_state() {
    let mut api = NetworkApi::new_with_offchain_context();

    let mut written_out = 0;
    let res = api.rtm_ext_network_state(&mut written_out);
    assert_eq!(written_out, 3);
    assert_eq!(res, vec![0, 0, 0]); // [PeerId, MultiaddressIPv4, MultiaddressIPv6]

    println!("Output (opaque): {:?}", res);
}
