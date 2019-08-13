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

hunter_add_package(Boost COMPONENTS program_options)
find_package(Boost CONFIG REQUIRED COMPONENTS program_options)

hunter_add_package(leveldb)
find_package(leveldb CONFIG REQUIRED)

hunter_add_package(OpenSSL)
find_package(OpenSSL REQUIRED)

hunter_add_package(Microsoft.GSL)
find_package(Microsoft.GSL CONFIG REQUIRED)

hunter_add_package(xxhash)
find_package(xxhash CONFIG REQUIRED)

hunter_add_package(yaml-cpp)
find_package(yaml-cpp CONFIG REQUIRED)

hunter_add_package(spdlog)
find_package(spdlog CONFIG REQUIRED)

# The test helpers in various languages
add_subdirectory(test/testers)

#add_custom_target(git_submodule_init ALL COMMAND git submodule update --init --recursive --remote)

# The Julia tester
##############################
# TBA
