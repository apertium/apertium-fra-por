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
     $(PREFIX1).t1x.bin $(PREFIX1).t2x.bin $(PREFIX1).t3x.bin \
     $(PREFIX2).t1x.bin $(PREFIX2).t2x.bin $(PREFIX2).t3x.bin

TARGETS = $(TARGETS_COMMON) trules-$(PREFIX1).bin trules-$(PREFIX2).bin \
          trules-$(PREFIX1).xml trules-$(PREFIX2).xml

$(PREFVAR1)$(LANG2).dix: $(BASENAME).$(LANG2).dix
	./filter.sh pt left $(BASENAME).$(LANG2).dix >$@

$(PREFVAR1)$(LANG2b).dix: $(BASENAME).$(LANG2).dix
	./filter.sh br left $(BASENAME).$(LANG2).dix >$@

$(PREFVAR1)$(LANG1).dix: $(BASENAME).$(LANG1).dix
	xsltproc --stringparam alt $(VAR1) alt.xsl $< >$@

#$(PREFVAR2)$(LANG1).dix: $(BASENAME).$(LANG1).dix
#	xsltproc --stringparam alt $(VAR2) alt.xsl $< >$@

#$(PREFVAR2)$(LANG2).dix: $(BASENAME).$(LANG2).dix
#	xsltproc --stringparam alt $(VAR2) alt.xsl $< >$@

$(PREFVAR1)$(PREFIX1).dix: $(BASENAME).$(PREFIX1).dix
	./filter.sh pt right $(BASENAME).$(PREFIX1).dix >$@

$(PREFVAR1)$(PREFIX1b).dix: $(BASENAME).$(PREFIX1).dix
	./filter.sh br right $(BASENAME).$(PREFIX1).dix >$@

#$(PREFVAR2)$(PREFIX1).dix: common-$(PREFIX1).dix
#	xsltproc --stringparam alt $(VAR2) alt.xsl $< >$@


$(PREFVAR1)$(PREFIX1).automorf.bin:$(PREFVAR1)$(LANG1).dix
	apertium-validate-dictionary $(PREFVAR1)$(LANG1).dix
	lt-comp lr $(PREFVAR1)$(LANG1).dix $@ $(BASENAME).$(LANG1).acx

$(PREFVAR1)$(PREFIX1).autobil.bin: $(PREFVAR1)$(PREFIX1).dix
	apertium-validate-dictionary $(PREFVAR1)$(PREFIX1).dix
	lt-comp lr $(PREFVAR1)$(PREFIX1).dix $@

$(PREFVAR1)$(PREFIX1).autogen.bin: $(PREFVAR1)$(LANG2).dix
	apertium-validate-dictionary $(PREFVAR1)$(LANG2).dix
	lt-comp rl $(PREFVAR1)$(LANG2).dix $@  $(BASENAME).$(LANG2).acx

$(PREFVAR1)$(PREFIX1).autopgen.bin: $(BASENAME).post-$(LANG2).dix
	apertium-validate-dictionary $(BASENAME).post-$(LANG2).dix
	lt-comp lr $(BASENAME).post-$(LANG2).dix $@

$(PREFVAR1)$(PREFIX1b).automorf.bin:$(PREFVAR1)$(LANG1b).dix
	apertium-validate-dictionary $(PREFVAR1)$(LANG1b).dix
	lt-comp lr $(PREFVAR1)$(LANG1b).dix $@ $(BASENAME).$(LANG1).acx

$(PREFVAR1)$(PREFIX1b).autobil.bin: $(PREFVAR1)$(PREFIX1b).dix
	apertium-validate-dictionary $(PREFVAR1)$(PREFIX1b).dix
	lt-comp lr $(PREFVAR1)$(PREFIX1b).dix $@

$(PREFVAR1)$(PREFIX1b).autogen.bin: $(PREFVAR1)$(LANG2b).dix
	apertium-validate-dictionary $(PREFVAR1)$(LANG2b).dix
	lt-comp rl $(PREFVAR1)$(LANG2b).dix $@

#$(PREFVAR2)$(PREFIX1).automorf.bin: $(PREFVAR2)$(LANG1).dix
#	apertium-validate-dictionary $(PREFVAR2)$(LANG1).dix
#	lt-comp lr $(PREFVAR2)$(LANG1).dix $@  $(BASENAME).$(LANG1).acx
#
#$(PREFVAR2)$(PREFIX1).autobil.bin: $(PREFVAR2)$(PREFIX1).dix
#	apertium-validate-dictionary $(PREFVAR2)$(PREFIX1).dix
#	lt-comp lr $(PREFVAR2)$(PREFIX1).dix $@
#
#$(PREFVAR2)$(PREFIX1).autogen.bin: $(PREFVAR2)$(LANG2).dix
#	apertium-validate-dictionary $(PREFVAR2)$(LANG2).dix
#	lt-comp rl $(PREFVAR2)$(LANG2).dix $@ $(BASENAME).$(LANG1).acx
#
#$(PREFVAR2)$(PREFIX1).autopgen.bin: $(BASENAME).post-$(LANG2).dix
#	apertium-validate-dictionary $(BASENAME).post-$(LANG2).dix
#	lt-comp lr $(BASENAME).post-$(LANG2).dix $@

