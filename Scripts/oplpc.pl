# perl -pf oplpc.pl FileName.SFM
# Converts SFM file to one record per line
# SFM fields are terminated by '%'
# pre-existing '%' in the file are changed to '__percent__'
chomp;
print "\n" if /^\\lx /;
s/%/\_\_percent\_\_/g;
$_ .= "%"
