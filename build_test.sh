#!/bin/bash

SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

cd ${SCRIPT_DIR}

mkdir -p build
cd build

cmake .. -DCMAKE_CXX_COMPILER=g++-8
make -j 11
make DESTDIR=bin install
