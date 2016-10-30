TEXFILE ?= slides

all: $(TEXFILE).pdf

$(TEXFILE).pdf: $(TEXFILE).tex images icons
	@latexmk -pdf -recorder -interaction=nonstopmode -shell-escape -use-make -quiet $(TEXFILE)

watch:
	@latexmk -pvc -pdf -recorder -interaction=nonstopmode -shell-escape -use-make $(TEXFILE)

clean:
	@latexmk -C -quiet
	@rm -f *.nav *.snm *.fls *.vrb _minted-$(TEXFILE)/*
	@if [ -d _minted-$(TEXFILE) ]; then rmdir _minted-$(TEXFILE); fi

.PHONY: all clean notebook watch

###

images: images/logo.eps

images/logo.eps:
	@mkdir -p images
	curl https://www.jyu.fi/yliopistopalvelut/viestinta/logot/eps-tiedostot/jyu-logo-cmyk_teksti-oikealla.eps -o images/logo.eps

icons:
	@mkdir -p icons
	curl http://www.cisco.com/c/dam/en_us/about/ac50/ac47/doc.zip -o _tmp.zip
	unzip _tmp.zip -d icons
	rm -f _tmp.zip
