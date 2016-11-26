#!/usr/bin/perl
# perl -nf sortis.pl
# Sorts the \is fields in an SFM file
#     Run it in bash like:
#        cp Nkolex\ in\ Unicode.txt Nkolex\ in\ Unicode.bkp
#        dos2unix <Nkolex\ in\ Unicode.bkp |\
#        perl -pe 's/#/__hash__/g' |\
#        perl -pe 's/\n*$/#/' |\
#        perl -pe 's/#\\lx/\n\\lx/g' |\
#        perl -nf Scripts/sortis.pl |\
#        perl -pe 's/#/\n/g' |\
#        perl -pe 's/__hash__/#/g' |\
#        unix2dos >Nkolex\ in\ Unicode.txt
# Note that this uses a single # for line endings
#     cf se2lx.pl which uses ##
use strict;
use warnings;
use English;
use v5.16;
# m/is\ [0-9]/;
#/(\\is\ [0-9](\.[0-9])*#)*/;
chomp;
if (/(\\is\ [0-9](\.[0-9])*#)+/){
	my $pm;
	while (/(\\is\ [0-9](\.[0-9])*#)+/){
		print $PREMATCH;
		my $is=$MATCH;
		$pm=$POSTMATCH;
		$is =~ s/#$//;
		print join("#",sort(split("#",$is)));
		print "#";
		$_ =  $pm;
		}
	print $pm;
	}
else {
	print;
	};
print "\n";
