# usage perl -s -f Scripts\RecordsWith_lx_char.pl -lxchar=X <"Nkolex in Unicode.txt" >tmp\x.tmp
# and then load tmp\x.tmp into Toolbox to process the records with "\lx X..."
# where X is one of "abde[fghixjklmn_o]prstuqvwy"
# note that _ is used instead of = for ŋ (Windows CMD doesn't like =)
# [x=]q are used for ɛɩŋɔʋ respectively

 use utf8;      # so literals and identifiers can be in UTF-8
 use v5.12;     # or later to get "unicode_strings" feature
 use strict;    # quote strings, declare variables
 use warnings;  # on by default
 use warnings  qw(FATAL utf8);    # fatalize encoding glitches
 use open      qw(:std :utf8);    # undeclared streams in UTF-8
 use charnames qw(:full :short);  # unneeded in v5.16
use English;

our $lxchar;
my $lxchar_uc;
my $recmark="\\lx ";
$RS = $recmark;


# if  ($lxchar eq "[" ) { $lxchar= "ɛ";  $lxchar_uc = "Ɛ"}
# elsif ($lxchar eq "x" ) { $lxchar= "ɩ";  $lxchar_uc =  "Ɩ"}
# elsif ($lxchar eq "_" ) { $lxchar= "ŋ";  $lxchar_uc =  "Ŋ"}
# elsif ($lxchar eq "]" ) { $lxchar= "ɔ";  $lxchar_uc =  "Ɔ"}
# elsif ($lxchar eq "q" ) { $lxchar= "ʋ";  $lxchar_uc =  "Ʋ"}
# else {$lxchar_uc = uc($lxchar) };

if  ($lxchar eq "[" ) { $lxchar= "ɛ"; }
elsif ($lxchar eq "x" ) { $lxchar= "ɩ"; }
elsif ($lxchar eq "_" ) { $lxchar= "ŋ"; }
elsif ($lxchar eq "]" ) { $lxchar= "ɔ"; }
elsif ($lxchar eq "q" ) { $lxchar= "ʋ";}

$lxchar= lc($lxchar) ;

RECORD: while (<>) {
	if ($NR== 1)  {  # save header info
		my $fileheader=$_;
		next RECORD
		};
	my $count=0;

	# move record marker from the end of the record to the beginning
	chomp;
	my $recstring = $recmark. $_;
	$_=$recstring;

	# Processing for each record goes after this

	if (lc($recstring) =~ /\\lx \-*$lxchar/) {
		# any record that starts with the letter
		print;
		$count++;
		}; 
		
}
