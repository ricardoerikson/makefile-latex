makefile-latex
==============

Makefile to provide support for a Latex project.

Before starting a project the writer must define the filenames and source, temp and output folders for the project.

You should edit the following variables in the Makefile: 

- TEXSRC=*your_main_source_file.tex*

- OUTPUTFILE=*your_output_pdf_file.pdf*

- BIBSRC=*your_bib_file.bib*

- PROJECT_FILE=*your_project_file* # if you have one


Targets:

- init: Initialize an empty git repository into a latex project. This should be the first command to run on a latex project.
  
- clean: Clean the temporary files of the project.
  
- bibtex: Generate bibtex related files. Run this command before use the xelatex target.

- xelatex: Generates a .pdf file as an output of the .tex.

- pdf: Automatically generates the bibtex and xelatex targets.

- view: Open the .pdf file in a give viewer configured in the Makefile.

- default: The default target runs pdf and view targets.
