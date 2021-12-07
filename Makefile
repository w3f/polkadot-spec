SOURCES := main.adoc $(wildcard ??_*/**.adoc)

.PHONY: html html5 pdf clean


html: $(SOURCES)
	asciidoctor main.adoc

html5: $(SOURCES)
	asciidoctor -r asciidoctor-multipage -b multipage_html5 -D html main.adoc

pdf: $(SOURCES)
	asciidoctor-pdf -r asciidoctor-mathematical -a mathematical-format=svg main.adoc


clean:
	rm -rf html/ main.html main.pdf
