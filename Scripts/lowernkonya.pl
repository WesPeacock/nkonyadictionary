#!/usr/bin/env perl
# call with perl -p argument:
#perl -pf lowernkonya.pl input filefield
# or pipe like:
#  echo "HƐlLo WƲrld Ŋow Ɩs the time" |perl -pf lowernkonya.pl
 use utf8;      # so literals and identifiers can be in UTF-8
 use v5.12;     # or later to get "unicode_strings" feature
 use strict;    # quote strings, declare variables
 use warnings;  # on by default
 use warnings  qw(FATAL utf8);    # fatalize encoding glitches
 use open      qw(:std :utf8);    # undeclared streams in UTF-8
 use charnames qw(:full :short);  # unneeded in v5.16
tr/A-ZƐƖŊƆƲ/a-zɛɩŋɔʋ/;
