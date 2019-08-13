enable_language(Rust)
include(CMakeCargo)

cargo_build(NAME rust_tester)
