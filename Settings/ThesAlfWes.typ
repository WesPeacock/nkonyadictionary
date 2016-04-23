\+DatabaseType ThesAlf-Wes
\ver 5.0
\desc index to Thesaurus-Wes
\+mkrset 
\lngDefault English
\mkrRecord wd

\+mkr bb
\nam *
\lng English
\mkrOverThis wd
\-mkr

\+mkr cf
\nam compare
\lng English
\mkrOverThis wd
\CharStyle
\-mkr

\+mkr ee
\nam *
\lng English
\mkrOverThis wd
\-mkr

\+mkr et
\nam *
\lng English
\mkrOverThis wd
\-mkr

\+mkr id
\lng English
\mkrOverThis wd
\-mkr

\+mkr is
\nam *
\lng English
\mkrOverThis wd
\-mkr

\+mkr nt
\nam note
\lng English
\mkrOverThis wd
\CharStyle
\-mkr

\+mkr sd
\nam Index of Semantics
\lng ThesClass
\mkrOverThis wd
\mkrFollowingThis sd
\CharStyle
\-mkr

\+mkr td
\nam thesaurus date
\lng Date
\mkrOverThis wd
\-mkr

\+mkr thes
\nam thesaurus key
\lng ThesEng
\+fnt 
\Name Times New Roman
\Size 12
\charset 00
\rgbColor 0,0,0
\-fnt
\mkrOverThis wd
\CharStyle
\-mkr

\+mkr wd
\lng ThesEng
\+fnt 
\Name Times New Roman
\Size 14
\Bold
\charset 00
\rgbColor 128,0,0
\-fnt
\-mkr

\-mkrset

\iInterlinCharWd 8
\+filset 

\+fil Badmkr
\mkr isII.D.1.a
\match_char c
\-fil

\+fil Index class
\mkr is
\txt [#]I.D.5
\match_char c
\-fil

\+fil Nonunique
\fel NonUnique
\match_char c
\-fil

\+fil X-ref
\mkr wd
\txt see
\match_char c
\-fil

\-filset

\+jmpset 
\+jmp Crossref
\+mkrsubsetIncluded 
\mkr thes
\-mkrsubsetIncluded
\+drflst 
\+drf 
\File C:\My Toolbox Projects\Nkonya\WPthesaurus.txt
\mkr wd
\-drf
\+drf 
\File C:\My Toolbox Projects\Nkonya\TNthesaurus2008.txt
\mkr wd
\-drf
\-drflst
\match_char p
\-jmp
\+jmp Headref
\+mkrsubsetIncluded 
\mkr wd
\-mkrsubsetIncluded
\+drflst 
\+drf 
\File C:\My Toolbox Projects\Nkonya\WPthesaurus.txt
\mkr wd
\-drf
\-drflst
\match_char p
\-jmp
\-jmpset

\+template 
\fld \thes
\fld \is
\fld \td
\-template
\mkrRecord wd
\mkrDateStamp td
\+PrintProperties 
\header File: &f, Date: &d
\footer Page &p
\topmargin 2.54 cm
\leftmargin 0.64 cm
\bottommargin 2.54 cm
\rightmargin 0.64 cm
\recordsspace 10
\-PrintProperties
\+expset 

\+expRTF Rich Text Format
\+rtfPageSetup 
\paperSize letter
\topMargin 1
\bottomMargin 1
\leftMargin 1.25
\rightMargin 1.25
\gutter 0
\headerToEdge 0.5
\footerToEdge 0.5
\columns 1
\columnSpacing 0.5
\-rtfPageSetup
\-expRTF

\+expSF Standard Format
\-expSF

\+expXML XML
\UTF8
\exportedFile C:\My Toolbox Projects\Nkonya\WPthesaurus.xml
\-expXML

\expDefault XML
\SkipProperties
\-expset
\-DatabaseType
