#!/usr/bin/env perl

# utfinfo.pl, copyleft sdaau 2013
# usage: echo TΕSТERword | perl utfinfo.pl
# started from:
# http://www.commandlinefu.com/commands/view/7535/look-up-a-unicode-character-by-name
# http://stackoverflow.com/questions/627661/how-can-i-output-utf-8-from-perl
# http://stackoverflow.com/questions/2725893/how-do-i-split-chinese-characters-one-by-one
# prefix the line with the line number and character position -- WLP 2018


use 5.10.1;
use warnings;
use strict;

=cut install:
# http://search.cpan.org/~gaas/Unicode-String-2.09/lib/Unicode/CharName.pm
sudo apt-get install libunicode-string-perl
sudo updatedb
locate CharName.pm
# /usr/lib/perl5/Unicode/CharName.pm
=cut

use Unicode::CharName qw(uname ublock);

# the other way - perl default:
# see http://perldoc.perl.org/charnames.html
use charnames ':full';

use utf8; # does not enable Unicode output - it enables you to type Unicode in your program.
# on Ubuntu 11.04:
# script is OK with binmode :raw (default binmode), :bytes (Win);
# but not with ":utf8"! (Cannot decode string with wide characters at Encode.pm)
#~ binmode(STDOUT, ":utf8");          #treat as if it is UTF-8
#~ binmode(STDIN, ":encoding(utf8)"); #actually check if it is UTF-8
binmode(STDOUT, ":raw");
binmode(STDIN, ":raw");


# http://perldoc.perl.org/Encode.html
use Encode qw(decode encode);
#~ print Encode->encodings();
#~ print Encode->encodings(":all");

my $decodingChoice = 'UTF-8';
my $encodingChoice = 'UTF-8';

sub printUchar {
  print "Char: ";
  #~ print $_; # Wide character in print at utfinfo.pl line 42, <> line 1.
  #~ print encode($encodingChoice, $_), # no warning
  my $enc_ = encode($encodingChoice, $_);
  my @uvals = unpack("U*", $_);
  my @bytevals = unpack("C*", $enc_);
  print join(" ",
    "'" . $enc_ . "'",
    "u:",
    join(",", map(sprintf("%d", $_), @uvals)),
    "[" . join(",", map(sprintf("0x%04X", $_), @uvals)) . "]",
    "b:",
    join(",", map(sprintf("%d", $_), @bytevals)),
    "[" . join(",", map(sprintf("0x%02X", $_), @bytevals)) . "]",
    "n:",
    uname(int($uvals[0])) . " [" . ublock(int($uvals[0])) . "]"
  );
  print "\n";
}


while(<>) {
  my $input_pl_string = decode($decodingChoice, $_);
  chomp $input_pl_string;
  # do not split at /(.)/; introduces empty array entries
  # use // - safe for UTF-8 too
  my @uchars = split(//, $input_pl_string);
  #print "Line $. Got ", scalar(@uchars), " uchars\n";
  my $charno = 1;
  my $lineno = $.;
  foreach (@uchars) {
    printf "%06d\:%03d ", $lineno, $charno++;
    printUchar($_);
  }
  print "\n";
}




