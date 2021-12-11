SOURCES := main.adoc $(wildcard ??_*/*.adoc) $(wildcard ??_*/*/*.adoc)

.PHONY: default html pdf clean


default: multi-html


html: polkadot-spec.html

multi-html: polkadot-spec-html/

pdf: polkadot-spec.pdf


polkadot-spec.html: $(SOURCES)
	asciidoctor -o $@ $<

polkadot-spec-html/: index.adoc $(SOURCES)
	asciidoctor -D $@ -r asciidoctor-multipage -b multipage_html5 $<

polkadot-spec.pdf: $(SOURCES)
	asciidoctor-pdf -o $@ -r asciidoctor-mathematical $<


clean:
	rm -rf polkadot-spec.html polkadot-spec-html/ polkadot-spec.pdf algo-*.svg stem-*.svg
