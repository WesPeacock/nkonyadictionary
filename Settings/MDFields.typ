\+DatabaseType MDF Lexical Fields
\ver 5.0
\desc Database type for the MDF Lexical Fields database
\+mkrset 
\lngDefault Default
\mkrRecord key

\+mkr bib
\nam Bibliography
\lng Default
\NoWordWrap
\mkrOverThis key
\-mkr

\+mkr cf
\nam Cross-reference
\lng Default
\+fnt 
\Name Arial Unicode MS
\Size 12
\charset 00
\rgbColor 0,128,0
\-fnt
\NoWordWrap
\mkrOverThis key
\-mkr

\+mkr dt
\nam Datestamp
\lng Default
\mkrOverThis key
\-mkr

\+mkr ftx
\nam fixed-spaced PP
\lng Default
\+fnt 
\Name Courier New
\Size 10
\rgbColor 0,0,0
\-fnt
\NoWordWrap
\mkrOverThis key
\-mkr

\+mkr fxv
\nam fixed-spaced example
\lng Default
\+fnt 
\Name Times New Roman
\Size 11
\Bold
\rgbColor 0,0,0
\-fnt
\NoWordWrap
\mkrOverThis key
\-mkr

\+mkr ge
\lng Default
\mkrOverThis key
\-mkr

\+mkr hd1
\nam Heading -1
\lng Default
\+fnt 
\Name Times New Roman
\Size 14
\Underline
\rgbColor 0,0,255
\-fnt
\mkrOverThis key
\-mkr

\+mkr key
\nam Record Marker
\lng Default
\+fnt 
\Name Times New Roman
\Size 12
\Underline
\rgbColor 255,0,0
\-fnt
\-mkr

\+mkr lx
\lng Default
\mkrOverThis key
\-mkr

\+mkr nt
\nam note
\lng Default
\+fnt 
\Name Arial Unicode MS
\Size 11
\Italic
\charset 00
\rgbColor 0,0,0
\-fnt
\NoWordWrap
\mkrOverThis key
\-mkr

\+mkr nwt
\nam No-wrap text
\lng Default
\+fnt 
\Name Times New Roman
\Size 11
\rgbColor 0,0,0
\-fnt
\NoWordWrap
\mkrOverThis key
\-mkr

\+mkr ps
\lng Default
\mkrOverThis key
\-mkr

\+mkr shd
\nam Section Heading
\lng Default
\+fnt 
\Name Times New Roman
\Size 14
\rgbColor 0,0,255
\-fnt
\mkrOverThis key
\-mkr

\+mkr shd2
\nam Section Heading -2
\lng Default
\+fnt 
\Name Times New Roman
\Size 14
\Bold
\charset 00
\rgbColor 0,0,255
\-fnt
\mkrOverThis shd
\-mkr

\+mkr shd3
\nam Section Heading -3
\lng Default
\+fnt 
\Name Times New Roman
\Size 12
\Bold
\charset 00
\rgbColor 0,0,255
\-fnt
\mkrOverThis shd2
\-mkr

\+mkr shd4
\nam section head level 4
\lng Default
\+fnt 
\Name Times New Roman
\Size 12
\Italic
\charset 00
\rgbColor 0,0,255
\-fnt
\mkrOverThis key
\mkrFollowingThis txt
\CharStyle
\-mkr

\+mkr txt
\nam Content text
\lng Default
\+fnt 
\Name Times New Roman
\Size 13
\charset 00
\rgbColor 0,0,0
\-fnt
\mkrOverThis key
\-mkr

\+mkr typ
\nam Type
\lng Default
\+fnt 
\Name Times New Roman
\Size 12
\rgbColor 128,0,0
\-fnt
\mkrOverThis key
\-mkr

\-mkrset

\iInterlinCharWd 8
\+filset 

\-filset

\+jmpset 
\+jmp References
\+mkrsubsetIncluded 
\mkr cf
\mkr ftx
\-mkrsubsetIncluded
\+drflst 
\-drflst
\MatchWhole
\match_char p
\-jmp
\-jmpset

\+template 
\-template
\mkrRecord key
\+PrintProperties 
\header File: &f, Date: &d
\footer Page &p
\topmargin 1.00 in
\leftmargin 0.25 in
\bottommargin 1.00 in
\rightmargin 0.25 in
\recordsspace 100
\-PrintProperties
\+expset 

\+expRTF Rich Text Format
\exportedFile C:\Alan\ToolboxC\ToolboxMDFFields\ToolboxMDFFields.rtf
\MarkerFont
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

\expDefault Rich Text Format
\SkipProperties
\-expset
\PreventNumbering
\DisableNumbering
\-DatabaseType
