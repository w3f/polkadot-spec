TARGET := polkadot-spec
SOURCES := $(TARGET).adoc $(wildcard ??_*.adoc) $(wildcard ??_*/*.adoc) $(wildcard ??_*/*/*.adoc)

CACHEDIR := cache/

.PHONY: default html pdf tex kaitai test test-metadata clean


default: html

.SECONDEXPANSION:
html pdf tex: $(TARGET).$$@


$(CACHEDIR):
	mkdir -p $@

SHARED_MODULES := asciidoctor-pseudocode.rb asciidoctor-kaitai.rb
SHARED_FLAGS := -r ./asciidoctor-pseudocode.rb -r ./asciidoctor-kaitai.rb -r asciidoctor-bibtex -a attribute-missing=warn --verbose

$(TARGET).html: $(SOURCES) $(SHARED_MODULES) asciidoctor-mathjax3.rb docinfo-header.html style.css
	asciidoctor $(SHARED_FLAGS) -r ./asciidoctor-mathjax3.rb -o $@ $< --failure-level=WARN

$(TARGET).pdf: $(SOURCES) $(SHARED_MODULES) $(CACHEDIR)
	asciidoctor-pdf -a imagesoutdir=$(CACHEDIR) -r asciidoctor-mathematical $(SHARED_FLAGS) -o $@ $<

$(TARGET).tex: $(SOURCES)
	asciidoctor-latex $(SHARED_FLAGS) -o $@ $<


kaitai: metadata.ksy

%.ksy: $(SOURCES) asciidoctor-kaitai.rb
	asciidoctor -r ./asciidoctor-kaitai.rb -b kaitai -o $@ $< --failure-level=WARN


test/metadata.rb: metadata.ksy
	ksc --target ruby --outdir ./test/ $<


test/metadata.bin:
	curl -X POST -H 'Content-Type: application/json' -d '{"id":"1", "jsonrpc":"2.0", "method":"state_getMetadata"}' 'https://rpc.polkadot.io' | jq .result | xxd -r -p > $@


test: test-metadata

test-metadata: test/scale.fixed.rb test/metadata.rb test/metadata.bin
	ruby ./test/test_metadata.rb


clean:
	rm -rf $(CACHEDIR) $(TARGET).{html,pdf,tex} metadata.ksy test/{scale,metadata}.rb test/metadata.bin
