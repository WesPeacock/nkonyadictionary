rem @echo off
rem Run this from the directory that contains "Nkolex in Unicode.txt" as:
rem Scripts\select_lx_char X
rem where X is one of "abde[fghixjklmn_o]prstuqvwy"
rem note that _ is used instead of = for ŋ
rem it creates a lexical database in tmp\Nkolex-X.txt

Scripts\busybox head -n 2 <tmp/nkolex-all.txt >tmp\nkolex-%1.txt
perl -s -f Scripts\RecordsWith_lx_char.pl -lxchar=%1 <tmp/nkolex-all.txt  >>tmp\nkolex-%1.txt