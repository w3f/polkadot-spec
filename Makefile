SOURCES := index.adoc $(wildcard ??_*/*.adoc) $(wildcard ??_*/*/*.adoc)

.PHONY: default html pdf clean


default: multi-html

<<<<<<< HEAD

html: polkadot-spec.html

multi-html: polkadot-spec-html/
=======
>>>>>>> 5550882f (ci: clean up build targets)

html: polkadot-spec.html

multi-html: polkadot-spec-html/

pdf: polkadot-spec.pdf

<<<<<<< HEAD
polkadot-spec.html: $(SOURCES) docinfo.html style.css
	asciidoctor -a docinfo=shared -o $@ $<
=======
>>>>>>> 5550882f (ci: clean up build targets)

polkadot-spec-html/: $(SOURCES) style.css favicon.png
	asciidoctor -r asciidoctor-multipage -b multipage_html5 -D $@ $<
	cp favicon.png $@

polkadot-spec-html/: index.adoc $(SOURCES)
	asciidoctor -D $@ -r asciidoctor-multipage -b multipage_html5 $<

polkadot-spec.pdf: $(SOURCES)
	asciidoctor-pdf -o $@ -r asciidoctor-mathematical $<


clean:
<<<<<<< HEAD
	rm -rf polkadot-spec.html polkadot-spec-html/ polkadot-spec.pdf algo-*.svg stem-*.svg
=======
	rm -rf polkadot-spec.html polkadot-spec-html/ polkadot-spec.pdf stem-*.svg
>>>>>>> 5550882f (ci: clean up build targets)
