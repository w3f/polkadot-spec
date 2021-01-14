CHAPTERS := $(wildcard c??-*.tex)

SOURCES  := runtime-spec.tex $(CHAPTERS)


.PHONY: build pdf clean

build: pdf


pdf: polkadot-runtime-spec.pdf

diff: polkadot-runtime-spec.diff.pdf


polkadot-runtime-spec.pdf: $(SOURCES)
	latexmk -jobname=$(basename $@) -pdflua $<


REV     ?= HEAD
GITHASH := $(shell git rev-parse $(REV))

TMPDIR ?= /tmp
REVDIR := $(TMPDIR)/runtime-spec-$(GITHASH)

$(REVDIR):
	mkdir -p $@
	git archive --format=tar $(GITHASH) | (cd $@ && tar xf -)

polkadot-runtime-spec.diff.tex: $(SOURCES) $(REVDIR)
	latexdiff --flatten "$(REVDIR)/runtime-spec.tex" "$$PWD/runtime-spec.tex" > $@
	# Remove diff on alignat column count (causes crash)
	sed -i 's@\\begin{alignat\*}{\\DIFadd{\([0-9]\+\)}}@\\begin{alignat\*}{\1}@g' $@

polkadot-runtime-spec.diff.pdf: polkadot-runtime-spec.diff.tex
	latexmk -pdflua $<


clean:
	rm -rf $(REVDIR) polkadot-runtime-spec{,.diff}.{aux,fdb_latexmk,fls,idx,ilg,ind,log,out,pdf,pytxcode,tex,toc}
