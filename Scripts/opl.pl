# perl -pf opl.pl FileName.SFM
# Converts SFM file to one record per line
# SFM fields are terminated by '#'
# pre-existing '#' in the file are changed to '_hash_' 
chomp;
print "\n" if /\\lx /;
s/#/\_\_hash\_\_/g;
$_ .= "#"
