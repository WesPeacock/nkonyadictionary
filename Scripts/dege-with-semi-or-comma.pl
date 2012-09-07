# usage perl -f Scripts\dege-with-semi-or-comma.pl <tmp\justentries.txt
# use this script on a file that has had removed all fields except \lx \sn \se \ge \de
# for example:
# busybox.exe grep -E "\\lx |\\sn |\\se |\\ge |\\de " <"Nkolex in Unicode.txt" >tmp\justentries.txt
use strict;
use warnings;
$/ = "\\lx ";

RECORD: while (<>) {
if ($. == 1)  { next RECORD}; # skip header info

    chomp;
	my $count=0;
	my $recstring = "\\lx " . $_;
	$_=$recstring;
	
	if ($recstring =~ /\\[gd]e [^\\]*[;,]/) { # any \ge or \de with a semicolon or comma
		print;
		};
	}
