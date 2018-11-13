# perl -pf de_opl.pl FileNameAfteropl.SFM
# undoes opl.pl & opl-bsl
# Converts SFM file from one record per line to one field per line
# occurences of '_hash_'  are changed to back to '#'
chomp;
s/#/\n/g;
s/\_\_hash\_\_/#/g;
