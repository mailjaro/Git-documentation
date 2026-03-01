# 📗 An Introduction to Git — Documentation

This booklet provides a practical, easy-to-follow introduction to Git. It covers basic workflows, common commands, and how to use Git (and GitHub) for simple version control, backups, and working across multiple machines. The material assumes a Linux environment and is aimed at users with modest needs (writers, documentation authors, hobbyist coders).

## 📁 What this repository contains

- Source text: `git.md`
- Build script: `Makefile` (generates EPUB, HTML and PDF outputs)
- Configuration and templates: `config/`
- Styles and themes: `styles/`
- Built artifacts (after running the build targets): `builds/`

## ✨ Highlights

- Core Git concepts: working directory, staging (index) and repository
- Common commands: `git init`, `add`, `commit`, `status`, `log`, `branch`, `switch`, `pull` and `push`, as well as  `git restore`, `reset`, `merge` and `rebase`
- Practical tips for `.gitignore` 
- A brief explanation of branches, `HEAD`and commit history
- Conflicts and how ta deal with them

## ⚙️ Prerequisites

To build the documentation you need the following tools installed on your system:

- `make`
- `pandoc`
- `asciidoctor`
- `asciidoctor-pdf`
- `sd` (streaming text replacement tool used during conversion)

On Debian/Ubuntu you can typically install most packages with `apt`; some tools (for example `sd`) may need to be installed from their respective package sources or via other package managers.

## ⚡ Quick commands

Build everything (EPUB, HTML and PDF):

```bash
make all
```

Build only EPUBs:

```bash
make epub
```

Build the HTML variants:

```bash
make html1
make html2
```

Build the PDF:

```bash
make pdf
```

Clean build artifacts:

```bash
make clean
```

## 📦 Output

After a successful build you will find, among other files, the following in `builds/`:

- `git-dark.epub`, `git-light.epub`
- `git-1.html`, `git-2.html`
- `git.pdf`

----

The source files and build logic live in the repository root. See `git.md` for the full content and `Makefile` (or `runner.sh`) for details about the build process.
