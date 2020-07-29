HOSTS    = substrate kagome gossamer
ADAPTERS = substrate-legacy wasm wasm-legacy
TESTERS  = host host-legacy

ALIASES_ADAPTER := $(patsubst %-legacy-adapter,%-adapter-legacy, $(patsubst %,%-adapter,$(HOSTS) $(ADAPTERS)))
ALIASES_TESTER  := $(patsubst %-legacy-tester,%-tester-legacy, $(patsubst %,%-tester,$(TESTERS)))
ALIASES_HOST    := $(patsubst %,%-host,$(HOSTS))


.PHONY: all init adapters $(ALIASES_ADAPTER) testers $(ALIASES_TESTER) hosts $(ALIASES_HOST) test clean


all: adapters testers hosts


bin lib:
	mkdir -p $@/

init: bin lib


adapters: $(ALIASES_ADAPTER)

$(filter %-adapter,$(ALIASES_ADAPTER)): %-adapter: init
	make -C adapters/$*

$(filter %-legacy,$(ALIASES_ADAPTER)): %-adapter-legacy: init
	make -C adapters/$*-legacy


testers: $(ALIASES_TESTER)

$(filter %-tester,$(ALIASES_TESTER)): %-tester: init
	make -C testers/$*

$(filter %-legacy,$(ALIASES_TESTER)): %-tester-legacy: init
	make -C testers/$*-legacy


hosts: $(ALIASES_HOST)

$(ALIASES_HOST): %-host: init
	make -C hosts $*


test: all
	./runtests.jl


clean:
	for a in $(HOSTS) $(ADAPTERS); do $(MAKE) -C adapters/$$a $@; done
	for t in $(TESTERS); do $(MAKE) -C testers/$$t $@; done
	make -C hosts clean
	rm -rf bin/ lib/
