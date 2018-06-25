#usage: perl insref.pl <input >output
# inserts a \ref marker before each \v in a Scriputure SFM file
# \rev ID:chapter:verse
# On Linux system do:
# fromdos input
# on the SFM file before running this to delete carriage returns on the markers
# 2 digit only cf insrefPSA.pl

$chapter=$verse="00";
$id="___";
print "\\ref ___:00:00\n";
while (<>) {
	if (/\\v /) {
		@refmark=split / /;
		$verse = $refmark[1];
		chomp $verse;
		if ($verse+0 < 10) {$verse ="0".$verse;};
		print "\\ref $id:$chapter:$verse\n";
		}
	elsif (/\\c /) {
		@refmark=split / /;
		$chapter = $refmark[1];
		chomp $chapter;
		if ($chapter+0 < 10) {$chapter ="0".$chapter;};
		$verse="00";
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
