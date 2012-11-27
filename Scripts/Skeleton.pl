# usage perl -f Scripts\Skeleton.pl <tmp\justentries.txt
# use this script on a file that has had removed all fields except \lx \sn \se \ge \de
# for example:
# busybox.exe grep -E "\\lx |\\sn |\\se |\\ge |\\de " <"Nkolex in Unicode.txt" >tmp\justentries.txt
use strict;
use warnings;
use English;

my $recmark="\\lx ";
$RS = $recmark;

RECORD: while (<>) {
if ($NR== 1)  { next RECORD}; # skip header info

    chomp;
	my $count=0;
	my $recstring = $recmark. $_;
	$_=$recstring;
	
	
	if ($recstring =~ /\n\n./) { # any \ge or \de with a semicolon or comma
		print;
		};	}
