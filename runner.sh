#!/usr/bin/fish
pushd ~/Documents/doc/git-doc
mkdir -p builds

pandoc git.md  \
   --metadata-file=config/common.yaml \
   --css=styles/epub-dark.css -o \
   builds/git-dark.epub

pandoc git.md  \
   --metadata-file=config/common.yaml \
   --css=styles/epub-light.css -o \
   builds/git-light.epub

pandoc git.md --metadata-file=./config/common.yaml \
                 --wrap=none -f markdown-smart -o git-1.adoc

asciidoctor -a stylesheet=../styles/asciidoctor-default.css \
            -a data-uri \
            config/masterHTML-1.adoc -o builds/git-1.html

cp git-1.adoc git-2.adoc
sd '\[source,text\]' '[%unbreakable]\n[source,text]' git-2.adoc
sd '\[source,json\]' '[%unbreakable]\n[source,json]' git-2.adoc
sd '\p{Extended_Pictographic}\uFE0F? ' '' git-2.adoc  # Fjerner emojis

asciidoctor -a stylesheet=../styles/asciidoctor-default.css \
            -a data-uri \
            config/masterHTML-2.adoc -o builds/git-2.html

cp git-2.adoc git-3.adoc

asciidoctor-pdf config/masterPDF.adoc --theme=styles/asciidoctor-default.yml \
                -o builds/git.pdf

popd