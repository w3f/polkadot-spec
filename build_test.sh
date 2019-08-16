#!/bin/bash

SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
cd ${SCRIPT_DIR}

mkdir -p build

# build kagome
cd implementations/cpp/kagome || exit
KAGOME_BUILD_DIR="${SCRIPT_DIR}/build/kagome"
mkdir -p ${KAGOME_BUILD_DIR}
cmake -DCMAKE_INSTALL_PREFIX=${KAGOME_BUILD_DIR}/install -B ${KAGOME_BUILD_DIR}
cmake --build ${KAGOME_BUILD_DIR} -- install || exit

cd ${SCRIPT_DIR}/build

cmake ..
make
make DESTDIR=bin install
