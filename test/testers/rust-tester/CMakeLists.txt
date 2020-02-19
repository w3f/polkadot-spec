enable_language(Rust)
include(CMakeCargo)

cargo_build(NAME rust_tester MEMBER)
cargo_build(NAME rust_tester_legacy MEMBER)
