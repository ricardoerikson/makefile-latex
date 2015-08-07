# Makefile for LaTeX projects

This project contains some helper scripts that are used for building my LaTeX projects. The project contains a Makefile and a helper script (`rm-helper`) to remove temp folders and temp files. Some targets of the Makefile are based on some *git commands* and you (definetly) should integrate this project into your LaTeX project with `git`.

## Supported Platforms

* Mac OS X (Requires [MacTex](https://tug.org/mactex/) package)
* Linux (Requires texlive packages)

Use your package manager to install texlive packages

* `sudo yum install texlive*` - Fedora <22, CentOS
* `sudo dnf install texlive*` - Fedra 22+

## Configuration

Before starting a project, you must configure the files and folders that will be used in your project. This configuration is done by defining some variables in the `Makefile`. The following variables of the `Makefile` should be edited according to your project configuration: 

```
SRC_DIR=src
TMP_DIR=tmp
OUTPUT_DIR=out
# If you have a project file
PROJECT_FILE=project.sublime-project
MAIN_TEX_SRC=thesis.tex
OUTPUT_FILE=thesis.pdf
BIB_SRC=biblio.bib 
...
TEXLIVE_YEAR = 2013;
```

## Targets

* `init`: Initialize an empty git repository into a latex project. This should be the first command to run on a latex project.
* `clean`: Remove the temporary files of the project.
* `bibtex`: Generate bibtex related files. Run this command before use the xelatex target.
* `xelatex`: Generates a `.pdf` file as an output of the `.tex`.
* `pdf`: Automatically generates the bibtex and xelatex targets.
* `view`: Open the `.pdf` file in a give viewer configured in the `Makefile`.
* `default`: The default target runs pdf and view targets.
