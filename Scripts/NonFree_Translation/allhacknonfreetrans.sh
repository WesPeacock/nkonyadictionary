# run this script in a directory that contains all of:
# hackFWNonFreeTranslation.pl
# PromoteSubentries.ini.org
# NkTest.fwdata
# or you can put relevant path information on the control files
# this script -- /some/path/hackFWNonFreeTranslation.pl
# in PromoteSubentries.ini.org -- change {in|out}filename=... to {in|out}filename=/some/path/... throughout
# However, the PromoteSubentries.ini is always created in the current directory
awk '{ gsub(/hackFWNonFreeTranslation1/, "hackFWNonFreeTranslation") } ; { print}' <PromoteSubentries.ini.org | tee PromoteSubentries.ini ; perl -f hackFWNonFreeTranslation.pl ;#
read -n1 -r -p "Press space to continue..." key ;#
awk '{ gsub(/hackFWNonFreeTranslation2/, "hackFWNonFreeTranslation") } ; { print}' <PromoteSubentries.ini.org >PromoteSubentries.ini ; perl -f hackFWNonFreeTranslation.pl ;#
read -n1 -r -p "Press space to continue..." key ;#
