#!/bin/bash

mkdir -p build
cd build

cmake ..
make
make DESTDIR=bin install
