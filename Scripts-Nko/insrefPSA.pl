#usage: perl insrefPSA.pl <input >output
# inserts a \ref marker before each \v in a Scriputure SFM file
# \rev ID:chapter:verse
# On Linux system do:
# fromdos input
# on the SFM file before running this to delete carriage returns on the markers
# Handles Psalms - 3 digits leading 0s

$chapter=$verse="000";
$id="___";
print "\\ref ___:000:000\n";
while (<>) {
	if (/\\v /) {
		@refmark=split / /;
		$verse = $refmark[1];
		chomp $verse;
		if ($verse+0 < 100) {$verse ="0".$verse;};
		if ($verse+0 < 10) {$verse ="0".$verse;};
		print "\\ref $id:$chapter:$verse\n";
		}
	elsif (/\\c /) {
		@refmark=split / /;
		$chapter = $refmark[1];
		chomp $chapter;
		if ($chapter+0 < 100) {$chapter ="0".$chapter;};
		if ($chapter+0 < 10) {$chapter ="0".$chapter;};
		$verse="000";
		print "\\ref $id:$chapter:$verse\n";
		}
	elsif (/\\id /) {
		@refmark=split / /;
		$id = $refmark[1];
		chomp $id;
		print "\\ref $id:$chapter:$verse\n";
		}
	print;
}
