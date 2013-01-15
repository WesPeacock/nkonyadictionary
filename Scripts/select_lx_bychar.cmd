rem Run this script to create a set of  files tmp\Nkolex-a.txt through tmp/Nkolex-y.txt containing
rem Nkolex in Unicode.txt with each file containing entries starting with the corresponding letter
for %%i in ( a b c d e [ f g h i x k l m n _ o ] p r s t u q v w y ) do call Scripts\select_lx_char.cmd %%i
