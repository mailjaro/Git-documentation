epub: git.md common.yaml
	$(info Building EPUB:)
	@pandoc git.md --metadata-file=common.yaml \
	-o git.epub

open-epub:
	@xdg-open "git.epub"

preview: open-epub

spellcheck:
	@hunspell -d nb_NO -p .hunspell_ignore -l git.md | sort | uniq

add-word:
ifndef word
	$(error Usage: make add-word word=someword)
endif
	@echo "$(word)" >> .hunspell_ignore
	@sort -u .hunspell_ignore -o .hunspell_ignore

clean:
	@rm -f git.epub
	@echo "Git-book in EPUB format removed."

TARGET := /media/jan/3364c0f4-4d82-474d-bad7-71d44eb0418b/home/jan/Documents
backup:
	@tar -czvf git-$(shell date +%d-%b-%g).tar.gz $(TARGET)
	@echo "	"
	@echo "Done."
