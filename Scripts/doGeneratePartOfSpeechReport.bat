@echo off
REM Generate report on Nkonya Lexicon file
REM
REM
REM Hannes Hirzel
REM  8 August 2012
REM created
REM Wes Peacock
REM 13 August 2012
REM add checks for ..\tmp, ..\reports busybox.exe
REM change sed to egrep
REM copy lexical file to ..\tmp directory with rename
REM turn off echo

REM
REM
REM Tool used is busybox for Windows
REM

REM the backslash character needs to be escaped
REM
busybox echo Producing a List of  Part of Speech markers from .\Nkolex in Unicode.txt 2>NUL
if not errorlevel 9009 goto BUSYBOX_INSTALLED
ECHO This script requires busybox.exe. You can get it from:
ECHO      https://github.com/pclouds/busybox-w32
ECHO The link is near the top of the page
goto EOF

:BUSYBOX_INSTALLED
if not exist ..\tmp md ..\tmp
copy "..\Nkolex in Unicode.txt" ..\tmp\NkolexInUnicode.txt
busybox egrep "\\ps " ..\tmp\NkolexInUnicode.txt  > ..\tmp\tmp2onlyPsFields.txt



 busybox sort ..\tmp\tmp2onlyPsFields.txt > ..\tmp\tmp3onlyPsFieldsSorted.txt


if not exist ..\reports md ..\reports
 busybox uniq -c ..\tmp\tmp3onlyPsFieldsSorted.txt > ..\reports\reportNkolexPartOfSpeechStatistics.txt

ECHO The list is in reports\reportNkolexPartOfSpeechStatistics.txt of the Nkonya directory

:EOF
