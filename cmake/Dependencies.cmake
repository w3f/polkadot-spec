# https://docs.hunter.sh/en/latest/packages/pkg/iroha-ed25519.html
hunter_add_package(iroha-ed25519)
find_package(ed25519 CONFIG REQUIRED)

# not in hunter, added in cmake/Hunter/config.cmake
hunter_add_package(sr25519)
find_package(sr25519 REQUIRED)

hunter_add_package(Boost COMPONENTS program_options random)
find_package(Boost CONFIG REQUIRED COMPONENTS program_options random)

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

hunter_add_package(libp2p)
find_package(libp2p REQUIRED)
