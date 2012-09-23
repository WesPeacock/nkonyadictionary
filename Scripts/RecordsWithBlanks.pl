# usage perl -f Scripts\RecordsWithBlanks.pl <"Nkolex in Unicode.txt" >tmp\x.tmp
# and then load tmp\x.tmp into Toolbox to process the records with blanks

use strict;
use warnings;
use English;

my $recmark="\\lx ";
$RS = $recmark;

RECORD: while (<>) {
	if ($NR== 1)  {  # save header info
		$fileheader=$_;
		next RECORD
		};
	my $count=0;

	# move record marker from the end of the record to the beginning
	chomp;
	my $recstring = $recmark. $_;
	$_=$recstring;

	# Processing for each record goes after this

	if ($recstring =~ /\n\n./) {
		# any record with 2 CRLFs not at the end of the record
		print;
		$count++;
		};
}
