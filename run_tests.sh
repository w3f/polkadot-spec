#!/bin/bash

SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
cd ${SCRIPT_DIR}

./build_test.sh

cd test
if [ "$1" = "verbose" ]; then
    julia runtests.jl $1
else
    julia -qL runtests.jl
fi
