#!/bin/bash

SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
cd ${SCRIPT_DIR}

./build_test.sh

cd test
julia -qL runtests.jl
