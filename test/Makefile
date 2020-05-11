ADAPTERS = substrate substrate-legacy kagome gossamer

.PHONY: adapters test $(ADAPTERS)

adapters: $(ADAPTERS)

$(ADAPTERS):
	@$(MAKE) -C adapters/$@

test: adapters
	./runtests.jl
