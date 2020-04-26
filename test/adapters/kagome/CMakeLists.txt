cmake_minimum_required(VERSION 3.14)

# Setup toolchain (required by kagome and libp2p)
set(CMAKE_TOOLCHAIN_FILE
  "${CMAKE_SOURCE_DIR}/CMakeToolchain.txt"
  CACHE FILEPATH "Default toolchain"
)

# Setup hunter
set(HUNTER_URL "https://github.com/soramitsu/soramitsu-hunter/archive/v0.23.253-soramitsu3.tar.gz")
set(HUNTER_SHA1 "a5dcae9a2a6a37e214fae20655cfb24e3c0a660e")

set(HUNTER_PACKAGES kagome yaml-cpp)

include(FetchContent)
FetchContent_Declare(SetupHunter GIT_REPOSITORY https://github.com/cpp-pm/gate)
FetchContent_MakeAvailable(SetupHunter)

set(CMAKE_FIND_PACKAGE_PREFER_CONFIG ${HUNTER_ENABLED})


# General config
project(kagome-adapter LANGUAGES CXX)


# Find dependencies
find_package(kagome REQUIRED)
find_package(yaml-cpp REQUIRED)

# FIXME Kagome's package config should do all this!
find_package(ed25519 REQUIRED)
find_package(sr25519 REQUIRED)
find_package(Boost REQUIRED COMPONENTS program_options random)
find_package(leveldb REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(xxhash REQUIRED)
find_package(spdlog REQUIRED)
find_package(libp2p REQUIRED)
find_package(binaryen REQUIRED)


# Compile and link tester
add_executable(kagome-adapter
  main.cpp
  scale_codec.cpp
  scale_codec.hpp
  trie.cpp
  subcommand_router.hpp
  trie.hpp
  extension.cpp
  extension.hpp
  extension/storage.cpp
  extension/storage.hpp
  extension/network.cpp
  extension/network.hpp
  extension/child_storage.cpp
  extension/child_storage.hpp
  extension/crypto.cpp
  extension/crypto.hpp
  extension/helpers.cpp
  extension/helpers.hpp
)

# FIXME This should not be necessary (needed to find "outcome/outcome.hpp")
target_include_directories(kagome-adapter PUBLIC ${kagome_INCLUDE_DIRS})

target_link_libraries(kagome-adapter
  Boost::program_options
  yaml-cpp
  ${kagome_LIBRARIES}

  # FIXME Missing CMake Interface dependency
  binaryen::binaryen

  # FIXME Patched-in export required for testing
  kagome::binaryen_wasm_memory
)


# Install result
include(GNUInstallDirs)

install(TARGETS kagome-adapter
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
