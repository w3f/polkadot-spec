TARGET := polkadot-spec
SOURCES := $(TARGET).adoc $(wildcard ??_*.adoc) $(wildcard ??_*/*.adoc) $(wildcard ??_*/*/*.adoc)

CACHEDIR := cache/

.PHONY: default html pdf tex clean


default: html

.SECONDEXPANSION:
html pdf tex: $(TARGET).$$@


$(CACHEDIR):
	mkdir -p $@


SHARED_FLAGS := -r ./asciidoctor-pseudocode.rb -r asciidoctor-bibtex -a attribute-missing=warn --failure-level=WARN --verbose

$(TARGET).html: $(SOURCES) docinfo-header.html style.css asciidoctor-pseudocode.rb asciidoctor-mathjax3.rb
	asciidoctor $(SHARED_FLAGS) -r ./asciidoctor-mathjax3.rb -o $@ $<

$(TARGET).pdf: $(SOURCES) $(CACHEDIR) asciidoctor-pseudocode.rb
	asciidoctor-pdf -a imagesoutdir=$(CACHEDIR) -r asciidoctor-mathematical $(SHARED_FLAGS) -o $@ $<

$(TARGET).tex: $(SOURCES)
	asciidoctor-latex $(SHARED_FLAGS) -o $@ $<


check: 
	misspell -locale=US $(SOURCES)

clean:
	rm -rf $(CACHEDIR) $(TARGET).{html,pdf,tex}

