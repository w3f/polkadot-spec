CHAPTERS   := $(wildcard c??-*.tm)

APPENDICES := $(wildcard a?-*.tm)

FIGURES    := $(wildcard figures/*.eps) $(wildcard figures/*.puml) $(wildcard figures/*.pdf)

GENERATED  := figures/c07-overview.eps

SOURCES    := host-spec.tm $(CHAPTERS) $(APPENDICES) $(FIGURES) $(GENERATED)


.PHONY: build pdf tex diff temp update clean

build: pdf


pdf: polkadot-host-spec.pdf

tex: polkadot-host-spec.tex

diff: polkadot-host-spec.diff.pdf

temp: $(GENERATED)


figures/c07-overview.eps: figures/c07-overview.puml
	plantuml -teps $<


polkadot-host-spec.pdf: $(SOURCES) host-spec.scm
	xvfb-run texmacs -b host-spec.scm -x "(convert-updated \"$$PWD/$<\" \"$$PWD/$@\")" --quit

polkadot-host-spec.tex: $(SOURCES) host-spec.scm
	xvfb-run texmacs -b host-spec.scm -x "(convert-expanded \"$$PWD/$<\" \"$$PWD/$@\")" --quit


REV     ?= HEAD
GITHASH := $(shell git rev-parse $(REV))

TMPDIR ?= /tmp
REVDIR := $(TMPDIR)/host-spec-$(GITHASH)

$(REVDIR):
	mkdir -p $@
	git archive --format=tar $(GITHASH) | (cd $@ && tar xf -)
	# Will require next release: make -C $(REVDIR) temp

polkadot-host-spec.diff.pdf: $(SOURCES) $(REVDIR) host-spec.scm
	xvfb-run texmacs -b host-spec.scm  -x "(compare-versions-expanded \"$(REVDIR)/host-spec.tm\" \"$$PWD/host-spec.tm\") (export-buffer \"$$PWD/$@\")" -q


update: $(SOURCES) host-spec.scm
	xvfb-run texmacs -b host-spec.scm -x "(update-all \"$$PWD/$<\" \"$(TMPDIR)\")" --quit

clean:
	rm -rf $(REVDIR) $(GENERATED) polkadot-host-spec.pdf polkadot-host-spec.tex polkadot-host-spec.diff.pdf

