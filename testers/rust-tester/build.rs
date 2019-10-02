/// Build script to compile `src/wasm_blob.rs` into WebAssembly.
/// For the sake of readability, multiple .arg() or .args()
/// are chained instead of using a single .args().
fn main() {
    println!("cargo:rerun-if-changed=build.rs");

    use std::process::Command;
    let _ = Command::new("rustc")
        .args(&["--target", "wasm32-unknown-unknown"])
        // generate dynamic system library
        .args(&["--crate-type", "cdylib"])
        // optimize (aka "--release" for cargo)
        .arg("-O")
        .arg("src/pdre_api/wasm_blob.rs")
        .status()
        .map(|status| {
            if !status.success() {
                panic!("Failed building wasm binary");
            }
        })
        .map_err(|_| {
            panic!("Failed to execute build command for wasm blob");
        });
}
