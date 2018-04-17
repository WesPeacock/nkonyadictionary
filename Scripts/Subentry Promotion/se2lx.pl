#!/usr/bin/perl
# perl -pf opl.pl <in.sfm | perl -nf se2lx.pl | perl -pf de_opl.pl >justpromos.sfm
# or
# perl -pf opl.pl <in.sfm | perl -pf se2lx.pl | perl -pf de_opl.pl >out.sfm
#
# removes \se fields from an SFM Lexical file and promotes them to \lx entries
# adds \mn markers that refer to the original head and sense
# call it with -p  option to print all the records, with the -n to print just the promoted subentries
# input should be preprocessed to change all CRLFs to # except before \lx
#     Run it like (code also includes flags to circumfixes and non-free translations:
#        dos2unix <da-din-org.sfm |\
#        perl -pe 's#[\-]\ [\-](.*)#XX$1\-#' |\
#        perl -pe 's#\\xl (.*)#\\xl xl\:$1/xl\:#' | \
#        perl -pe 's#\\nx (.*)#\\nx nx\:$1/nx\:#' | \
#        perl -pe 's/#/\_\_hash\_\_/g' |\
#        perl -pe 's/##/#/g' |\
#        perl -pe 'chomp; print "\n" if /\\lx /; $_ .= "#"'  | \
#        perl -pf Scripts/se2lx.pl |\
#        perl -pe 's/#/\n/g' |\
#        perl -pe 's/__hash__/#/g' |\
#        unix2dos >da-din-se-promoted.sfm

# Bugs/Enhancements:

use strict;
use warnings;
use English;
my $dt = "";
if (/\\dt /) {
	$dt = sprintf ("\\dt %02d/%s/%s#", (localtime)[3], (substr localtime(), 4, 3), (localtime)[5]+1900);# new dt line -- trailing #
	}
my $lxfield =""; # key of master record -- no #
my $subentry = ""; # text of subentry record -- trailing #
my $hmno = ""; # text of homograph number if any -- no #
my $beforestuff = "";	#preceding subentry record i.e.: \lx ... <char before \se> -- trailing #
my $afterstuff = "";	# master record text following subentry i.e. <field following subentry>...\dt field  -- trailing #
my $snno = ""; # text of sense number if any -- no #
my $ps = ""; # text of last \ps field before the \se -- trailing #
my @snfields = "";
my @psfields = "";

m/\\lx ([^#]*?)#/;  $lxfield=$1;
$hmno=""; $hmno= $1 if m/\\hm ([^#]*?)#/;

while ((/\\se.*?(?=(\\sn|\\se|\\dt|\\ps[^#]*?#\\sn))/) # various terminators for a subentry
	|| (/\\se.*/)) { # or a subentry that ends the entry.
	$beforestuff = $PREMATCH;
	$afterstuff = $POSTMATCH;
	$subentry = $MATCH;

	@snfields= $beforestuff =~ /\\sn([^#]*?)#/g;
	$snno = $snfields[-1];

	if  ($subentry =~ /\\ps\ /) { # a subentry without \ps field should inherit the last preceding one
		$ps ="";
		}
	else {
		@psfields = $beforestuff =~  /\\ps[^#]*?#/g;
		$ps = $psfields[-1];
		}

	$subentry =~ s/\\se ([^#]*?)#/\\lx $1#\\mn $lxfield$hmno$snno#$ps/;
	print "$subentry$dt\n" ;

	# delete subentry from master record and change date
	(s/\\se.*?(?=(\\sn|\\se|\\dt|\\ps[^#]*?#\\sn))//)  # for a subentry not at the end
	  || (s/\\se.*//);   # subentry at the end
	s/\\dt[^#]*?#/$dt/;
	}
