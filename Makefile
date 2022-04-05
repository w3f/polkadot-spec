SOURCES := index.adoc $(wildcard ??_*/*.adoc) $(wildcard ??_*/*/*.adoc)

.PHONY: default html pdf tex clean


default: html


html: polkadot-spec.html

pdf: polkadot-spec.pdf

tex: polkadot-spec.tex

# TODO: Use attribute-missing=warn --failure-level=WARN

polkadot-spec.html: $(SOURCES) docinfo-header.html style.css asciidoctor-pseudocode.rb
	asciidoctor -r ./asciidoctor-pseudocode.rb -o $@ $<

polkadot-spec.pdf: $(SOURCES)
	asciidoctor-pdf -r asciidoctor-mathematical -o $@ $<

polkadot-spec.tex: $(SOURCES)
	asciidoctor-latex -o $@ $<


clean:
	rm -rf polkadot-spec.html polkadot-spec.pdf algo-*.svg stem-*.svg
