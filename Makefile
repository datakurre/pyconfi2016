TEXFILE := presentation

all: $(TEXFILE).pdf

$(TEXFILE).pdf: $(TEXFILE).tex
	@latexmk -pdf -recorder -interaction=nonstopmode -shell-escape -use-make -quiet $(TEXFILE)

watch:
	@latexmk -pvc -pdf -recorder -interaction=nonstopmode -shell-escape -use-make $(TEXFILE)

clean:
	@latexmk -C -quiet
	@rm -f *.nav *.snm *.fls *.vrb _minted-$(TEXFILE)/*
	@if [ -d _minted-$(TEXFILE) ]; then rmdir _minted-$(TEXFILE); fi

.PHONY: all clean watch

###

images: images/cover.jpg images/logo.eps
images: images/interlude-01.jpg images/interlude-02.jpg
images: images/interlude-03.jpg images/interlude-04.jpg

images/cover.jpg:
	@mkdir -p images
	curl http://placekitten.com/800/900 -o images/cover.jpg

images/interlude-01.jpg:
	@mkdir -p images
	curl http://placekitten.com/1601/900 -o images/interlude-01.jpg

images/interlude-02.jpg:
	@mkdir -p images
	curl http://placekitten.com/1602/900 -o images/interlude-02.jpg

images/interlude-03.jpg:
	@mkdir -p images
	curl http://placekitten.com/1603/900 -o images/interlude-03.jpg

images/interlude-04.jpg:
	@mkdir -p images
	curl http://placekitten.com/1604/900 -o images/interlude-04.jpg

images/logo.eps:
	@mkdir -p images
	curl https://www.jyu.fi/yliopistopalvelut/viestinta/logot/eps-tiedostot/jyu-logo-cmyk_teksti-oikealla.eps -o images/logo.eps

icons:
	@mkdir -p icons
	curl http://www.cisco.com/c/dam/en_us/about/ac50/ac47/doc.zip -o _tmp.zip
	unzip _tmp.zip -d icons
	rm -f _tmp.zip
