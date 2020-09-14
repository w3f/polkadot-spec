CHAPTERS   := $(wildcard c??-*.tm) $(wildcard c??-*.tex) $(wildcard c??-*.md)

SECTIONS   := $(wildcard anv/s??-*.tex)

APPENDICES := $(wildcard a?-*.tm)

GENERATED  := c08-messaging.tmp.tex

SOURCES    := host-spec.tm  $(CHAPTERS) $(SECTIONS) $(APPENDICES) $(GENERATED)

FIGURES    := $(wildcard figures/*.eps) $(wildcard figures/*.svg)


.PHONY: all build tex diff clean

all: pdf


pdf: polkadot-host-spec.pdf

tex: polkadot-host-spec.tex

diff: polkadot-host-spec.diff.pdf

temp: $(GENERATED)


c08-messaging.tmp.tex: c08-messaging.md
	pandoc --top-level-division=chapter --from markdown-auto_identifiers $< -o $@


polkadot-host-spec.pdf: $(SOURCES) $(FIGURES) host-spec.scm
	xvfb-run texmacs -b host-spec.scm -x "(convert-updated \"$$PWD/$<\" \"$$PWD/$@\")" --quit

polkadot-host-spec.tex: $(SOURCES) $(FIGURES) host-spec.scm
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


clean:
	rm -rf $(REVDIR) $(GENERATED) polkadot-host-spec.pdf polkadot-host-spec.tex polkadot-host-spec.diff.pdf

