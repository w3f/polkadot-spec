TARGET := polkadot-spec
SOURCES := $(TARGET).adoc $(wildcard ??_*.adoc) $(wildcard ??_*/*.adoc) $(wildcard ??_*/*/*.adoc)

KAITAI_EXPORTS := block metadata

YAML_EXPORTS := $(patsubst %,%.ksy,$(KAITAI_EXPORTS))
RUBY_EXPORTS := $(patsubst %,test/%.rb,$(KAITAI_EXPORTS))

KAITAI_TESTS := $(patsubst %,test-%,$(KAITAI_EXPORTS))

CACHEDIR := cache/

.PHONY: default html pdf tex kaitai test $(KAITAI_TESTS) check clean


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


kaitai: $(YAML_EXPORTS)

$(YAML_EXPORTS): %.ksy: $(SOURCES) asciidoctor-kaitai.rb
	asciidoctor -r ./asciidoctor-kaitai.rb -b kaitai -o $@ $< --failure-level=WARN


$(RUBY_EXPORTS): test/%.rb: %.ksy
	ksc --target ruby --outdir ./test/ $<


test/block.bin:
	polkadot export-blocks --to 10 --pruning archive --binary $@

test/metadata.bin:
	curl -X POST -H 'Content-Type: application/json' -d '{"id":"1", "jsonrpc":"2.0", "method":"state_getMetadata"}' 'https://rpc.polkadot.io' | jq .result | xxd -r -p > $@


test: $(KAITAI_TESTS)

$(KAITAI_TESTS): test-%: test/test-%.rb test/%.rb test/scale.fixed.rb test/%.bin
	ruby ./$<


check: 
	misspell -locale=US $(SOURCES)


clean:
	rm -rf $(CACHEDIR) $(TARGET).{html,pdf,tex} $(YAML_EXPORTS) $(RUBY_EXPORTS) test/scale.rb test/{blocks,metadata}.bin
