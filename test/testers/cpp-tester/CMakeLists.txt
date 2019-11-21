cmake_minimum_required(VERSION 3.13)

project(KagomeCrossTestCLI)

set(CMAKE_CXX_STANDARD 17)

set(KAGOME_BUILD_DIR ${CMAKE_BINARY_DIR}/kagome)

# triggers a fatal error if the process call doesn't succeed
function (execute_vital_process)
    cmake_parse_arguments(PARSE_ARGV 0 ARG ""
        "DESCRIPTION" "COMMAND")

    execute_process(
        COMMAND ${ARG_COMMAND}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/implementations/cpp/kagome
        RESULT_VARIABLE COMMAND_RESULT
    )
    if (NOT ${COMMAND_RESULT} STREQUAL "0")
        message(FATAL_ERROR "Error running ${ARG_DESCRIPTION} on kagome: ${COMMAND_RESULT}")
    endif ()
endfunction()

execute_vital_process(
	COMMAND cmake -DCMAKE_INSTALL_PREFIX=${KAGOME_BUILD_DIR}/install -B ${KAGOME_BUILD_DIR}
    DESCRIPTION "CMake files generation")
execute_vital_process(COMMAND cmake --build ${KAGOME_BUILD_DIR} 
    DESCRIPTION build)
execute_vital_process(COMMAND cmake --build ${KAGOME_BUILD_DIR} -- install
    DESCRIPTION install)

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
    yaml-cpp::yaml-cpp
    ${kagome_LIBRARIES}
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
