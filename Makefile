# Configuration variables. You should change these 
# variables according to you project.

# Source (SRC_DIR), temp (TMP_DIR) and output (OUTPUT_DIR) 
# directories of your project. After executing the init target
# these folders must be created in your project.
SRC_DIR=src
TMP_DIR=tmp
OUTPUT_DIR=out

# Use this variable only if you have a project file. 
# Ex: *.sublime-project for Sublime Text projects.
PROJECT_FILE=project.sublime-project

# Your main tex file. This is the file that will be exected 
# during the build process of the project.
MAIN_TEX_SRC=thesis.tex
OUTPUT_FILE=thesis.pdf
# Your bib file.
BIB_SRC=biblio.bib

# Temp files. These files should be removed from the project 
# when the build process is finished. They will also be removed
# after using the clean target.
TMP_FILES=*.aux *.gz *.log *.bbl *.blg *.snm *.nav *.toc *.out *.xdv *.toc *.lof *.loa *.lot *.idx

# TexLive year of the release
TEXLIVE_YEAR = 2013;

define whitespace
 
endef

UNAME := $(shell uname -s)

ifeq ($(UNAME), Darwin)
    XELATEX=/usr/local/texlive/${TEXLIVE_YEAR}/bin/universal-darwin/xelatex
    BIBTEX=/usr/local/texlive/${TEXLIVE_YEAR}/bin/universal-darwin/bibtex
    PDF_VIEWER=open
else
    XELATEX=xelatex
    BIBTEX=bibtex
    PDF_VIEWER=evince
endif

all: pdf view

pdf: bibtex xelatex

xelatex: mkdir-tmp mkdir-out prepare
    @${XELATEX} -synctex=1 -interaction=nonstopmode --src-specials ${MAIN_TEX_SRC}
    @mv -f ${subst .tex,.pdf,${MAIN_TEX_SRC}} ${OUTPUT_DIR}/${OUTPUT_FILE}
ifeq ($(UNAME), Darwin)
    @ls -1 ${TMP_FILES} 2>/dev/null | xargs -J {} mv -f {} ${TMP_DIR}
else
    @ls -1 ${TMP_FILES} 2>/dev/null | xargs -i mv -f {} ${TMP_DIR}
endif
    @make rm_helper

xelatex-nopdf: prepare
    @${XELATEX} -synctex=1 -interaction=nonstopmode --no-pdf --src-specials ${MAIN_TEX_SRC}

clean:
ifneq (${TMP_DIR},.)
    @rm -fR ${TMP_DIR}/*
else
    @rm ${TMP_FILES} *.pdf
endif
    @cd ${SRC_DIR}; \
    rm -f ${TMP_FILES} *.pdf
    @make rm_helper


bibtex: xelatex-nopdf
    @${BIBTEX} ${subst .tex,,${MAIN_TEX_SRC}}
    @make xelatex-nopdf

prepare:
    @test -d ${SRC_DIR} && cp -R ${SRC_DIR}/* .

mkdir-src:
ifneq (${SRC_DIR},.)
    @test -d ${SRC_DIR} || mkdir -p ${SRC_DIR}
endif

mkdir-out:
ifneq (${OUTPUT_DIR},.)
    @test -d ${OUTPUT_DIR} || mkdir -p ${OUTPUT_DIR}
endif

mkdir-tmp:
ifneq (${TMP_DIR},.)
    @test -d ${TMP_DIR} || mkdir -p ${TMP_DIR}
endif

mkdir: mkdir-src mkdir-tmp mkdir-out
    @touch ${SRC_DIR}/${MAIN_TEX_SRC}
    @touch ${SRC_DIR}/${BIB_SRC}

init: mkdir gitignore
    @test -d .git || git init

gitignore:
    @echo "$(subst $(whitespace),\n,${TMP_FILES})" > .gitignore
    @echo ".DS_Store"       >>  .gitignore
    @echo "${OUTPUT_FILE}"   >>  .gitignore
    @echo "${SRC_DIR}/.*"    >>  .gitignore
    @echo "${TMP_DIR}/*"     >>  .gitignore
    @echo "${OUTPUT_DIR}/*"  >>  .gitignore

view:
    @${PDF_VIEWER} ${OUTPUT_DIR}/${OUTPUT_FILE}

rm_helper:
    @./rm-helper '${SRC_DIR}|${OUTPUT_DIR}|${TMP_DIR}|${PROJECT_FILE}|Makefile|.gitignore|.git|rm-helper'
