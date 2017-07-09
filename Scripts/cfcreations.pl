#!/usr/bin/perl
# perl -n -f Scripts/cfcreations.pl
#
# creates new \cf fields from \va, \vaa, \vad, and \vas field clusters
# \va ...(\vaph) ...(\ve)
# \vaa ... (\vaaph)...
# \vad ... (\vadph)... (\ve)
# Reads a one per line record E.g.:
# \lx ɔdaɩ#\ph ɔdáɪ#\ps ADJ#\sn#\ge sour#\is 2.3.3#\de sour#\dt 01/Jul/2014#
# input should be preprocessed to change all CRLF sequences to # except before \lx
#     Run it like:
#        dos2unix <da-din-org.sfm |\
#        perl -pe 's/#/__hash__/g' |\
#        perl -pe 'chomp; print "\n" if /\\lx /; $_ .= "#"' |\
#        perl -pe 's/##/#/g; s/#$//' |\
#        perl -pf Scripts/cfcreatios.pl|\
#        unix2dos >da-din-se-promoted.sfm

# dos2unix <Nkolex\ in\ Unicode.txt | perl -pe 's/#/__hash__/g' | perl -pe 's/\n*$/#/' | perl -pe 's/#\\lx/\n\\lx/g' >/tmp/y.bak &&  perl -pe 's/##/#/g' </tmp/y.bak >/tmp/y.tmp 
# cp Nkolex\ in\ Unicode.txt Nkolex\ in\ Unicode\ -\ LexiquePro.txt && perl -n -f Scripts/cfcreations.pl </tmp/y.tmp >>Nkolex\ in\ Unicode\ -\ LexiquePro.txt 

use strict;
use warnings;
use English;
use 5.016;

my $dt = sprintf ("\\dt %02d/%s/%s", (localtime)[3], (substr localtime(), 4, 3), (localtime)[5]+1900);# new dt line -- trailing ##

my $lxfield ="";
my $psfield ="";
m/\\lx ([^#]*?)#/;  $lxfield=$1;
m/\\ps\ ([^#]*?)#/; $psfield=$1;

while (s/\\vaa\ ([^#]*?)#\\vaaph\ ([^#]*?)#//) {
	say "\\lx $1";
	say "\\ph $2";
	say "\\ps $psfield";
	say "\\de different spelling of $lxfield";
	say "\\cf $lxfield";
	say "$dt\n";
	}

while (s/\\vad\ ([^#]*?)#\\vadph\ ([^#]*?)#\\ve\ ([^#]*?)#//) {
	say "\\lx $1";
	say "\\ph $2";
	say "\\ps $psfield";
	say "\\de $3 dialect for $lxfield";
	say "\\cf $lxfield";
	say "$dt\n";
	}

while (s/\\vas\ ([^#]*?)#\\vasph\ ([^#]*?)#//) {
	say "\\lx $1";
	say "\\ph $2";
	say "\\ps $psfield";
	say "\\de different spelling of $lxfield";
	say "\\cf $lxfield";
	say "$dt\n";
	}
while (s/\\vas\ ([^#]*?)#//) {
	say "\\lx $1";
	say "\\ps $psfield";
	say "\\de different spelling of $lxfield";
	say "\\cf $lxfield";
	say "$dt\n";
	}
