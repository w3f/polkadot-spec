function(cargo_build)
  include(CMakeCargoCommon)

  cmake_parse_arguments(CARGO "" "NAME" "" ${ARGN})
  string(REPLACE "-" "_" LIB_NAME ${CARGO_NAME})

  set(CARGO_TARGET_DIR ${CMAKE_CURRENT_BINARY_DIR})

  cargo_lib_file()
  message("lib file ${LIB_FILE}")

	if(IOS)
		set(CARGO_ARGS "lipo")
	else()
    set(CARGO_ARGS "build")
		list(APPEND CARGO_ARGS "--target" ${LIB_TARGET})
	endif()

  if(${LIB_BUILD_TYPE} STREQUAL "release")
    list(APPEND CARGO_ARGS "--release")
  endif()

  file(GLOB_RECURSE LIB_SOURCES "*.rs")

  set(CARGO_ENV_COMMAND ${CMAKE_COMMAND} -E env "CARGO_TARGET_DIR=${CARGO_TARGET_DIR}")

  add_custom_command(
    OUTPUT ${LIB_FILE}
    COMMAND ${CARGO_ENV_COMMAND} ${CARGO_EXECUTABLE} ARGS ${CARGO_ARGS}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    DEPENDS ${LIB_SOURCES}
    COMMENT "running cargo")
  add_custom_target(${CARGO_NAME}_target ALL DEPENDS ${LIB_FILE})
  add_library(${CARGO_NAME} STATIC IMPORTED GLOBAL)
  add_dependencies(${CARGO_NAME} ${CARGO_NAME}_target)
  set_target_properties(${CARGO_NAME} PROPERTIES IMPORTED_LOCATION ${LIB_FILE})
endfunction()
