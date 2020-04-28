cmake_minimum_required(VERSION 3.12)

project(kagome-adapter LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)

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
