FWDefinitionExtract.pl & FWDefinitionEdit.pl
This pair of programs extract the Definitions from an fwdata file. It creates lines that can be edited and applied as patches to the fwdata file. As well as Example Definition data, it also finds the headword of the entry.
The edit program, not yet written, will apply the patch file back onto the fwdata file.

Use them like this:
	- build a patch file with FWDefinitionExtract.pl
	- select the patches you're interested in
	-or massage the patch file to do simple edits and apply them with the FWTranslationEdit.pl

See the Example Extract/Edit scripts for more details.

These scripts were based on the Example patch scripts, but have nicer options and more INI parameters.

Sample options & an INI file are included in the comments in the script