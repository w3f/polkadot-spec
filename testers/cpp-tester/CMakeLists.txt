cmake_minimum_required(VERSION 3.12)

project(cpp-tester LANGUAGES CXX)

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


# Compile and link tester
add_executable(cpp-tester
  main.cpp
  scale_codec.cpp
  scale_codec.hpp
  trie.cpp
  subcommand_router.hpp
  trie.hpp
)

# FIXME This should not be necessary (needed to find "outcome/outcome.hpp")
target_include_directories(cpp-tester PUBLIC ${kagome_INCLUDE_DIRS})

target_link_libraries(cpp-tester
  Boost::program_options
  yaml-cpp
  kagome::hexutil
  kagome::buffer
  kagome::hexutil
  kagome::in_memory_storage
  kagome::trie_db_backend
  kagome::polkadot_trie
)

# Install result
include(GNUInstallDirs)

install(TARGETS cpp-tester
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
