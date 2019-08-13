
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
