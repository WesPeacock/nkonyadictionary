# perl -pf de_oplpc.pl FileNameAfteropl.SFM
# undoes oplpc.pl
# Converts SFM file from one record per line to one field per line
# occurences of '__percent__'  are changed to back to '%'
chomp;
s/%/\n/g;
s/\_\_percent\_\_/%/g;
