use super::utils::NetworkApi;

//use substrate_offchain::testing::PendingRequest;

pub fn test_http() {
    let mut api = NetworkApi::new_with_offchain_context();

    // Request 1
    let req_id1 = api.rtm_ext_http_request_start("GET".as_bytes(), "example.com".as_bytes(), &[]);
    assert_eq!(req_id1, 0);
    let res = api.rtm_ext_http_request_add_header(req_id1, b"User-Agent", b"Spec Tester");
    assert_eq!(res, 0);

    // Request 2
    let req_id2 = api.rtm_ext_http_request_start("GET".as_bytes(), "example.com".as_bytes(), &[]);
    assert_eq!(req_id2, 1);
    let res = api.rtm_ext_http_request_add_header(req_id2, b"User-Agent", b"Spec Tester");
    assert_eq!(res, 0);

    // Set expected requests for TestOffchainExt
    /*
    api.dbg_http_expect_request(
        0,
        PendingRequest {
            method: "GET".to_string(),
            uri: "example.com".to_string(),
            body: vec![],
            headers: vec![("User-Agent".to_string(), "Spec Tester".to_string())],
            sent: true,
            ..Default::default()
        },
    );
    */

    //let mut _statuses = [0; 8]; // 4-bytes per id
    //api.rtm_ext_http_response_wait(&[req_id1, req_id2], &mut statuses, 0); // 0 => Block forever

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
