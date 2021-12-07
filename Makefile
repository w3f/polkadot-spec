SOURCES := main.adoc $(wildcard ??_*/**.adoc)


.PHONY: html pdf clean


html: polkadot-spec-html/

pdf: polkadot-spec.pdf


polkadot-spec-html/: index.adoc $(SOURCES)
	asciidoctor -D $@ -r asciidoctor-multipage -b multipage_html5 $<

polkadot-spec.html: $(SOURCES)
	asciidoctor -o $@ $<

polkadot-spec.pdf: $(SOURCES)
	asciidoctor-pdf -o $@ -r asciidoctor-mathematical $<


clean:
	rm -rf polkadot-spec-html/ polkadot-spec.html polkadot-spec.pdf stem-*.svg
