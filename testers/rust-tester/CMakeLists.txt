enable_language(Rust)
include(CMakeCargo)

cargo_build(NAME scale_codec)

#TODO: currently only works for linux, customize it based on actual build values
set(CARGO_TARGET_DIR ${CMAKE_CURRENT_BINARY_DIR})
set(LIB_TARGET "x86_64-unknown-linux-gnu")
set(LIB_BUILD_TYPE "debug")

set(TARGET_FILE ${CARGO_TARGET_DIR}/${LIB_TARGET}/${LIB_BUILD_TYPE}/scale_codec)

add_custom_command(TARGET scale_codec_target POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy ${TARGET_FILE} ${CMAKE_CURRENT_BINARY_DIR}/${NAME})

add_custom_target(git_submodule_init COMMAND git submodule update --init --recursive)
add_dependencies(scale_codec_target git_submodule_init)
