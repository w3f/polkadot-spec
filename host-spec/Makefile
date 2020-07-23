CHAPTERS   := $(wildcard c??-*.tm)
APPENDICES := $(wildcard a?-*.tm)
FIGURES    := $(wildcard figures/*.eps)


polkadot-host-spec.pdf: host-spec.tm $(CHAPTERS) $(APPENDICES) $(FIGURES)
	xvfb-run texmacs --convert $< $@ --quit


REV  ?= HEAD
HASH := $(shell git rev-parse $(REV))

REVDIR := $(TEMPDIR)/host-spec-$(HASH)

DIFF_SRCS := $(patsubst %.tm,$(REVDIR)/%.tm,$(CHAPTERS) $(APPENDICES))
DIFF_PDFS := $(patsubst %.tm,%.diff.pdf,$(CHAPTERS) $(APPENDICES))

$(REVDIR):
	mkdir -p $@

$(DIFF_SRCS) $(REVDIR)/host-spec.tm: $(REVDIR)/%.tm: $(REVDIR)
	git show $(REV):host-spec/$*.tm > $@

$(DIFF_PDFS): %.diff.pdf: $(REVDIR)/%.tm %.tm
	xvfb-run texmacs -x "(load-buffer \"$$PWD/$*.tm\" :strict) (compare-with-older \"$(REVDIR)/$*.tm\") (export-buffer \"$$PWD/$@\")" -q

host-spec.diff.pdf: $(DIFF_SRCS) $(REVDIR)/host-spec.tm
	xvfb-run texmacs -x "(load-buffer \"$$PWD/host-spec.tm\" :strict) (compare-with-older \"$(REVDIR)/host-spec.tm\") (export-buffer \"$$PWD/$@\")" -q

diff: $(DIFF_PDFS)


clean:
	rm -rf $(REVDIR)

.PHONY: diff clean
