hunter_add_package(yaml-cpp)
find_package(yaml-cpp REQUIRED)

# Fix inconsistency between hunterized and upstream package (+ CMake oddity fix)
if(NOT TARGET yaml-cpp)
  set_target_properties(yaml-cpp::yaml-cpp PROPERTIES IMPORTED_GLOBAL true)
  add_library(yaml-cpp ALIAS yaml-cpp::yaml-cpp)
endif()

hunter_add_package(kagome)
find_package(kagome REQUIRED CONFIG)

message(STATUS "Found kagome: ${kagome_INCLUDE_DIRS}")

# FIXME Kagome's package config should do all this!
find_package(Boost REQUIRED COMPONENTS filesystem program_options random)
find_package(schnorrkel_crust REQUIRED)
find_package(libsecp256k1 REQUIRED)
find_package(leveldb REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(xxhash REQUIRED)
find_package(spdlog REQUIRED)
find_package(libp2p REQUIRED)
find_package(binaryen REQUIRED)
