# usage perl -f Scripts\ChangePluralPh.pl <"Nkolex in Unicode.txt" >tmp\x.tmp
# and then load tmp\x.tmp into Toolbox to process the records with blanks
# changes \ph fields after \pl to \plph

use strict;
use warnings;
use English;

my $recmark="\\lx ";
$RS = $recmark;

RECORD: while (<>) {
	if ($NR== 1)  {  # save header info
		my $fileheader=$_;
		next RECORD
		};
	my $count=0;

	# move record marker from the end of the record to the beginning
	chomp;
	my $recstring = $recmark. $_;
	$_=$recstring;

	# Processing for each record goes after this


	if ($recstring =~ /(\\pl[^\n]*)\n(\\ph)/) {
		print "$`$1\n\\plph$'";
		$count++;
		}
	else {
		print;
		};
}
