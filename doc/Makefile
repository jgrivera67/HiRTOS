#
# Makefile to build a PDF file from LaTeX sources
#

#
# .pdf file to be generated from the main .ltx file
#
MAIN_DOC = HiRTOS.pdf

#
# .ltx files included in the main .ltx file
#
LTX_INCLUDES =

#
# .pdf and .png files generated outside of this makefile
#
#OTHER_FIGURES = HiRTOS_Architecture.pdf

#
# Directory where all intermediate build files are generated
#
OBJ_DIR = obj-latex

#
# vpath locations to find .pdf files for figures outside of the current
# directory
#
#vpath %.pdf ${OBJ_DIR}

#
# Build tools
#
PDFLATEX = pdflatex
FUZZLIB_PATH ?=/opt/fuzz/lib/fuzzlib
FUZZ = FUZZLIB=$(FUZZLIB_PATH) fuzz

PDFLATEX_FLAGS = -interaction=nonstopmode \
		 -halt-on-error \
		 -file-line-error \
		 -output-directory=${OBJ_DIR}

all: ${OBJ_DIR} ${MAIN_DOC}

${OBJ_DIR}:
	test -d $@ || mkdir $@

${MAIN_DOC}: ${LTX_INCLUDES} ${OTHER_FIGURES}

${MAIN_DOC}: %.pdf: %.ltx
	${FUZZ} -d $<
	latexmk -pdf $<
	@printf "\n*** Build of $@ completed successfully ***\n"
	ls -lt *.pdf

clean: clean_obj
	$(RM) *.pdf

clean_obj:
	$(RM) -r ${OBJ_DIR}
