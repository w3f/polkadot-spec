ADAPTERS = substrate substrate-legacy kagome gossamer
TESTERS  = host host-legacy

.PHONY: test adapters testers $(ADAPTERS) $(TESTERS)

test: adapters testers
	./runtests.jl

adapters: $(ADAPTERS)

testers: $(TESTERS)

$(ADAPTERS):
	@$(MAKE) -C adapters/$@

$(TESTERS):
	@$(MAKE) -C testers/$@

