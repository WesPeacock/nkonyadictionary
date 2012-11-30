\+DatabaseType Scripture Interlinear
\ver 5.0
\desc Scripture interlinear text type.
\+mkrset 
\lngDefault vernacular
\mkrRecord ref

\+mkr c
\nam Chapter
\lng vernacular
\mkrOverThis ref
\CharStyle
\-mkr

\+mkr dt
\nam date changed
\lng Date
\mkrOverThis ref
\CharStyle
\-mkr

\+mkr ft
\nam Free Translation
\desc Free translation of the referenced text unit. This is not used or modified during interlinearization. It is information to clarify the meaning of the text.
\lng vernacular
\+fnt 
\Name Doulos SIL
\Size 14
\Italic
\charset 00
\rgbColor 0,0,0
\-fnt
\mkrOverThis ref
\-mkr

\+mkr ge
\nam Gloss
\desc English gloss of each morpheme in the morpheme breaks line.
\lng English
\+fnt 
\Name Doulos SIL
\Size 11
\Italic
\charset 00
\rgbColor 255,0,0
\-fnt
\mkrOverThis tx
\-mkr

\+mkr h
\nam Header
\lng vernacular
\mkrOverThis ref
\-mkr

\+mkr id
\nam Text Name
\desc Identifying name for the text in this record.
\lng English
\mkrOverThis ref
\-mkr

\+mkr lx
\nam *
\lng vernacular
\mkrOverThis ref
\-mkr

\+mkr m
\nam Margin Paragraph
\lng vernacular
\mkrOverThis ref
\-mkr

\+mkr mb
\nam Morphemes
\desc Source text unit divided into morphemes.
\lng vernacular
\+fnt 
\Name Doulos SIL
\Size 14
\Italic
\charset 00
\rgbColor 0,0,128
\-fnt
\mkrOverThis tx
\-mkr

\+mkr mt1
\nam Main Title 1
\lng vernacular
\mkrOverThis ref
\-mkr

\+mkr mt2
\nam Main Title 2
\lng vernacular
\mkrOverThis ref
\-mkr

\+mkr nt
\nam Notes
\desc Notes on the referenced text unit. Useful for explanation, clarification, questions, etc.
\lng English
\mkrOverThis ref
\-mkr

\+mkr p
\nam Paragraph
\lng vernacular
\mkrOverThis ref
\-mkr

\+mkr ps
\nam Part of Speech
\desc Part of speech of each morpheme in the morpheme breaks line.
\lng English
\mkrOverThis tx
\-mkr

\+mkr q1
\nam Quote Level 1
\lng vernacular
\mkrOverThis ref
\-mkr

\+mkr q2
\nam Quote Level 2
\lng vernacular
\mkrOverThis ref
\-mkr

\+mkr r
\nam Section References
\lng vernacular
\mkrOverThis ref
\-mkr

\+mkr ref
\nam Reference
\desc Reference for the following text unit. Reference consists of the Book number followed by the Book 3 letter identification followed by the chapter and verse. For Example Mark 1:41 is marked 42_MRK:01:41.
\lng English
\mkrFollowingThis tx
\-mkr

\+mkr rem
\nam Remarks
\lng vernacular
\mkrOverThis ref
\-mkr

\+mkr s
\nam Section Title
\lng vernacular
\mkrOverThis ref
\-mkr

\+mkr toc1
\nam Table Of Contents Main Name
\lng vernacular
\mkrOverThis ref
\-mkr

\+mkr toc2
\nam Table Of Contents Abbreviation
\lng vernacular
\mkrOverThis ref
\-mkr

\+mkr tx
\nam Text
\desc Source text unit for interlinearization. Usually a verse or quotation. After interlinearization there may be multiple text lines in a referenced text unit.
\lng vernacular
\mkrOverThis ref
\mkrFollowingThis ft
\-mkr

\+mkr u
\nam *
\lng vernacular
\mkrOverThis ref
\-mkr

\+mkr v
\nam Verse Number
\lng vernacular
\mkrOverThis ref
\-mkr

\-mkrset

\iInterlinCharWd 10

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
\File C:\My Toolbox Projects\Nkonya\Keyterms Dictionary.txt
\-drf
\-drflst
\+mrflst 
\mkr lx
\mkr a
\mkr se
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
\File C:\My Toolbox Projects\Nkonya\Keyterms Dictionary.txt
\-drf
\-drflst
\+mrflst 
\mkr lx
\mkr a
\mkr se
\-mrflst
\mkrOut u
\-triRoot
\GlossSeparator ;
\FailMark *
\bShowFailMark
\bShowRootGuess
\bInfixBefore
\bNoCompRoot
\+wdfset 
\wdfPrimary Word
\+wdf AdjForm
\+wdplst 
\wdp ADJ (REDUP) (POST)
\wdp VerbWord ADJizer
\-wdplst
\-wdf
\+wdf ETC
\+wdplst 
\wdp CNJ
\wdp ADV
\wdp TEMP (CNJ)
\wdp INTJ
\wdp POSS
\wdp Q
\wdp LOC
\-wdplst
\-wdf
\+wdf NounForm
\+wdplst 
\wdp PropN
\wdp n
\wdp PRO
\wdp NOMR v
\wdp NOMR vi
\wdp NOMR vt
\wdp v NOMR
\wdp vt NOMR
\wdp vi NOMR
\wdp AdjForm VerbForm
\wdp AdjForm
\wdp n (ADV) vt
\wdp n -gyí- n
\wdp LOC
\-wdplst
\-wdf
\+wdf NounWord
\+wdplst 
\wdp (nc) NounForm
\wdp (nc) NounForm (POST) (CNJ)
\wdp (nc) NounForm (PTCL)
\wdp (nc) ART (POST) (CNJ)
\wdp PRO (POST)
\wdp PRO both
\wdp DEIC (POST)
\wdp nc VerbForm NOMR
\wdp (nc) NUM (POST)
\wdp NounForm NUM
\wdp NounForm (POST) CLASS
\-wdplst
\-wdf
\+wdf REDUP
\+wdplst 
\wdp MULTIPLE
\wdp EMPH
\-wdplst
\-wdf
\+wdf VerbForm
\+wdplst 
\wdp v (TR)
\wdp vi (TR)
\wdp vt
\wdp LOC
\-wdplst
\-wdf
\+wdf VerbWord
\+wdplst 
\wdp (CNJ) (PRO)  (PTCL) (not)  (TAM) (AUX) VerbForm (REDUP) (CNJ)
\wdp (PRO) (not)  CONT
\-wdplst
\-wdf
\+wdf Word
\+wdplst 
\wdp (PTCL) NounWord (PTCL)
\wdp (PTCL) VerbWord (PTCL)
\wdp (PTCL) ETC (PTCL)
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
\File C:\My Toolbox Projects\Nkonya\Keyterms Dictionary.txt
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
\File C:\My Toolbox Projects\Nkonya\Keyterms Dictionary.txt
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
\File C:\My Toolbox Projects\Nkonya\Parsing Dictionary.txt
\mkr lx
\-drf
\+drf 
\File C:\My Toolbox Projects\Nkonya\Scripture Names.txt
\mkr lx
\-drf
\+drf 
\File C:\My Toolbox Projects\Nkonya\Nkolex in Unicode.txt
\mkr lx
\-drf
\+drf 
\File C:\My Toolbox Projects\Nkonya\Keyterms Dictionary.txt
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
\mkrRecord ref
\mkrDateStamp dt
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
\exportedFile C:\My Toolbox Projects\Nkonya\test.rtf
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

\expDefault Rich Text Format
\CurrentRecord
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
