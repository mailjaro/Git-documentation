# Makefile GIT-DOC project

# source markdown and configuration
MD = git.md
COMMON = config/common.yaml
BUILD = builds

# output files
EPUB_DARK = $(BUILD)/git-dark.epub
EPUB_LIGHT = $(BUILD)/git-light.epub
HTML1 = $(BUILD)/git-1.html
HTML2 = $(BUILD)/git-2.html
PDF = $(BUILD)/git.pdf

ASCIIDOC_CSS = styles/asciidoctor-default.css
ASCIIDOCTOR_THEME = styles/asciidoctor-default.yml

.PHONY: all epub html1 html2 pdf clean

all: epub html1 html2 pdf

# ensure build directory exists
$(BUILD):
	@mkdir -p $@

# --- EPUB ------------------------------------------------------------------
epub: $(BUILD) $(EPUB_DARK) $(EPUB_LIGHT)

$(EPUB_DARK): $(MD) $(COMMON) | $(BUILD)
	@pandoc $(MD) --metadata-file=$(COMMON) \
	       --css=styles/epub-dark.css -o $@
	@echo "✅ EPUB DARK successfully built."

$(EPUB_LIGHT): $(MD) $(COMMON) | $(BUILD)
	@pandoc $(MD) --metadata-file=$(COMMON) \
	       --css=styles/epub-light.css -o $@
	@echo "✅ EPUB LIGHT successfully built."

# --- intermediate AsciiDoc files -------------------------------------------

# converted directly from markdown
git-1.adoc: $(MD) $(COMMON)
	@pandoc $(MD) --metadata-file=$(COMMON) --wrap=none \
	       -f markdown-smart -o $@
#  Other formats are called form config/, affecting rel. imagepath:
	@sd 'image::images' 'image::../images' $@

git-2.adoc: git-1.adoc
	@cp $< $@
# add unbreakable attributes before certain source blocks
	@sd '\[source,output\]' '[%unbreakable]\n[source,output]' $@
	@sd '\[source,bash\]'   '[%unbreakable]\n[source,bash]' $@
	@sd '\[source,text\]'   '[%unbreakable]\n[source,text]' $@
	@sd '\[source,yaml\]'   '[%unbreakable]\n[source,text]' $@
	@sd '❗' 'NOTE:' $@
	@sd '‼️' 'CAUTION:' $@
# remove emojis when generating HTML2/PDF
	@sd '\p{Extended_Pictographic}\uFE0F? ' '' $@
	@sd '1️⃣' '1.' $@
	@sd '2️⃣' '2.' $@
	@sd '3️⃣' '3.' $@

# --- HTML 1 ----------------------------------------------------------------
html1: $(HTML1)

$(HTML1): config/masterHTML-1.adoc git-1.adoc | $(BUILD)
	@asciidoctor -a stylesheet=../$(ASCIIDOC_CSS) \
	            -a data-uri config/masterHTML-1.adoc -o $@
	@echo "✅ HTML 1 successfully built."

# --- HTML 2 ----------------------------------------------------------------
html2: $(HTML2)

$(HTML2): config/masterHTML-2.adoc git-2.adoc | $(BUILD)
	@asciidoctor -a stylesheet=../$(ASCIIDOC_CSS) \
	            -a data-uri config/masterHTML-2.adoc -o $@
	@echo "✅ HTML 2 successfully built."
# --- PDF -------------------------------------------------------------------
pdf: $(PDF)

git-3.adoc: git-2.adoc
	@cp $< $@
	
$(PDF): config/masterPDF.adoc git-3.adoc | $(BUILD)
	@asciidoctor-pdf config/masterPDF.adoc --theme=$(ASCIIDOCTOR_THEME) \
	                -o $@
	@echo "✅ PDF successfully built."

# --- cleanup ---------------------------------------------------------------
clean:
	@rm -rf $(BUILD) git-1.adoc git-2.adoc git-3.adoc
	@echo "✅ Cleaned up build artifacts."
