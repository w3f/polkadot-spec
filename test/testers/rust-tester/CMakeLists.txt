enable_language(Rust)
include(CMakeCargo)
include(CMakeCargoCommon)

cargo_build(NAME scale_codec)
cargo_lib_file()

set(TARGET_FILE ${CMAKE_CURRENT_BINARY_DIR}/${LIB_TARGET}/${LIB_BUILD_TYPE}/scale_codec)

install(FILES ${TARGET_FILE} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/${NAME})
