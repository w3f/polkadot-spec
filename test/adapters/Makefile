ADAPTERS = substrate kagome gossamer wasm substrate-legacy wasm-legacy
BINARIES = $(patsubst %-legacy-adapter,%-adapter-legacy, $(patsubst %,%-adapter,$(ADAPTERS)))

.PHONY: all $(ADAPTERS) $(BINARIES)

all: $(ADAPTERS)

$(ADAPTERS):
	$(MAKE) -C $@

$(BINARIES):
	$(MAKE) -C $(subst -adapter,,$@)

clean:
	for a in $(ADAPTERS); do $(MAKE) -C $$a $@; done
