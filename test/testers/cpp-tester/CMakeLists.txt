cmake_minimum_required(VERSION 3.14)

project(KagomeCrossTestCLI)

set(CMAKE_CXX_STANDARD 17)

include(${CMAKE_SOURCE_DIR}/build/kagome/install/lib/cmake/kagome/kagomeConfig.cmake)

add_executable(kagome_tester
    main.cpp
    scale_codec.cpp
    scale_codec.hpp
    trie.cpp
    subcommand_router.hpp
    trie.hpp)

target_include_directories(kagome_tester PUBLIC ${kagome_INCLUDE_DIRS})

target_link_libraries(kagome_tester
    Boost::program_options
    leveldb::leveldb
    ${kagome_LIBRARIES}
    yaml-cpp::yaml-cpp
    )

include(GNUInstallDirs)

install(TARGETS kagome_tester
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    FRAMEWORK DESTINATION ${CMAKE_INSTALL_PREFIX}
    )
