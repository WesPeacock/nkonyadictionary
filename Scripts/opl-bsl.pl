#! /bin/perl opl-bsl.pl -p
# concatenate all lines that don't start with a \ character
# replacing the newline with an octothorpe
# replace pre-existing octothorpes with "__hash__"
chomp;
print "\n" if /^\\/;
s/#/\_\_hash\_\_/g;
$_ .= "#"
