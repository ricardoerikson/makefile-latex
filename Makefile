SRCDIR=src
TMPDIR=tmp
OUTPUTDIR=out

TEXSRC=thesis.tex
OUTPUTFILE=thesis.pdf
BIBSRC=biblio.bib

TMP_FILES=*.aux *.gz *.log *.bbl *.blg *.snm *.nav *.toc *.out *.xdv

define whitespace
 
endef

UNAME := $(shell uname -s)

ifeq ($(UNAME), Darwin)
    XELATEX=/usr/local/texlive/2012/bin/universal-darwin/xelatex
    BIBTEX=/usr/local/texlive/2012/bin/universal-darwin/bibtex
    PDF_VIEWER=open -a "/Applications/Adobe Reader.app"
endif

all: pdf view

pdf: bibtex xelatex

xelatex: mkdir-tmp mkdir-out
	@cd ${SRCDIR}; \
	${XELATEX} -synctex=1 -interaction=nonstopmode --src-specials ${TEXSRC}
	@make move

xelatex-nopdf:
	@cd ${SRCDIR}; \
	${XELATEX} -synctex=1 -interaction=nonstopmode --no-pdf --src-specials ${TEXSRC}

clean:
ifneq (${TMPDIR},.)
	@rm -fR ${TMPDIR}/*
else
	@rm ${TMP_FILES} *.pdf
endif


bibtex: xelatex-nopdf
	@cd ${SRCDIR}; \
	${BIBTEX} ${subst .tex,,${TEXSRC}}
	@make xelatex-nopdf

move:
ifneq (${SRCDIR},.)
	@cd ${SRCDIR}; \
	mv -f ${TMP_FILES} ../${TMPDIR}; \
	mv -f ${subst .tex,.pdf,${TEXSRC}} ../${OUTPUTDIR}/${OUTPUTFILE}
else
	@mv -f ${TMP_FILES} ${TMPDIR}
	@mv -f ${subst .tex,.pdf,${TEXSRC}} ${OUTPUTDIR}/${OUTPUTFILE}
endif

mkdir-src:
ifneq (${SRCDIR},.)
	@test -d ${SRCDIR} || mkdir -p ${SRCDIR}
endif

mkdir-out:
ifneq (${OUTPUTDIR},.)
	@test -d ${OUTPUTDIR} || mkdir -p ${OUTPUTDIR}
endif

mkdir-tmp:
ifneq (${TMPDIR},.)
	@test -d ${TMPDIR} || mkdir -p ${TMPDIR}
endif

mkdir: mkdir-src mkdir-tmp mkdir-out
	@touch ${SRCDIR}/${TEXSRC}
	@touch ${SRCDIR}/${BIBSRC}

init: mkdir
	@test -d .git || git init

gitignore:
	@echo "$(subst $(whitespace),\n,${TMP_FILES})" > .gitignore
	@echo ".DS_Store"		>> 	.gitignore
	@echo "${SRCDIR}/.*"	>> 	.gitignore
	@echo "${TMPDIR}/*" 	>> 	.gitignore
	@echo "${OUTPUTDIR}/*" 	>> 	.gitignore

view:
	@${PDF_VIEWER} ${OUTPUTDIR}/${OUTPUTFILE}