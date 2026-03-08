#!/usr/bin/fish
pushd ~/Documents/doc/git-doc

mkdir -p builds

# ---- EPUBS PANDOC --------------------------------------------
# These commands are called from WD:
# git.md contain: ![Git System](images/git-system-small.png)

pandoc git.md  \
   --metadata-file=config/common.yaml \
   --css=styles/epub-dark.css \
   --metadata cover-image=images/cover.png \
   -o builds/git-pan-dark.epub

pandoc git.md  \
   --metadata-file=config/common.yaml \
   --css=styles/epub-light.css \
   --metadata cover-image=images/cover.png \
   -o builds/git-pan-light.epub

echo "✅ Pandoc EPUB LIGHT and DARK successfully built."
#----------------------------------------------------------------


# --- MD TO ADOC ------------------------------------------------
pandoc git.md --metadata-file=./config/common.yaml \
                 --wrap=none -f markdown-smart -o git-1.adoc
#-----------------------------------------------------------------

# --- HTML 1 ----------------------------------------------------
# These commands are called from WD/config:
# git-1.adoc, git-2.adoc and git-3.adoc must contain
# image::../images/git-system-small.png[Git System]
sd 'image::images' 'image::../images' git-1.adoc
asciidoctor -a stylesheet=../styles/asciidoctor-default.css \
            -a data-uri \
            config/masterHTML-1.adoc -o builds/git-1.html
#----------------------------------------------------------------


# --- PREPARATIONS ---------------------------------------------
cp git-1.adoc git-2.adoc
sd '\[source,output\]' '[%unbreakable]\n[source,output]' git-2.adoc
sd '\[source,bash\]'   '[%unbreakable]\n[source,bash]' git-2.adoc
sd '\[source,text\]'   '[%unbreakable]\n[source,text]' git-2.adoc
sd '\[source,yaml\]'   '[%unbreakable]\n[source,text]' git-2.adoc

sd '❗' 'NOTE:' git-2.adoc
sd '‼️' 'CAUTION:' git-2.adoc
sd '🚩' 'WARNING:' git-2.adoc
sd '\p{Extended_Pictographic}\uFE0F? ' '' git-2.adoc  # Fjerner emojis
sd ' 1️⃣' '' git-2.adoc
sd ' 2️⃣' '' git-2.adoc
sd ' 3️⃣' '' git-2.adoc
sd ' 4️⃣' '' git-2.adoc
sd ' 5️⃣' '' git-2.adoc
sd ' 6️⃣' '' git-2.adoc
sd ' 7️⃣' '' git-2.adoc
#----------------------------------------------------------------


# --- HTML --------------------------------------------------
asciidoctor -a stylesheet=../styles/asciidoctor-default.css \
            -a data-uri \
            config/masterHTML-2.adoc -o builds/git-2.html

echo "✅ HTML1 and HTML2 successfully built."
#-------------------------------------------------------------


#--- PDF ----------------------------------------------------
cp git-2.adoc git-3.adoc

asciidoctor-pdf config/masterPDF.adoc --theme=styles/asciidoctor-default.yml \
                -o builds/git.pdf

echo "✅ PDF successfully built."
#--- PDF ----------------------------------------------------


#--- EPUBS ASCIDOCTOR ---------------------------------------
# These commands are called from WD/config, but with a -B .
# so they need:
#![Git System](images/git-system-small.png)

sd 'image::\.\./images' 'image::images' git-2.adoc

asciidoctor-epub3 config/masterEPUB-light.adoc -B . \
                  -o builds/git-asc-light.epub
asciidoctor-epub3 config/masterEPUB-dark.adoc -B . \
                  -o builds/git-asc-dark.epub

echo "✅ Asciidoctor EPUB LIGHT and DARK successfully built."
#-------------------------------------------------------------

popd