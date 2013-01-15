for %%i in ( all a b c d e [ f g h i x k l m n _ o ] p r s t u q v w y ) do perl -f Scripts\movepluralph.pl <tmp\BeforeFix\nkolex-%%i.rtf >tmp\AfterFix\nkolex-%%i.rtf 
