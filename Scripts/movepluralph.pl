# moves the second \ph field to following \pl field
# usage:
# perl -f movepluralph.pl <Dict.rtf >Dict-fixed.rtf

# By default, Toolbox moves all \ph fields to after the \lx or \se entry. When \pl has a \ph entry, it should be after after \pl.
# Thus script moves the second \ph field to after the \pl field.

use strict;
use warnings;
use English;
my $ph=""; 		# $ph is the RTF character style tag for Phonetic form -- e.g. cs79
my $f_label=""; 		# $f_label is the RTF character style tag for f_label -- e.g. cs115
my $f_vernacular=""; 		# $f_vernacular is the RTF character style tag for f_vernacular -- e.g. cs119
while  (<>) {
	my $entry = $_;

	# {\*\cs79 \additive Phonetic form;}
	if ($_ =~ /\{\\\*\\([^ ]*).*Phonetic form/) {
		$ph=$1;
		}

	# {\*\cs115 \additive f_label;}
	if ($_ =~ /\{\\\*\\([^ ]*).*\\additive f_label/) {
		$f_label=$1;
		print "found f_label $f_label\n";
		}

	# {\*\cs119 \additive f_vernacular;}
	if ($_ =~ /\{\\\*\\([^ ]*).*\\additive f_vernacular/) {
		$f_vernacular=$1;
		print "found f_vernacular $f_vernacular\n";
		}

# \{\\$ph[^\}]*\} -- phonetic entry
# \\u32 -- space
# first phonetic entry +space goes into $1
# second phonetic entry goes into $2
# trailing space goes into $3
# .*\{\\$f_label \\u80\\u108\\u58\\u32\} -- everything up to & including "Pl: " -- goes into $4
# \{\\$f_vernacular[^\}]*\} -- plural form -- goes into $5

#	if ($_ =~ /(\{\\cs79[^\}]*\}\\u32)(\{\\cs79[^\}]*\})(\\u32)(.*\{\\cs115 \\u80\\u108\\u58\\u32\})(\{\\cs119[^\}]*\})/ ){
	$_ =~ s/(\{\\$ph[^\}]*\}\\u32)(\{\\$ph[^\}]*\})(\\u32)(.*\{\\$f_label \\u80\\u108\\u58\\u32\})(\{\\$f_vernacular[^\}]*\})/$1$4$5\\u32$2/;
	print;
}
