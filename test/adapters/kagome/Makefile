.PHONY: all build install clean

all: install

build:
	cmake --DCMAKE_BUILD_TYPE=Release -S . -B build
	cmake --build build

install: build
	cp build/kagome-adapter ../../bin/

clean:
	rm -rf build
