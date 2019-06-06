include("${CMAKE_SOURCE_DIR}/cmake/GolangSimple.cmake")

GO_GET(go_yaml github.com/go-yaml/yaml)
GO_GET(go_badger github.com/dgraph-io/badger)
GO_GET(go_snappy github.com/golang/snappy)

ADD_GO_INSTALLABLE_PROGRAM(go_tester ./... go_yaml go_badger go_snappy)
