SUBDIRS = adapters hosts testers

# As we use pattern matching to forward build request to the right subfolder, phony will not work.
PHONIES := $(strip $(wildcard *-adapter) $(wildcard *-adapter-legacy) $(wildcard *-tester) $(wildcard *-tester-legacy) $(wildcard *-host))
ifdef PHONIES
  $(error Conflicting file(s) detected: $(PHONIES))
endif


.PHONY: all $(SUBDIRS)

all: $(SUBDIRS)


$(SUBDIRS):
	$(MAKE) -C $@


%-adapter:
	make -C adapters $@

%-adapter-legacy:
	make -C adapters $@


%-tester:
	make -C testers $@

%-tester-legacy:
	make -C testers $@


%-host:
	make -C hosts $@


test: all
	./runtests.jl


clean:
	for d in $(SUBDIRS); do $(MAKE) -C $$d $@; done
