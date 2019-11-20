cmake_minimum_required (VERSION 3.0)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

set(CMAKE_TOOLCHAIN_FILE
    "${CMAKE_SOURCE_DIR}/cmake/toolchain/cxx17.cmake"
    CACHE
    FILEPATH
    "Default toolchain"
    )

include(cmake/HunterGate.cmake)

HunterGate(
    URL "https://github.com/ruslo/hunter/archive/v0.23.206.tar.gz"
    SHA1 "9cb4184e563ad45dbafb6755c0d588e5574838d3"
    FILEPATH ${CMAKE_CURRENT_LIST_DIR}/cmake/HunterConfig.cmake
)

project (PolkadotRuntimeEnvironmentTests)

include(cmake/Dependencies.cmake)

# The test helpers in various languages
add_subdirectory(test/testers)

#add_custom_target(git_submodule_init ALL COMMAND git submodule update --init --recursive --remote)

# The Julia tester
##############################
# TBA
