REM Generate report on Nkonya Lexicon file
REM
REM
REM Hannes Hirzel
REM August 2012 
REM
REM
REM Tool used is busybox for Windows
REM
REM http://javaforu.blogspot.com/2011/04/little-gem-that-is-busybox-for-windows.html
REM https://github.com/pclouds/busybox-w32
REM
REM
REM the basic form of the stream editor command (sed) is
REM  s/something/somethingElse/g
REM  substitue something with somethingElse globally
REM  (i.e. in the input line)
REM
REM However here we use the print (p) command 

REM emulate grep for \ps
REM the backslash character needs to be escaped
REM
 busybox sed -n "/\\ps /p" ..\NkolexInUnicode.txt  > ..\tmp\tmp2onlyPsFields.txt


 busybox sort ..\tmp\tmp2onlyPsFields.txt > ..\tmp\tmp3onlyPsFieldsSorted.txt


 busybox uniq -c ..\tmp\tmp3onlyPsFieldsSorted.txt > ..\reports\reportNkolexPartOfSpeechStatistics.txt
