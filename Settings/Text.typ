\+DatabaseType Text
\ver 5.0
\desc Standard interlinear text type.
\+mkrset 
\lngDefault vernacular
\mkrRecord id

\+mkr c
\nam *
\lng vernacular
\mkrOverThis id
\-mkr

\+mkr ft
\nam Free Translation
\desc Free translation of the referenced text unit. This is not used or modified during interlinearization. It is information to clarify the meaning of the text.
\lng vernacular
\+fnt 
\Name Doulos SIL Ghana
\Size 14
\Italic
\charset 00
\rgbColor 0,0,0
\-fnt
\mkrOverThis ref
\mkrFollowingThis ref
\-mkr

\+mkr ge
\nam Gloss
\desc English gloss of each morpheme in the morpheme breaks line.
\lng English
\mkrOverThis tx
\-mkr

\+mkr h
\nam *
\lng vernacular
\mkrOverThis id
\-mkr

\+mkr id
\nam Text Name
\desc Identifying name for the text in this record.
\lng English
\-mkr

\+mkr m
\nam *
\lng vernacular
\mkrOverThis id
\-mkr

\+mkr mb
\nam Morphemes
\desc Source text unit divided into morphemes.
\lng vernacular
\+fnt 
\Name Doulos SIL Ghana
\Size 14
\Italic
\charset 00
\rgbColor 0,0,0
\-fnt
\mkrOverThis tx
\-mkr

\+mkr mt1
\nam *
\lng vernacular
\mkrOverThis id
\-mkr

\+mkr mt2
\nam *
\lng vernacular
\mkrOverThis id
\-mkr

\+mkr nt
\nam Notes
\desc Notes on the referenced text unit. Useful for explanation, clarification, questions, etc.
\lng English
\mkrOverThis ref
\-mkr

\+mkr p
\nam *
\lng vernacular
\mkrOverThis id
\-mkr

\+mkr ps
\nam Part of Speech
\desc Part of speech of each morpheme in the morpheme breaks line.
\lng English
\mkrOverThis tx
\-mkr

\+mkr q1
\nam *
\lng vernacular
\mkrOverThis id
\-mkr

\+mkr q2
\nam *
\lng vernacular
\mkrOverThis id
\-mkr

\+mkr r
\nam *
\lng vernacular
\mkrOverThis id
\-mkr

\+mkr ref
\nam Reference
\desc Reference for the following text unit. References are used for word list and concordance, plus other purposes.  A reference usually consists of a short abbreviation of the text name, followed by a dot and a number. Text numbering and renumbering automatically update references in this form.
\lng English
\mkrOverThis id
\mkrFollowingThis tx
\-mkr

\+mkr rem
\nam *
\lng vernacular
\mkrOverThis id
\-mkr

\+mkr s
\nam *
\lng vernacular
\mkrOverThis id
\-mkr

\+mkr toc1
\nam *
\lng vernacular
\mkrOverThis id
\-mkr

\+mkr toc2
\nam *
\lng vernacular
\mkrOverThis id
\-mkr

\+mkr tx
\nam Text
\desc Source text unit for interlinearization. Usually a sentence or clause. After interlinearization there may be multiple text lines in a referenced text unit.
\lng vernacular
\mkrOverThis ref
\mkrFollowingThis ft
\-mkr

\+mkr v
\nam *
\lng vernacular
\mkrOverThis id
\-mkr

\-mkrset

\iInterlinCharWd 8

\+intprclst 
\fglst {
\fglend }
\mbnd +
\mbrks -

\+intprc Lookup
\bParseProc
\mkrFrom tx
\mkrTo mb

\+triLook 
\+drflst 
\-drflst
\-triLook

