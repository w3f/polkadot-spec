HOSTS    = substrate kagome gossamer
RUNTIMES = hostapi tester

ALIASES_ADAPTER := $(patsubst %,%-adapter,$(HOSTS))
ALIASES_RUNTIME := $(patsubst %,%-runtime,$(RUNTIMES))
ALIASES_HOST    := $(patsubst %,%-host,$(HOSTS))


.PHONY: all init adapters $(ALIASES_ADAPTER) runtimes $(ALIASES_RUNTIME) hosts $(ALIASES_HOST) test clean


all: adapters runtimes hosts


bin lib:
	mkdir -p $@/

init: bin lib


adapters: $(ALIASES_ADAPTER)

$(ALIASES_ADAPTER): %-adapter: init
	$(MAKE) -C adapters/$*


runtimes: $(ALIASES_RUNTIMES)

$(ALIASES_RUNTIME): %-runtime: init
	$(MAKE) -C runtimes/$*


hosts: $(ALIASES_HOST)

$(ALIASES_HOST): %-host: init
	$(MAKE) -C hosts $*


test: all
	./runtests.jl


version:
	@for a in $(HOSTS); do echo -n "$$a-adapter: "; $(MAKE) -sC adapters/$$a $@; done
	@for r in $(RUNTIMES); do echo -n "$$r-runtime: "; $(MAKE) -sC runtimes/$$r $@; done
	@make -sC hosts $@


clean:
	for a in $(HOSTS); do $(MAKE) -C adapters/$$a $@; done
	for t in $(RUNTIMES); do $(MAKE) -C runtimes/$$t $@; done
	$(MAKE) -C hosts $@
	rm -rf bin/ lib/
