set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

cmake_minimum_required (VERSION 3.0)
project (PolkadotRuntimeEnvironmentTests)

# The test helpers in various languages
add_subdirectory(test/testers)

add_custom_target(git_submodule_init ALL COMMAND git submodule update --init --recursive --remote)

# The Julia tester
##############################
# TBA
