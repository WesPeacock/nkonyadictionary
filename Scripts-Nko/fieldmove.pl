use strict;
use warnings;
$/ = "\\lx ";

RECORD: while (<>) {
	if ($. == 1)  {print; next RECORD};

    chomp;
	my $count=0;
	my $recstring = "\\lx " . $_;
	while ($recstring =~ /\\ps /g) { $count++ }
	if ($count > 1)   {print $recstring; next};

	if ($recstring =~ /(\\lx [^\n]*?\n\\ph [^\n]*?\n\\ps [^\n]*?\n)/)  { print $recstring; next RECORD};
	if ($recstring =~ /(\\lx [^\n]*?\n\\hm [^\n]*?\n\\ph [^\n]*?\n\\ps [^\n]*?\n)/)  {print $recstring; next RECORD};
	if ($recstring =~ /\\lx [^\n]*?\n\\ph [^\n]*?\n/)  {
		print $&;
		$recstring = $';
		$recstring =~ /\\ps [^\n]*?\n/;
		print $&, $`, $';
		next RECORD
		};
	if ($recstring =~ /\\lx [^\n]*?\n\\hm [^\n]*?\n\\ph [^\n]*?\n/)  {
		print $&;
		$recstring = $';
		$recstring =~ /\\ps [^\n]*?\n/;
		print $&, $`, $';
		next RECORD
		};

	$recstring =~ /\\lx [^\n]*?\n/ ;
	print $&, "\\nt this record is something else\n", $';
	}
