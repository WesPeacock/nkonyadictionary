# perl -pf fwdopl.pl FileName.fwdata
# Converts fwdata file to one record per line
chomp;
print "\n" if /\<rt class/;

