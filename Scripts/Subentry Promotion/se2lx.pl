#!/usr/bin/perl
# perl -n -f se2lx.pl
# or
# perl -p -f se2lx.pl
#
# removes \se fields from an SFM Lexical file and promotes them to \lx entries
# adds \mn markers that refer to the original head and sense
# call it with -p  option to print all the records, with the -n to print just the promoted subentries
# input should be preprocessed to change all CRLFs to ## except before \lx
#     Run it like:
#        dos2unix <da-din-org.sfm |\
#        perl -pe 's/#/__hash__/g' |\
#        perl -pe 's/\n*$/##/' |\
#        perl -pe 's/##\\lx/\n\\lx/g' |\
#        perl -pf Scripts/se2lx.pl |\
#        perl -pe 's/##/\n/g' |\
#        perl -pe 's/__hash__/#/g' |\
#        unix2dos >da-din-se-promoted.sfm

# Bugs/Enhancements:
#     Don't really need ## as \n replacement,
#      could use #, since we're replacing all the #'s before/after.
#      But, IIABDFI


use strict;
use warnings;
use English;

my $dt = sprintf ("\\dt %02d/%s/%s##", (localtime)[3], (substr localtime(), 4, 3), (localtime)[5]+1900);# new dt line -- trailing ##

my $lxfield =""; # key of master record -- no ##
my $subentry = ""; # text of subentry record -- trailing ##
my $hmno = ""; # text of homograph number if any -- no ##
my $beforestuff = "";	#preceding subentry record i.e.: \lx ... <char before \se> -- trailing ##
my $afterstuff = "";	# master record text following subentry i.e. <field following subentry>...\dt field  -- trailing ##
my $snno=""; # text of sense number if any -- no ##
my @snfields = "";

m/\\lx ([^#]*?)##/;  $lxfield=$1;
$hmno=""; $hmno= $1 if m/\\hm ([^#]*?)##/;

while (/\\se.*?(?=(\\sn|\\se|\\dt|\\ps[^#]*?##\\sn))/)  {
	$beforestuff = $PREMATCH;
	$afterstuff = $POSTMATCH;
	$subentry = $MATCH;

	@snfields= $beforestuff =~ /\\sn([^#]*?)##/g;
	$snno = $snfields[-1];

	$subentry =~ s/\\se ([^#]*?)##/\\lx $1##\\mn $lxfield$hmno$snno##/;
	print "$subentry$dt\n" ;

	# delete subentry from master record and change date
	s/\\se.*?(?=(\\sn|\\se|\\dt|\\ps[^#]*?##\\sn))//;
	s/\\dt[^#]*?##/$dt/;
	}
