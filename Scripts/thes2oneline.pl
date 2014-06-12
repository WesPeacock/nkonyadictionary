# This perl script converts Tony Naden's thesaurus database into one line per entry.
# You can then use find or grep to find all the entries that contain a string.

# usage (in the main directory)
#     perl -f Scripts/thes2oneline.pl <TNthesaurus2008.txt >tmp/ths-singleline

# to see searches within Toolbox set up a dummy text type file result.txt in the tmp directory with toolbox
# from Toolbox run a command (ctrl-U) like (delete the #):
# find "test" ..\tmp\ths-singleline >>..\tmp\result.txt

# I prefer something a little more complex:
# echo test.* | bash -c "cd ../tmp ; cp searchthes.txt result.txt ;  grep \"$(cat)\" ths-singleline >>result.txt"
# where searchthes.txt is an empty text file and I've installed the excellent bash support with the git from msysgit.github.io

 undef $/;
    $_ = <>;          # whole file now here
	s/\n\\wd/&RM&/g;  # EOL in front of record markers get remembered
	s/\n/ /g;  # all other EOLs get turned to spaces
	s/&RM&/\n\\wd/g; # restore EOL and record markers

	# These last two searches are to my taste and can be deleted
	s/ \\is /; TN_/g; # change \is marker to semicolon allows you to string the markers
	s/ \\td .*?\n/\n/g; # remove the date marker so that the semantic domain marker is (mostly) at the end of the line

	print $_;
	