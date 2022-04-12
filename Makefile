SOURCES := index.adoc $(wildcard ??_*/*.adoc) $(wildcard ??_*/*/*.adoc)

CACHEDIR := cache/

.PHONY: default html pdf tex clean


default: html


html: polkadot-spec.html

pdf: polkadot-spec.pdf

tex: polkadot-spec.tex

$(CACHEDIR):
	mkdir -p $@

# TODO: Use attribute-missing=warn --failure-level=WARN

polkadot-spec.html: $(SOURCES) docinfo-header.html style.css asciidoctor-pseudocode.rb asciidoctor-mathjax3.rb
	asciidoctor -r ./asciidoctor-pseudocode.rb -r ./asciidoctor-mathjax3.rb -o $@ $<

polkadot-spec.pdf: $(SOURCES) $(CACHEDIR) asciidoctor-pseudocode.rb
	asciidoctor-pdf -a imagesoutdir=$(CACHEDIR) -r asciidoctor-mathematical -r ./asciidoctor-pseudocode.rb -o $@ $<

polkadot-spec.tex: $(SOURCES)
	asciidoctor-latex -o $@ $<


clean:
	rm -rf $(CACHEDIR) polkadot-spec.html polkadot-spec.pdf
