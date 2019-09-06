cmake_minimum_required(VERSION 3.14)

project(KagomeCrossTestCLI)

set(CMAKE_CXX_STANDARD 17)

set(KAGOME_BUILD_DIR ${CMAKE_BINARY_DIR}/kagome)
execute_process(
    COMMAND cmake -DCMAKE_INSTALL_PREFIX=${KAGOME_BUILD_DIR}/install -B ${KAGOME_BUILD_DIR}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/implementations/cpp/kagome
    RESULT_VARIABLE KAGOME_CMAKE_GEN_RESULT
)
if (NOT ${KAGOME_CMAKE_GEN_RESULT} STREQUAL "0")
    message(FATAL_ERROR "Error running cmake on kagome: ${KAGOME_CMAKE_GEN_RESULT}")
endif ()
execute_process(COMMAND cmake --build ${KAGOME_BUILD_DIR} -- -j6
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/implementations/cpp/kagome
    RESULT_VARIABLE KAGOME_BUILD_RESULT
    )
if (NOT ${KAGOME_BUILD_RESULT} STREQUAL "0")
    message(FATAL_ERROR "Error building kagome: ${KAGOME_CMAKE_GEN_RESULT}")
endif ()
execute_process(COMMAND cmake --build ${KAGOME_BUILD_DIR} -- install
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/implementations/cpp/kagome
    RESULT_VARIABLE KAGOME_INSTALL_RESULT
    )
if (NOT ${KAGOME_INSTALL_RESULT} STREQUAL "0")
    message(FATAL_ERROR "Error installing kagome: ${KAGOME_CMAKE_GEN_RESULT}")
endif ()

add_executable(kagome_tester
    main.cpp
    scale_codec.cpp
    scale_codec.hpp
    trie.cpp
    subcommand_router.hpp
    trie.hpp)

include(${CMAKE_SOURCE_DIR}/build/kagome/install/lib/cmake/kagome/kagomeConfig.cmake)

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
