include("${CMAKE_SOURCE_DIR}/cmake/GolangSimple.cmake")

ADD_GO_INSTALLABLE_PROGRAM(scale_codec_go scale_codec/scale_codec.go)
