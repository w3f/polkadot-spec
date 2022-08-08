TARGET := polkadot-spec
SOURCES := $(TARGET).adoc $(wildcard ??_*.adoc) $(wildcard ??_*/*.adoc) $(wildcard ??_*/*/*.adoc)

CACHEDIR := cache/

.PHONY: default html pdf tex clean


default: html

.SECONDEXPANSION:
html pdf tex: $(TARGET).$$@


$(CACHEDIR):
	mkdir -p $@

SHARED_MODULES := asciidoctor-pseudocode.rb asciidoctor-kaitai.rb
SHARED_FLAGS := -r ./asciidoctor-pseudocode.rb -r ./asciidoctor-kaitai.rb -r asciidoctor-bibtex -a attribute-missing=warn --failure-level=WARN --verbose

$(TARGET).html: $(SOURCES) $(SHARED_MODULES) asciidoctor-mathjax3.rb docinfo-header.html style.css
	asciidoctor $(SHARED_FLAGS) -r ./asciidoctor-mathjax3.rb -o $@ $<

$(TARGET).pdf: $(SOURCES) $(SHARED_MODULES) $(CACHEDIR)
	asciidoctor-pdf -a imagesoutdir=$(CACHEDIR) -r asciidoctor-mathematical $(SHARED_FLAGS) -o $@ $<

$(TARGET).tex: $(SOURCES)
	asciidoctor-latex $(SHARED_FLAGS) -o $@ $<


clean:
	rm -rf $(CACHEDIR) $(TARGET).{html,pdf,tex}

