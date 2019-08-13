#!/bin/bash

SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
cd ${SCRIPT_DIR}

# build kagome
cd implementations/cpp/kagome || exit
mkdir -p build
cmake -DCMAKE_INSTALL_PREFIX=build/install -B build
cmake --build build -- install || exit

cd ${SCRIPT_DIR}

mkdir -p build
cd build

cmake ..
make
make DESTDIR=bin install
