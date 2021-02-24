use crate::host_api::utils::{ParsedInput, Runtime};
use parity_scale_codec::Encode;


pub fn ext_hashing_version_1(mut rtm: Runtime, func: &str, input: ParsedInput) {
    let data = input.get(0);

    let hash = rtm.call_and_decode::<Vec<u8>>(
        &["rtm_ext_hashing_", func, "_version_1"].join(""),
        &(data).encode()
    );

    println!("{}", hex::encode(hash));
}
