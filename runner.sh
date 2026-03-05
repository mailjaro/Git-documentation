#!/usr/bin/fish
pushd ~/Documents/doc/git-doc
mkdir -p builds

pandoc git.md  \
   --metadata-file=config/common.yaml \
   --css=styles/epub-dark.css -o \
   builds/git-dark.epub
echo "✅ EPUB DARK successfully built."

pandoc git.md  \
   --metadata-file=config/common.yaml \
   --css=styles/epub-light.css -o \
   builds/git-light.epub
echo "✅ EPUB LIGHT successfully built."

pandoc git.md --metadata-file=./config/common.yaml \
                 --wrap=none -f markdown-smart -o git-1.adoc
# Justerer for annet forhold i kall/bildeplassering videre
sd 'image::images' 'image::../images' git-1.adoc

asciidoctor -a stylesheet=../styles/asciidoctor-default.css \
            -a data-uri \
            config/masterHTML-1.adoc -o builds/git-1.html
echo "✅ HTML 1 successfully built."

cp git-1.adoc git-2.adoc
sd '\[source,output\]' '[%unbreakable]\n[source,output]' git-2.adoc
sd '\[source,text\]'   '[%unbreakable]\n[source,text]' git-2.adoc
sd '\[source,yaml\]'   '[%unbreakable]\n[source,text]' git-2.adoc
sd '\[source,bash\]'   '[%unbreakable]\n[source,bash]' git-2.adoc
sd '❗' 'NOTE:' git-2.adoc
sd '‼️' 'CAUTION:' git-2.adoc

sd '\p{Extended_Pictographic}\uFE0F? ' '' git-2.adoc  # Fjerner emojis
sd '1️⃣' '1.' git-2.adoc
sd '2️⃣' '2.' git-2.adoc
sd '3️⃣' '3.' git-2.adoc

asciidoctor -a stylesheet=../styles/asciidoctor-default.css \
            -a data-uri \
            config/masterHTML-2.adoc -o builds/git-2.html
echo "✅ HTML 2 successfully built."

cp git-2.adoc git-3.adoc

asciidoctor-pdf config/masterPDF.adoc --theme=styles/asciidoctor-default.yml \
               -a tabsize=12  -o builds/git.pdf
echo "✅ PDF successfully built."

popd