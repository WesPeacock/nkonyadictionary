#!/usr/bin/perl
# perl -n -f se2lx.pl
# or
# perl -p -f se2lx.pl
#
# removes \se fields from an SFM Lexical file and promotes them to \lx entries
# adds \mn markers that refer to the original head and sense
# call it with -p  option to print all the records, with the -n to print just the promoted subentries
# input should be preprocessed to change all CRLFs to ## except before \lx

use strict;
use warnings;
use English;

my $dt = sprintf ("\\dt %02d/%s/%s##", (localtime)[3], (substr localtime(), 4, 3), (localtime)[5]+1900);

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

	print "$subentry$dt##" ;

	# delete subentry from master record and change date
	s/\\se.*?(?=(\\sn|\\se|\\dt|\\ps[^#]*?##\\sn))//;
	s/\\dt[^#]*?##/$dt##/;
	}
