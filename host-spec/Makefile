CHAPTERS   := $(wildcard c??-*.tm)
APPENDICES := $(wildcard a?-*.tm)

SOURCES := host-spec.tm $(CHAPTERS) $(APPENDICES)

FIGURES    := $(wildcard figures/*.eps)

polkadot-host-spec.pdf: $(SOURCES) $(FIGURES)
	xvfb-run texmacs --convert $< $@ --quit


REV     ?= HEAD
GITHASH := $(shell git rev-parse $(REV))

TMPDIR ?= /tmp
REVDIR := $(TMPDIR)/host-spec-$(GITHASH)

DIFF_SOURCES := $(patsubst %.tm,$(REVDIR)/%.tm,$(SOURCES))

$(REVDIR):
	mkdir -p $@
	git archive --format=tar $(GITHASH) | (cd $@ && tar xf -)

$(DIFF_SOURCES): $(REVDIR)

polkadot-host-spec.diff.pdf: $(SOURCES) $(DIFF_SOURCES) host-spec.scm
	xvfb-run texmacs -b host-spec.scm  -x "(compare-versions-expanded \"$(REVDIR)/host-spec.tm\" \"$$PWD/host-spec.tm\") (export-buffer \"$$PWD/$@\")" -q


all: build

build: polkadot-host-spec.pdf

diff: polkadot-host-spec.diff.pdf

clean:
	rm -rf $(REVDIR) polkadot-host-spec.pdf polkadot-host-spec.diff.pdf


.PHONY: all build diff clean
