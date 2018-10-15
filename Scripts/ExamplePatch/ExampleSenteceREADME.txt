FWExampleExtract.pl & FWExampleEdit.pl
This pair of programs extract Example Sentences from an fwdata file. It creates lines that can be edited and applied as patches to the fwdata file. Along with the Example data, it also gives the headword and variants of the entry.
The edit program applies the patch file back onto the fwdata file.

Use them like this:
	- build a patch file with FWExampleExtract.pl
	- select the patches you're interested in
	- use FLEx to edit those Example sentences
	-or massage the patch file to do simple edits and apply them with the FWExampleEdit.pl

Task 1:
Change all Example Sentences with "Strong" styled text to "Headword in Example" style. Note that the patch program that the FWExampleEdit.pl reads must be an XML file. That is why we head/tail the first/last lines of the patch file built by FWExampleExtract.pl

	perl ./FWExampleExtract.pl >Nkonyafwdata.full.patch
	head -1 Nkonyafwdata.full.patch >Nkonyafwdata.patch
	grep 'namedStyle="Strong"' Nkonyafwdata.full.patch |perl -pe 's/namedStyle="Strong"/namedStyle="Headword in Example"/g;' >>Nkonyafwdata.patch
	tail -1 Nkonyafwdata.full.patch >>Nkonyafwdata.patch
	perl ./FWExampleEdit.pl

Task 2:
Extract all sentences where the Example sentence doesn't already have "Headword in Example" highlighting. From those sentences, find all the sentences where the Lexical headword doesn't appear exactly in the Example sentence. Display all those that start with the letters b-f (no c's). For simplicity of viewing, all XML markup on the sentence is deleted. This ruins the output for input into the ExampleEdit. 
	grep -v Headwo Nkonyafwdata.full.patch |perl -ne 'if (!/(?<=\<LexEntText><AUni ws="nko">)([^<]+)<.*?\1/i) { print  }'  |perl -pe 's/<(.)?(LexExamplePatch|AUni|AStr|Run)[^>]*>//g;' |sort |grep 'LexEntText>[bdeɛf]' |less
Bug: the match on \1 should only be inside <ExampleText> The above matches Headwords that are subsets of Variant texts.

This script shouldn't be a one-liner and the complex regex should maybe use a /x to put the various parts on separate lines Like:
	(! #match not
		/(?<=\<LexEntText><AUni ws="nko">)  # start at Headword tag
		([^<]+)<# headword stops at < of trailing XML
		.*?\1 # see Bug --should be  .*?\<ExampleText>.*?\1
		/ix)

Task 3:
Same as Task 2 checking Variants -- this is more complicated because two or more variants can occur so it can't be done by a simple regex backrefence (\1) in the search. It will be something like:
	Put tee in the Task 2 command line after LexEntText search.
		(If it has a headword don't check for variants)
	The perl script --get all the variants into an array
		@variants = ($_ =~ /(?<=\<LexEntVarText><AUni ws="nko">)([^<]+)/g)
	foreach search the Example sentence, break on match
	if !match, print the line