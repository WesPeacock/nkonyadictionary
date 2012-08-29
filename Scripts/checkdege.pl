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

	if ($recstring =~ /\\lx [^\\]*$/) { # print empty records
	print $., ": " ;
	print $recstring;
		next RECORD;
		};

	s/\\sn [^\\]*\\ge [^\\]*\\de [^\\]*//g; # valid \sn
	s/\\se [^\\]*\\ge [^\\]*\\de [^\\]*//g; # valid \se
	$recstring = $_;
	if ($recstring =~ /\\lx [^\\]*\\ge [^\\]*\\de [^\\]*$/) {
# omit ordinary \lx \ge \de
		next RECORD;
		};

	if ($recstring =~ /\\lx [^\\]*$/) { # skip newly emptied records
		next RECORD;
		};

	print $recstring;
	}
