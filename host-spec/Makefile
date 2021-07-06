CHAPTERS   := $(wildcard c??-*.tm)

APPENDICES := $(wildcard a?-*.tm)

FIGURES    := $(wildcard figures/*.eps) $(wildcard figures/*.puml) $(wildcard figures/*.pdf)

GENERATED  := figures/c07-overview.eps

SOURCES    := host-spec.tm $(CHAPTERS) $(APPENDICES) $(FIGURES) $(GENERATED)


.PHONY: build pdf tex diff temp update deaux clean

build: pdf


pdf: polkadot-host-spec.pdf

tex: polkadot-host-spec.tex

diff: polkadot-host-spec.diff.pdf

html: html/index.html

temp: $(GENERATED)


figures/c07-overview.eps: figures/c07-overview.puml
	plantuml -teps $<


polkadot-host-spec.pdf: $(SOURCES) host-spec.scm
	xvfb-run texmacs -b host-spec.scm -x "(convert-updated \"$$PWD/$<\" \"$$PWD/$@\")" --quit

polkadot-host-spec.tex: $(SOURCES) host-spec.scm
	xvfb-run texmacs -b host-spec.scm -x "(convert-expanded \"$$PWD/$<\" \"$$PWD/$@\")" --quit


html/index.html: $(SOURCES) host-spec.scm
	mkdir -p html
	xvfb-run texmacs -b host-spec.scm -x "(convert-updated-expanded \"$$PWD/$<\" \"$$PWD/$@\" \"$(TMPDIR)\")" --quit


REV     ?= HEAD
GITHASH := $(shell git rev-parse $(REV))

TMPDIR ?= /tmp
REVDIR := $(TMPDIR)/host-spec-$(GITHASH)

$(REVDIR):
	mkdir -p $@
	git archive --format=tar $(GITHASH) | (cd $@ && tar xf -)
	# Will require next release: make -C $(REVDIR) temp

polkadot-host-spec.diff.pdf: $(SOURCES) $(REVDIR) host-spec.scm
	xvfb-run texmacs -b host-spec.scm  -x "(compare-versions-updated-expanded \"$(REVDIR)/host-spec.tm\" \"$$PWD/host-spec.tm\" \"$(TMPDIR)\") (export-buffer \"$$PWD/$@\")" -q


update: $(SOURCES) host-spec.scm
	xvfb-run texmacs -b host-spec.scm -x "(update-all \"$$PWD/$<\" \"$(TMPDIR)\")" --quit


define DEAUX_SED_REGEXP
	s@<\\$1|\([^>]*\)>.*</$1>@<$1|\1|>@g
endef

DETOC := $(call DEAUX_SED_REGEXP,table-of-contents)
DEGLY := $(call DEAUX_SED_REGEXP,the-glossary)
DEBIB := $(call DEAUX_SED_REGEXP,bibliography)
DEIDX := $(call DEAUX_SED_REGEXP,the-index)

deaux:
	sed -e '1h;2,$$H;$$!d;g' -e '$(DETOC)' -e '$(DEGLY)' -e '$(DEBIB)' -e '$(DEIDX)' -i host-spec.tm


clean:
	rm -rf $(REVDIR) $(GENERATED) html polkadot-host-spec.pdf polkadot-host-spec.tex polkadot-host-spec.diff.pdf

