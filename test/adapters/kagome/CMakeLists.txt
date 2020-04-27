cmake_minimum_required(VERSION 3.14)


# Setup toolchain (required by kagome and libp2p)
set(CMAKE_TOOLCHAIN_FILE
  "${CMAKE_SOURCE_DIR}/cmake/Toolchain.cmake"
  CACHE FILEPATH "Default toolchain"
)


# Setup hunter
include(cmake/HunterGate.cmake)
HunterGate(
    URL "https://github.com/soramitsu/soramitsu-hunter/archive/v0.23.253-soramitsu3.tar.gz"
    SHA1 "a5dcae9a2a6a37e214fae20655cfb24e3c0a660e"
    FILEPATH "${CMAKE_SOURCE_DIR}/cmake/HunterConfig.cmake"
)

set(CMAKE_FIND_PACKAGE_PREFER_CONFIG HUNTER_ENABLED)


# General config
project(kagome-adapter LANGUAGES CXX)


# Find dependencies
hunter_add_package(kagome)
hunter_add_package(yaml-cpp)

find_package(kagome REQUIRED)
find_package(yaml-cpp REQUIRED)

if(kagome_FOUND)
  message(STATUS "kagome CMake package found: ${kagome_DIR}")
  message(STATUS "kagome include dirs: ${kagome_INCLUDE_DIRS}")

  message(STATUS "kagome_LIBRARIES contains:")
  include(CMakePrintHelpers)
  cmake_print_properties(TARGETS ${kagome_LIBRARIES} kagome::binaryen_wasm_memory
    PROPERTIES 
      #LOCATION
      INTERFACE_INCLUDE_DIRECTORIES
      INTERFACE_LINK_LIBRARIES
  )
endif()


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
  src/main.cpp
  src/scale_codec.cpp
  src/scale_codec.hpp
  src/trie.cpp
  src/subcommand_router.hpp
  src/trie.hpp
  src/extension.cpp
  src/extension.hpp
  src/extension/storage.cpp
  src/extension/storage.hpp
  src/extension/network.cpp
  src/extension/network.hpp
  src/extension/child_storage.cpp
  src/extension/child_storage.hpp
  src/extension/crypto.cpp
  src/extension/crypto.hpp
  src/extension/helpers.cpp
  src/extension/helpers.hpp
)

# FIXME This should not be necessary, but not all public headers include from <kagome/..> (e.g. "outcome/outcome.hpp")
target_include_directories(kagome-adapter PUBLIC ${kagome_INCLUDE_DIRS})

target_link_libraries(kagome-adapter
  Boost::program_options
  yaml-cpp
  ${kagome_LIBRARIES}

  # FIXME Patched-in export required for hostapi testing
  kagome::binaryen_wasm_memory
)


# Install result
include(GNUInstallDirs)

install(TARGETS kagome-adapter
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
