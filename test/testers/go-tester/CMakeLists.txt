include("${CMAKE_SOURCE_DIR}/cmake/GolangSimple.cmake")

# GO_GET(go_yaml github.com/go-yaml/yaml)
# GO_GET(go_badger github.com/dgraph-io/badger@v1.5.5-0.20190226225317-8115aed38f8f)
# GO_GET(go_snappy github.com/golang/snappy)

ADD_GO_INSTALLABLE_PROGRAM(go_tester ./...)