$(PREFVAR1)$(PREFIX2).automorf.bin: $(PREFVAR1)$(LANG2).dix
	apertium-validate-dictionary $(PREFVAR1)$(LANG2).dix
	lt-comp lr $(PREFVAR1)$(LANG2).dix $@ $(BASENAME).$(LANG2).acx

$(PREFVAR1)$(PREFIX2).autobil.bin: $(PREFVAR1)$(PREFIX1).dix
	apertium-validate-dictionary $(PREFVAR1)$(PREFIX1).dix
	lt-comp rl $(PREFVAR1)$(PREFIX1).dix $@

$(PREFVAR1)$(PREFIX2).autogen.bin: $(PREFVAR1)$(LANG1).dix
	apertium-validate-dictionary $(PREFVAR1)$(LANG1).dix
	lt-comp rl $(PREFVAR1)$(LANG1).dix $@ $(BASENAME).$(LANG2).acx

$(PREFVAR1)$(PREFIX2).autopgen.bin: $(BASENAME).post-$(LANG1).dix
	apertium-validate-dictionary $(BASENAME).post-$(LANG1).dix
	lt-comp lr $(BASENAME).post-$(LANG1).dix $@

#$(PREFVAR2)$(PREFIX2).automorf.bin: $(PREFVAR2)$(LANG2).dix
#	apertium-validate-dictionary $(PREFVAR2)$(LANG2).dix
#	lt-comp lr $(PREFVAR2)$(LANG2).dix $@
#
#$(PREFVAR2)$(PREFIX2).autobil.bin: $(PREFVAR2)$(PREFIX1).dix
#	apertium-validate-dictionary $(PREFVAR2)$(PREFIX1).dix
#	lt-comp rl $(PREFVAR2)$(PREFIX1).dix $@
#
#$(PREFVAR2)$(PREFIX2).autogen.bin: $(PREFVAR2)$(LANG1).dix
#	apertium-validate-dictionary $(PREFVAR2)$(LANG1).dix
#	lt-comp rl $(PREFVAR2)$(LANG1).dix $@
#
#$(PREFVAR2)$(PREFIX2).autopgen.bin: $(BASENAME).post-$(LANG1).dix
#	apertium-validate-dictionary $(BASENAME).post-$(LANG1).dix
#	lt-comp lr $(BASENAME).post-$(LANG1).dix $@

$(PREFVAR1)$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX1).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t1x $@

$(PREFVAR1)$(PREFIX1).t2x.bin: $(BASENAME).$(PREFIX1).t2x
	apertium-validate-interchunk $(BASENAME).$(PREFIX1).t2x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t2x $@

$(PREFVAR1)$(PREFIX1).t3x.bin: $(BASENAME).$(PREFIX1).t3x
	apertium-validate-postchunk $(BASENAME).$(PREFIX1).t3x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t3x $@

#$(PREFVAR2)$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
#	apertium-validate-transfer $(BASENAME).$(PREFIX1).t1x
#	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t1x $@
#
#$(PREFVAR2)$(PREFIX1).t2x.bin: $(BASENAME).$(PREFIX1).t2x
#	apertium-validate-interchunk $(BASENAME).$(PREFIX1).t2x
#	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t2x $@
#
#$(PREFVAR2)$(PREFIX1).t3x.bin: $(BASENAME).$(PREFIX1).t3x
#	apertium-validate-postchunk $(BASENAME).$(PREFIX1).t3x
#	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t3x $@

$(PREFVAR1)$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX2).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t1x $@

$(PREFVAR1)$(PREFIX2).t2x.bin: $(BASENAME).$(PREFIX2).t2x
	apertium-validate-interchunk $(BASENAME).$(PREFIX2).t2x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t2x $@

$(PREFVAR1)$(PREFIX2).t3x.bin: $(BASENAME).$(PREFIX2).t3x
	apertium-validate-postchunk $(BASENAME).$(PREFIX2).t3x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t3x $@

