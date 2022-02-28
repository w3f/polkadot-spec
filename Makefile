SOURCES := index.adoc $(wildcard ??_*/*.adoc) $(wildcard ??_*/*/*.adoc)

.PHONY: default html pdf clean


default: multi-html


html: polkadot-spec.html

multi-html: polkadot-spec-html/

pdf: polkadot-spec.pdf


polkadot-spec.html: $(SOURCES) docinfo.html style.css
	asciidoctor -a docinfo=shared -o $@ $<

polkadot-spec-html/: $(SOURCES) style.css favicon.png
	asciidoctor -r asciidoctor-multipage -b multipage_html5 -D $@ $<
	cp favicon.png $@

polkadot-spec.pdf: $(SOURCES)
	asciidoctor-pdf -o $@ -r asciidoctor-mathematical $<


clean:
	rm -rf polkadot-spec.html polkadot-spec-html/ polkadot-spec.pdf algo-*.svg stem-*.svg