\+triPref 
\dbtyp MDF 4.0
\+drflst 
\+drf 
\File C:\My Toolbox Projects\Nkonya\Scripture Names.txt
\-drf
\+drf 
\File C:\My Toolbox Projects\Nkonya\Parsing Dictionary.txt
\-drf
\+drf 
\File C:\My Toolbox Projects\Nkonya\Nkolex in Unicode.txt
\-drf
\-drflst
\+mrflst 
\mkr lx
\mkr a
\-mrflst
\mkrOut u
\-triPref

\+triRoot 
\dbtyp MDF 4.0
\+drflst 
\+drf 
\File C:\My Toolbox Projects\Nkonya\Scripture Names.txt
\-drf
\+drf 
\File C:\My Toolbox Projects\Nkonya\Parsing Dictionary.txt
\-drf
\+drf 
\File C:\My Toolbox Projects\Nkonya\Nkolex in Unicode.txt
\-drf
\-drflst
\+mrflst 
\mkr lx
\mkr a
\-mrflst
\mkrOut u
\-triRoot
\GlossSeparator ;
\FailMark *
\bShowFailMark
\bShowRootGuess
\bPreferSuffix
\+wdfset 
\wdfPrimary Word
\+wdf Word
\+wdplst 
\-wdplst
\-wdf
\lngPatterns vernacular
\-wdfset
\-intprc

\+intprc Lookup
\mkrFrom mb
\mkrTo ge

\+triLook 
\dbtyp MDF 4.0
\+drflst 
\+drf 
\File C:\My Toolbox Projects\Nkonya\Parsing Dictionary.txt
\-drf
\+drf 
\File C:\My Toolbox Projects\Nkonya\Scripture Names.txt
\-drf
\+drf 
\File C:\My Toolbox Projects\Nkonya\Nkolex in Unicode.txt
\-drf
\-drflst
\+mrflst 
\mkr lx
\-mrflst
\mkrOut ge
\-triLook
\GlossSeparator ;
\FailMark ***
\bShowFailMark
\bShowRootGuess
\-intprc

\+intprc Lookup
\mkrFrom mb
\mkrTo ps

\+triLook 
\dbtyp MDF 4.0
\+drflst 
\+drf 
\File C:\My Toolbox Projects\Nkonya\Parsing Dictionary.txt
\-drf
\+drf 
\File C:\My Toolbox Projects\Nkonya\Scripture Names.txt
\-drf
\+drf 
\File C:\My Toolbox Projects\Nkonya\Nkolex in Unicode.txt
\-drf
\-drflst
\+mrflst 
\mkr lx
\-mrflst
\mkrOut ps
\-triLook
\GlossSeparator ;
\FailMark ***
\bShowFailMark
\bShowRootGuess
\-intprc

\-intprclst
\+filset 

\-filset

\+jmpset 
\+jmp Morphemes
\+drflst 
\+drf 
\File C:\My Toolbox Projects\Nkonya\Nkolex in Unicode.txt
\mkr lx
\-drf
\+drf 
\File C:\My Toolbox Projects\Nkonya\Parsing Dictionary.txt
\mkr lx
\-drf
\+drf 
\File C:\My Toolbox Projects\Nkonya\Scripture Names.txt
\mkr lx
\-drf
\-drflst
\MatchWhole
\match_char p
\-jmp
\-jmpset

\+template 
\fld \ref
\fld \tx
\-template
\mkrRecord id
\mkrTextRef ref
\+PrintProperties 
\header File: &f, Date: &d
\footer Page &p
\topmargin 1.00 in
\leftmargin 0.25 in
\bottommargin 1.00 in
\rightmargin 0.25 in
\recordsspace 10
\-PrintProperties
\+expset 

\+expRTF Rich Text Format
\InterlinearSpacing 120
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

\SkipProperties
\-expset
\+numbering 
\mkrRef ref
\mkrTxt tx
\+subsetTextBreakMarkers 
\+mkrsubsetIncluded 
\mkr tx
\-mkrsubsetIncluded
\-subsetTextBreakMarkers
\-numbering
\-DatabaseType
