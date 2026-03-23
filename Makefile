# DOES NOT YET WORK!! USE .runner.sh FOR PRODUCTION

# ------------------------------------------------------------
# Project paths
# ------------------------------------------------------------

SRC_MD      := git.md
ADOC1       := git-1.adoc
ADOC2       := git-2.adoc
ADOC3       := git-3.adoc

CONFIG      := config
STYLES      := styles
IMAGES      := images
BUILDS      := builds

META        := $(CONFIG)/common.yaml
COVER       := $(IMAGES)/cover.png

# ------------------------------------------------------------
# Default target
# ------------------------------------------------------------

all: pandoc-epubs html1 html2 pdf asc-epubs

# ------------------------------------------------------------
# Ensure build directory exists
# ------------------------------------------------------------

$(BUILDS):
	@mkdir -p $(BUILDS)

# ------------------------------------------------------------
# Pandoc EPUB
# ------------------------------------------------------------

pandoc-epubs: $(BUILDS)
	@pandoc $(SRC_MD) \
	   --metadata-file=$(META) \
	   --css=$(STYLES)/epub-dark.css \
	   --metadata cover-image=$(COVER) \
	   -o $(BUILDS)/git-pan-dark.epub

	@pandoc $(SRC_MD) \
	   --metadata-file=$(META) \
	   --css=$(STYLES)/epub-light.css \
	   --metadata cover-image=$(COVER) \
	   -o $(BUILDS)/git-pan-light.epub

	@echo "✅ Pandoc EPUB LIGHT and DARK successfully built."

# ------------------------------------------------------------
# Markdown → AsciiDoc
# ------------------------------------------------------------

$(ADOC1): $(SRC_MD)
	@pandoc $(SRC_MD) \
		--metadata-file=$(META) \
		--wrap=none \
		-f markdown-smart \
		-o $@.tmp
	@sd 'image::images' 'image::../images' $@.tmp > $@
	@rm $@.tmp

# ------------------------------------------------------------
# HTML 1
# ------------------------------------------------------------

html1: $(ADOC1) | $(BUILDS)
	@asciidoctor \
		-a stylesheet=../$(STYLES)/asciidoctor-default.css \
		-a data-uri \
		$(CONFIG)/masterHTML-1.adoc \
		-o $(BUILDS)/git-1.html
	@echo "✅ HTML1 successfully built."

# ------------------------------------------------------------
# Prepare git-2.adoc
# ------------------------------------------------------------

$(ADOC2): $(ADOC1)
	@cp $(ADOC1) $(ADOC2)
	@sd '\[source,output\]' '[%unbreakable]\n[source,output]' $(ADOC2)
	@sd '\[source,bash\]'   '[%unbreakable]\n[source,bash]' $(ADOC2)
	@sd '\[source,text\]'   '[%unbreakable]\n[source,text]' $(ADOC2)
	@sd '\[source,yaml\]'   '[%unbreakable]\n[source,text]' $(ADOC2)

	@sd '❗' 'NOTE:' $(ADOC2)
	@sd '‼️' 'CAUTION:' $(ADOC2)
	@sd '🚩' 'WARNING:' $(ADOC2)

	@sd '\p{Extended_Pictographic}\uFE0F? ' '' $(ADOC2)

	@sd ' 1️⃣' '' $(ADOC2)
	@sd ' 2️⃣' '' $(ADOC2)
	@sd ' 3️⃣' '' $(ADOC2)
	@sd ' 4️⃣' '' $(ADOC2)
	@sd ' 5️⃣' '' $(ADOC2)
	@sd ' 6️⃣' '' $(ADOC2)
	@sd ' 7️⃣' '' $(ADOC2)

# ------------------------------------------------------------
# HTML 2
# ------------------------------------------------------------

html2: $(ADOC2) | $(BUILDS)
	@asciidoctor \
		-a stylesheet=../$(STYLES)/asciidoctor-default.css \
		-a data-uri \
		$(CONFIG)/masterHTML-2.adoc \
		-o $(BUILDS)/git-2.html

	@echo "✅ HTML2 successfully built."

html: html1 html2

# ------------------------------------------------------------
# PDF
# ------------------------------------------------------------

$(ADOC3): $(ADOC2)
	@cp $(ADOC2) $(ADOC3)

pdf: $(ADOC3) | $(BUILDS)
	@asciidoctor-pdf \
		$(CONFIG)/masterPDF.adoc \
		--theme=$(STYLES)/asciidoctor-default.yml \
		-o $(BUILDS)/git.pdf

	@echo "✅ PDF successfully built."

# ------------------------------------------------------------
# Asciidoctor EPUB
# ------------------------------------------------------------

asc-epubs: $(ADOC2) | $(BUILDS)

	@asciidoctor-epub3 \
		$(CONFIG)/masterEPUB-light.adoc \
		-B . \
		-o $(BUILDS)/git-asc-light.epub

	@asciidoctor-epub3 \
		$(CONFIG)/masterEPUB-dark.adoc \
		-B . \
		-o $(BUILDS)/git-asc-dark.epub

	@echo "✅ Asciidoctor EPUB LIGHT and DARK successfully built."

# ------------------------------------------------------------
# Cleaning
# ------------------------------------------------------------

clean:
	@rm -rf $(BUILDS) $(ADOC1) $(ADOC2) $(ADOC3)
	@echo "✅ Bulids and adocs removed."
# ------------------------------------------------------------
# Phony targets
# ------------------------------------------------------------

.PHONY: all html html1 html2 pdf pandoc-epubs asc-epubs clean
