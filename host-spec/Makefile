CHAPTERS   := $(wildcard c??-*.tm)
APPENDICES := $(wildcard a?-*.tm)
FIGURES    := $(wildcard figures/*.eps)

polkadot-host-spec.pdf: host-spec.tm $(CHAPTERS) $(APPENDICES) $(FIGURES)
	xvfb-run texmacs --convert $< $@ --quit