#$(PREFVAR2)$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
#	apertium-validate-transfer $(BASENAME).$(PREFIX2).t1x
#	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t1x $@
#
#$(PREFVAR2)$(PREFIX2).t2x.bin: $(BASENAME).$(PREFIX2).t2x
#	apertium-validate-interchunk $(BASENAME).$(PREFIX2).t2x
#	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t2x $@
#
#$(PREFVAR2)$(PREFIX2).t3x.bin: $(BASENAME).$(PREFIX2).t3x
#	apertium-validate-postchunk $(BASENAME).$(PREFIX2).t3x
#	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t3x $@



EXTRA_DIST=$(BASENAME).$(LANG1).dix $(BASENAME).$(PREFIX1).dix \
           $(BASENAME).post-$(LANG1).dix $(BASENAME).post-$(LANG2).dix \
           $(BASENAME).$(LANG2).dix $(BASENAME).$(LANG1).tsx \
           $(BASENAME).$(LANG2).tsx  \
           $(PREFIX1).prob $(PREFIX2).prob \
           buscaPar.xsl principal.xsl apertium-fra-por.fr.metadix \
           $(PREFIX1)-supervised.make $(PREFIX1)-unsupervised.make \
           $(PREFIX2)-supervised.make $(PREFIX2)-unsupervised.make \
           $(LANG1)-tagger-data/README $(LANG2)-tagger-data/README \
           $(BASENAME).$(PREFIX1).t1x $(BASENAME).$(PREFIX1).t2x \
           $(BASENAME).$(PREFIX1).t3x $(BASENAME).$(PREFIX2).t1x \
           $(BASENAME).$(PREFIX2).t2x $(BASENAME).$(PREFIX2).t3x \
           modes.xml  $(BASENAME).$(LANG1).acx alt.xsl translate-to-default-equivalent.xsl \
	   $(BASENAME).$(LANG2).acx

apertium-fra-por.fra.dix: apertium-fra-por.fra.metadix
	@xsltproc buscaPar.xsl apertium-fra-por.fra.metadix | uniq > $$gen.xsl
	@xsltproc $$gen.xsl apertium-fra-por.fra.metadix >$@
	@rm $$gen.xsl

apertium_fra_pordir=$(prefix)/share/apertium/apertium-$(PREFIX1)/
apertium_modesdir=$(prefix)/share/apertium/modes/

modes/$(PREFIX1).mode: modes.xml
	apertium-validate-modes modes.xml
	apertium-gen-modes modes.xml
	cp *.mode modes/

apertium_fra_por_DATA=$(PREFVAR1)$(PREFIX1).automorf.bin $(PREFVAR1)$(PREFIX2).automorf.bin \
	$(PREFVAR1)$(PREFIX1).autobil.bin $(PREFVAR1)$(PREFIX2).autobil.bin \
	$(PREFVAR1)$(PREFIX1).autogen.bin $(PREFVAR1)$(PREFIX2).autogen.bin \
	$(PREFIX1).autopgen.bin $(PREFIX2).autopgen.bin \
	$(PREFIX1).prob $(PREFIX2).prob \
	$(PREFIX1).t1x.bin $(PREFIX1).t2x.bin $(PREFIX1).t3x.bin \
	$(PREFIX2).t1x.bin $(PREFIX2).t2x.bin $(PREFIX2).t3x.bin \
	$(BASENAME).$(PREFIX1).t1x \
	$(BASENAME).$(PREFIX1).t3x \
	$(BASENAME).$(PREFIX2).t2x

# All modes are created by the same goal, listing several will just give problems with make -j2
noinst_DATA=modes/$(PREFIX1).mode

install-data-local:
	mv modes modes.bak
	apertium-gen-modes modes.xml apertium-$(PREFIX1)
	rm -rf modes
	mv modes.bak modes
	test -d $(DESTDIR)$(apertium_modesdir) || mkdir $(DESTDIR)$(apertium_modesdir)
	$(INSTALL_DATA) $(PREFVAR1)$(PREFIX1).mode $(DESTDIR)$(apertium_modesdir)
	$(INSTALL_DATA) $(PREFVAR1)$(PREFIX2).mode $(DESTDIR)$(apertium_modesdir)
	$(INSTALL_DATA) $(PREFVAR2)$(PREFIX1).mode $(DESTDIR)$(apertium_modesdir)
	$(INSTALL_DATA) $(PREFVAR2)$(PREFIX2).mode $(DESTDIR)$(apertium_modesdir)
	rm $(PREFVAR1)$(PREFIX1).mode
	rm $(PREFVAR1)$(PREFIX2).mode
	rm $(PREFVAR2)$(PREFIX1).mode
	rm $(PREFVAR2)$(PREFIX2).mode


CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes
