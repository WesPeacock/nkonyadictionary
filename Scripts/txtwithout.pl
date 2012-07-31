#usage: txwithoutmb.pl inputfile
# or txwithoutmb.pl inputfile |head
#prints verse references that contain texts not parsed by toolbox
# read interlinearized file from command line if there else from STDIN
while (<>) {
	chomp; 
	if (/\\ref /) { $ref=(split/ /)[1];}
	if (/\\tx /)  {
		if (<> !~ /\\mb /) {print "$ref has unparsed text\n";}
		}
	}