VERSION=0.0.1
LANG1=fra
LANG2=por
LANG2b=por_BR
PREFIX1=$(LANG1)-$(LANG2)
PREFIX1b=$(LANG1)-$(LANG2b)
PREFIX2=$(LANG2)-$(LANG1)
BASENAME=apertium-$(PREFIX1)

VAR1=std
VAR2=eco
PREFVAR1=#dejar en blanco
#PREFVAR2=eco-
TARGETS_COMMON = $(PREFIX1).automorf.bin $(PREFIX1).autobil.bin $(PREFIX1).autogen.bin \
     $(PREFIX1).autopgen.bin $(PREFIX2).automorf.bin $(PREFIX2).autobil.bin \
     $(PREFIX2).autogen.bin $(PREFIX2).autopgen.bin \
     $(PREFIX1).t1x.bin $(PREFIX1).t1x-old.bin $(PREFIX1).t2x.bin $(PREFIX1).t3x.bin \
     $(PREFIX2).t1x.bin $(PREFIX2).t1x-old.bin $(PREFIX2).t2x.bin $(PREFIX2).t3x.bin

# This include defines goals for install-modes, .deps/.d and .mode files:
@ap_include@

###############################################################################
## Transducers, disambiguation rules, transfer
###############################################################################

$(PREFVAR1)$(PREFIX1).automorf.bin: $(BASENAME).$(LANG1).dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@ $(BASENAME).$(LANG1).acx

$(PREFVAR1)$(PREFIX1).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp lr --var-right=pt $< $@

$(PREFVAR1)$(PREFIX1).autogen.bin: $(BASENAME).$(LANG2).dix $(BASENAME).$(LANG2).acx
	apertium-validate-dictionary $<
	lt-comp rl --var=pt $< $@  $(BASENAME).$(LANG2).acx

$(PREFVAR1)$(PREFIX1).autopgen.bin: $(BASENAME).post-$(LANG2).dix
	apertium-validate-dictionary $(BASENAME).post-$(LANG2).dix
	lt-comp lr $(BASENAME).post-$(LANG2).dix $@

$(PREFVAR1)$(PREFIX1b).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp lr --var-right=br $< $@

$(PREFVAR1)$(PREFIX1b).autogen.bin: $(BASENAME).$(LANG2).dix
	apertium-validate-dictionary $<
	lt-comp rl --var=br $< $@

$(PREFVAR1)$(PREFIX2).automorf.bin: $(BASENAME).$(LANG2).dix $(BASENAME).$(LANG2).acx
	apertium-validate-dictionary $<
	lt-comp lr $< $@ $(BASENAME).$(LANG2).acx

$(PREFVAR1)$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp rl $< $@

$(PREFVAR1)$(PREFIX2).autogen.bin: $(BASENAME).$(LANG1).dix $(BASENAME).$(LANG2).acx
	apertium-validate-dictionary $<
	lt-comp rl --alt=$(VAR1) $< $@ $(BASENAME).$(LANG2).acx

$(PREFVAR1)$(PREFIX2).autopgen.bin: $(BASENAME).post-$(LANG1).dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@


# Transfer

$(PREFVAR1)$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFVAR1)$(PREFIX1).t1x-old.bin: $(BASENAME).$(PREFIX1).t1x-old
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFVAR1)$(PREFIX1).t2x.bin: $(BASENAME).$(PREFIX1).t2x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFVAR1)$(PREFIX1).t3x.bin: $(BASENAME).$(PREFIX1).t3x
	apertium-validate-postchunk $<
	apertium-preprocess-transfer $< $@

$(PREFVAR1)$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFVAR1)$(PREFIX2).t1x-old.bin: $(BASENAME).$(PREFIX2).t1x-old
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFVAR1)$(PREFIX2).t2x.bin: $(BASENAME).$(PREFIX2).t2x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFVAR1)$(PREFIX2).t3x.bin: $(BASENAME).$(PREFIX2).t3x
	apertium-validate-postchunk $<
	apertium-preprocess-transfer $< $@


apertium-fra-por.fra.dix: apertium-fra-por.fra.metadix
	@xsltproc buscaPar.xsl apertium-fra-por.fra.metadix | uniq > $$gen.xsl
	@xsltproc $$gen.xsl apertium-fra-por.fra.metadix >$@
	@rm $$gen.xsl

###############################################################################
## Distribution
###############################################################################

EXTRA_DIST=$(BASENAME).$(LANG1).dix $(BASENAME).$(PREFIX1).dix \
           $(BASENAME).post-$(LANG1).dix $(BASENAME).post-$(LANG2).dix \
           $(BASENAME).$(LANG2).dix $(BASENAME).$(LANG1).tsx \
           $(BASENAME).$(LANG2).tsx  \
           $(PREFIX1).prob $(PREFIX2).prob \
           buscaPar.xsl principal.xsl apertium-fra-por.fra.metadix \
           $(PREFIX1)-supervised.make $(PREFIX1)-unsupervised.make \
           $(PREFIX2)-supervised.make $(PREFIX2)-unsupervised.make \
           $(LANG1)-tagger-data/README $(LANG2)-tagger-data/README \
           $(BASENAME).$(PREFIX1).t1x $(BASENAME).$(PREFIX1).t2x \
           $(BASENAME).$(PREFIX1).t3x $(BASENAME).$(PREFIX2).t1x \
           $(BASENAME).$(PREFIX2).t2x $(BASENAME).$(PREFIX2).t3x \
           modes.xml  $(BASENAME).$(LANG1).acx alt.xsl translate-to-default-equivalent.xsl \
	   $(BASENAME).$(LANG2).acx

###############################################################################
## Installation
###############################################################################

apertium_fra_pordir=$(prefix)/share/apertium/$(BASENAME)/

# Files which should be installed to $(prefix)/share/apertium/$(BASENAME)/:
apertium_fra_por_DATA=$(TARGETS_COMMON) \
	$(PREFIX1).prob $(PREFIX2).prob \
	$(BASENAME).$(PREFIX1).t1x \
	$(BASENAME).$(PREFIX1).t1x-old \
	$(BASENAME).$(PREFIX1).t2x \
	$(BASENAME).$(PREFIX1).t3x \
	$(BASENAME).$(PREFIX2).t1x \
	$(BASENAME).$(PREFIX2).t1x-old \
	$(BASENAME).$(PREFIX2).t2x \
	$(BASENAME).$(PREFIX2).t3x

# All modes are created by the same goal, listing several will just give problems with make -j2
noinst_DATA=modes/$(PREFIX1).mode

install-data-local: install-modes

###############################################################################
## Cleanup
###############################################################################

CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes

###############################################################################
## Test
###############################################################################

test: all
	echo "Onde é" | apertium -d . por-fra | tee .test-mt
	@echo "Où est" > .test-ref
	@diff .test-ref .test-mt
	echo "La plume de ma" | apertium -d . fra-por | tee .test-mt
	@echo "A pluma de minha" > .test-ref
	@diff .test-ref .test-mt
	@rm .test-ref .test-mt
