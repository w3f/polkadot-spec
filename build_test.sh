#!/bin/bash

git submodule update --init --recursive

SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
cd ${SCRIPT_DIR}

mkdir -p build
cd build

cmake ..
make
make DESTDIR=bin install
