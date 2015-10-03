all: words prefixes suffixes xvwithlx findwords.pl
	cd ~/.wine/drive_c/My\ Toolbox\ Projects/Nkonya/ && git pull && cd -

words: extrawords ~/.wine/drive_c/My\ Toolbox\ Projects/Nkonya/Nkolex\ in\ Unicode.txt
	egrep '\\lx|\\se|\\pl |\\va |\\sg ' ~/.wine/drive_c/My\ Toolbox\ Projects/Nkonya/Nkolex\ in\ Unicode.txt |sed -e 's/\\se //'|sed -e 's/\\lx //' |sed -e 's/\\pl //' |sed -e 's/\\va //' |sed -e 's/\\sg //' |sed -e 's/ X//' |sed -e 's/-//' | tr 'A-ZƐƆƖŊ' 'a-zɛɔɩŋ' | fromdos >words && cat extrawords >>words

~/.wine/drive_c/My\ Toolbox\ Projects/Nkonya/Nkolex\ in\ Unicode.txt: 
	cd ~/.wine/drive_c/My\ Toolbox\ Projects/Nkonya/ && git pull && cd -

xvwithlx: lxsexv putlxseonxv.pl
	./putlxseonxv.pl lxsexv  >xvwithlx

lxsexv: ~/.wine/drive_c/My\ Toolbox\ Projects/Nkonya/Nkolex\ in\ Unicode.txt
	egrep '\\lx|\\se|\\xv' ~/.wine/drive_c/My\ Toolbox\ Projects/Nkonya/Nkolex\ in\ Unicode.txt |sed -e 's/\://g'| sed -e 's/\.//g'|sed -e 's/\?//g'|sed -e 's/\;//g'|sed -e 's/\!//g'|sed -e 's/\,//g' |sed -e 's/\"//g'| tr 'A-ZƐƆƖŊ' 'a-zɛɔɩŋ' |fromdos >lxsexv

