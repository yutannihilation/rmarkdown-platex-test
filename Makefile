PDF_FILES := $(patsubst %.Rmd, %.pdf, $(wildcard *.Rmd))

all: $(PDF_FILES)

%.tex: %.Rmd
	Rscript -e "rmarkdown::render('$<', encoding = 'UTF-8')"
	rm $*.pdf

%.pdf: %.tex
	sed \
		-e 's/ltjsarticle/jsarticle/' \
	  -e '/\\usepackage{microtype}/d' \
	  -e '/\\UseMicrotypeSet\[protrusion\]{basicmath}/d' \
	  -e 's/\\usepackage{graphicx,grffile}/\\usepackage[dvipdfmx]{graphicx}\n\\usepackage{grffile}/' \
	  $*.tex > $*-modified.tex
	platex $*-modified.tex
	dvipdfmx $*-modified

.PHONY: clean

clean:
	$(RM) -r _cache $(PDF_FILES)