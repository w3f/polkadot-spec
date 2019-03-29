#!/bin/bash

./build_test.sh

cd test
julia -L runtests.jl

