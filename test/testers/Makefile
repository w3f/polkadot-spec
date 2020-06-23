TESTERS  = host host-legacy
BINARIES = $(patsubst %-legacy-tester,%-tester-legacy, $(patsubst %,%-tester,$(TESTERS)))

.PHONY: all $(TESTERS) $(BINARIES)

all: $(TESTERS)

$(TESTERS):
	$(MAKE) -C $@

$(BINARIES):
	$(MAKE) -C $(subst -tester,,$@)

clean:
	for t in $(TESTERS); do $(MAKE) -C $$t $@; done
