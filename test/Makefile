HOSTS    = substrate kagome gossamer
RUNTIMES = hostapi tester

ALIASES_ADAPTER := $(patsubst %,%-adapter,$(HOSTS))    $(patsubst %,%-adapter-legacy,$(HOSTS))
ALIASES_RUNTIME := $(patsubst %,%-runtime,$(RUNTIMES)) $(patsubst %,%-runtime-legacy,$(RUNTIMES))
ALIASES_HOST    := $(patsubst %,%-host,$(HOSTS))


.PHONY: all init adapters $(ALIASES_ADAPTER) runtimes $(ALIASES_RUNTIME) hosts $(ALIASES_HOST) test clean


all: adapters runtimes hosts


bin lib:
	mkdir -p $@/

init: bin lib


adapters: $(ALIASES_ADAPTER)

$(filter %-adapter,$(ALIASES_ADAPTER)): %-adapter: init
	make -C adapters/$*

$(filter %-legacy,$(ALIASES_ADAPTER)): %-adapter-legacy: init
	make -C adapters/$*-legacy


runtimes: $(ALIASES_RUNTIMES)

$(filter %-runtime,$(ALIASES_RUNTIME)): %-runtime: init
	make -C runtimes/$*

$(filter %-legacy,$(ALIASES_RUNTIME)): %-runtime-legacy: init
	make -C runtimes/$*-legacy


hosts: $(ALIASES_HOST)

$(ALIASES_HOST): %-host: init
	make -C hosts $*


test: all
	./runtests.jl


version:
	@for a in $(HOSTS); do echo -n "$$a-adapter: "; $(MAKE) -sC adapters/$$a $@; done
	@for a in $(HOSTS); do echo -n "$$a-adapter-legacy: "; $(MAKE) -sC adapters/$$a-legacy $@; done
	@for r in $(RUNTIMES); do echo -n "$$r-runtime: "; $(MAKE) -sC runtimes/$$r $@; done
	@for r in $(RUNTIMES); do echo -n "$$r-runtime-legacy: "; $(MAKE) -sC runtimes/$$r-legacy $@; done
	@make -sC hosts $@


clean:
	for a in $(HOSTS); do $(MAKE) -C adapters/$$a $@; done
	for a in $(HOSTS); do $(MAKE) -C adapters/$$a-legacy $@; done
	for t in $(RUNTIMES); do $(MAKE) -C runtimes/$$t $@; done
	for t in $(RUNTIMES); do $(MAKE) -C runtimes/$$t-legacy $@; done
	make -C hosts $@
	rm -rf bin/ lib/
