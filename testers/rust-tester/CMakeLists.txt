enable_language(Rust)
include(CMakeCargo)

cargo_build(NAME scale_codec)
