CHAPTERS := $(wildcard c??-*.tex)

SOURCES  := runtime-spec.tex $(CHAPTERS)


.PHONY: build pdf clean

build: pdf


pdf: polkadot-runtime-spec.pdf


polkadot-runtime-spec.pdf: $(SOURCES)
	lualatex --jobname $(basename $@) --shell-escape $<


clean:
	rm -f polkadot-runtime-spec.{aux,idx,log,out,pdf,toc}
