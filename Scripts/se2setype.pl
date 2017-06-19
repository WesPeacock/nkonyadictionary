#!/usr/bin/perl
# perl -n -f se2setype.pl
# or
# perl -p -f se2setype.pl
#
# changes \se to a corresponding \se<TYPE> where <TYPE> is dependent on the presence of \ctyp entry
#    \secmpd for \ctyp _Compound_
#    \seder for \ctyp _Derivative_
#    \seid for \ctyp _Idiom_
#    \secmpx for \ctyp Complex_Form
#    \sephv for \ctyp Phrasal_Verb
#    \seundef for \ctyp not present or some other value
#  the \ctyp entry gets deleted

# input should be preprocessed to change all CRLFs to # except before \lx
#     Run it like:
#        dos2unix <inputfile.sfm | perl -pe 's/#/__hash__/g' | perl -pe 's/\n*$/#/' | perl -pe 's/#\\lx/\n\\lx/g' |\
#        perl -pf Scripts/se2setype.pl |\
#        perl -pe 's/#/\n/g' | perl -pe 's/__hash__/#/g' | unix2dos >ouputfile.sfm

# Bugs/Enhancements:

use strict;
use warnings;
use English;

my $subentry = ""; # text of subentry record -- trailing #
my $beforestuff = "";	#preceding subentry record i.e.: \lx ... <char before \se> -- trailing #
my $afterstuff = "";	# master record text following subentry i.e. <field following subentry>...\dt field  -- trailing #

while (/\\se .*?(?=(\\sn|\\se|\\dt|\\ps[^#]*?#\\sn))/)  {
	$beforestuff = $PREMATCH;
	$afterstuff = $POSTMATCH;
	$subentry = $MATCH;

	if ($subentry =~  s/\\ctyp _Compound_#//)  { $subentry =~  s/\\se /\\secmpd / }
	elsif ($subentry =~  s/\\ctyp _Derivative_#//)  { $subentry =~  s/\\se /\\seder / }
	elsif ($subentry =~  s/\\ctyp _Idiom_#//)  { $subentry =~  s/\\se /\\seid / }
	elsif ($subentry =~  s/\\ctyp Complex_Form#//)  { $subentry =~  s/\\se /\\secmpx / }
	elsif ($subentry =~  s/\\ctyp Phrasal_Verb#//)  { $subentry =~  s/\\se /\\sephv / }
	else {$subentry =~  s/\\se /\\seundef /}
	$_ = $beforestuff . $subentry . $afterstuff;
	}
