CHAPTERS := $(wildcard c??-*.tex)

SOURCES  := runtime-spec.tex $(CHAPTERS)


.PHONY: build pdf clean

build: pdf


pdf: polkadot-runtime-spec.pdf


polkadot-runtime-spec.pdf: $(SOURCES)
	latexmk -jobname=$(basename $@) -pdflua $<


clean:
	latexmk -jobname=polkadot-runtime-spec -C runtime-spec.tex
	rm -f polkadot-runtime-spec.pytxcode
