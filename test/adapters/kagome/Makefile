.PHONY: all build enable-bincache disable-bincache enable-hunter disable-hunter install version clean

all: install

build:
	cmake -DCMAKE_BUILD_TYPE=Debug -S . -B build
	cmake --build build

enable-bincache:
	cmake -DHUNTER_USE_CACHE_SERVERS=YES -S . -B build

disable-bincache:
	cmake -DHUNTER_USE_CACHE_SERVERS=NO -S . -B build

enable-hunter:
	cmake -DHUNTER_ENABLED=true -S . -B build

disable-hunter:
	cmake -DHUNTER_ENABLED=false -S . -B build

install: build
	cp build/kagome-adapter ../../bin/

version:
	@grep "github.com/soramitsu/kagome" cmake/HunterConfig.cmake | grep -o -E "[0-9a-f]{40}"

clean:
	rm -rf build
