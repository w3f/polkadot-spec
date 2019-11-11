
hunter_config(
    Boost
    VERSION 1.70.0-p0
)

hunter_config(sr25519
    URL https://github.com/Warchant/sr25519-crust/archive/1.0.1.tar.gz
    SHA1 3005d79b23b92ff27848c24a7751543a03a2dd13
    )

hunter_config(
    GTest
    VERSION 1.8.0-hunter-p11
    CMAKE_ARGS "CMAKE_CXX_FLAGS=-Wno-deprecated-copy"
)

hunter_config(
    libp2p
    URL https://github.com/soramitsu/libp2p/archive/d67d8355bfb16f4730c70e2c8fad4a87e60bb4b5.zip
    SHA1 b5ac58f102b6bffb981050583d6a3ca70e9da461
    CMAKE_ARGS TESTING=OFF
)

hunter_config(
    spdlog
    URL https://github.com/gabime/spdlog/archive/v1.4.2.zip
    SHA1 4b10e9aa17f7d568e24f464b48358ab46cb6f39c
)

