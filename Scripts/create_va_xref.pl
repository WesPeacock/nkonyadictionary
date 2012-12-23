# usage perl -s -f Scripts\create_va_xref.pl <"Nkolex in Unicode.txt" >tmp\x.tmp
# and then merge Nkolex in Unicode.txt into tmp\x.tmp
# creates an empty lexical entry for each variant that contains a cross-reference to the original entry.

 use utf8;      # so literals and identifiers can be in UTF-8
 use v5.12;     # or later to get "unicode_strings" feature
 use strict;    # quote strings, declare variables
 use warnings;  # on by default
 use warnings  qw(FATAL utf8);    # fatalize encoding glitches
 use open      qw(:std :utf8);    # undeclared streams in UTF-8
 use charnames qw(:full :short);  # unneeded in v5.16
 use English;
my $lex;
while (<>) {
	chomp;
	if (/\\lx (.*)/)  {  # save contents of lexical entry
		$lex=$1;
		};
		
	if (/\\va (.*)/) {
		print "\\lx $1\n\\cf $lex\n";
		}; 
#	print;
}
