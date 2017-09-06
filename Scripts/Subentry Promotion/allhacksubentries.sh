# run this script in a directory that contains all of:
# hackFWvariants.pl
# PromoteSubentries.ini.org
# NkTest.fwdata
# or you can put relevant path information on the control files
# this script -- /some/path/hackFWvariants.pl
# in PromoteSubentries.ini.org -- change {in|out}filename=... to {in|out}filename=/some/path/... throughout
# However, the PromoteSubentries.ini must always be in the current director
awk '{ gsub(/hackFWvariants1/, "hackFWvariants") } ; { print}' <PromoteSubentries.ini.org |tee PromoteSubentries.ini  ; perl -f hackFWvariants.pl
awk '{ gsub(/hackFWvariants2/, "hackFWvariants") } ; { print}' <PromoteSubentries.ini.org |tee PromoteSubentries.ini ; perl -f hackFWvariants.pl
awk '{ gsub(/hackFWvariants3/, "hackFWvariants") } ; { print}' <PromoteSubentries.ini.org |tee PromoteSubentries.ini ; perl -f hackFWvariants.pl
awk '{ gsub(/hackFWvariants4/, "hackFWvariants") } ; { print}' <PromoteSubentries.ini.org |tee PromoteSubentries.ini ; perl -f hackFWvariants.pl
awk '{ gsub(/hackFWvariants5/, "hackFWvariants") } ; { print}' <PromoteSubentries.ini.org |tee PromoteSubentries.ini ; perl -f hackFWvariants.pl
