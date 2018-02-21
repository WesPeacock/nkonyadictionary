# perl -pf opl.pl
chomp;
print "\n" if /\\lx /;
s/#/\_\_hash\_\_/g;
$_ .= "#"