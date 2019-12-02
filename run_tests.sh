#!/bin/bash

SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
cd ${SCRIPT_DIR}

echo "Starting building process..."
./build_test.sh > /dev/null

cd test
if [ "$1" = "verbose" ]; then
    julia runtests.jl $1
else
    julia -qL runtests.jl
fi

