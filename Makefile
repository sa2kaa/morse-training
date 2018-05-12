# cp res{.txt,"-`date +%F`.txt"}

DATE = `date +%d%b`
SCI = ~/scilab-6.0.1/bin/scilab-cli

#all: 106 107 114

%:
	./html2text.py https://www.svt.se/svttext/web/pages/$@.html|./SVTtextFilter.py >SVTText$@"-$(DATE).txt"
	$(SCI) -f generator4.sci -args "SVTText$@-$(DATE)"
	mv SVTText$@"-$(DATE).txt" ~/tmp/
	lame -b 16 ~/tmp/"SVTText$@-$(DATE).wav" ~/tmp/"SVTText$@-$(DATE).mp3"

clean:
	rm res.txt

