#!/usr/bin/perl
# This is the final script in a process to remove lexical items from sample sentences
# 1) Make a wordlist this way:
# egrep '\\lx|\\se|\\pl |\\va |\\sg ' ~/.wine/drive_c/My\ Toolbox\ Projects/Nkonya/Nkolex\ in\ Unicode.txt |sed -e 's/\\se //'|sed -e 's/\\lx //' |sed -e 's/\\pl //' |sed -e 's/\\va //' |sed -e 's/\\sg //' |sed -e 's/ X//' |sed -e 's/-//' | tr 'A-ZƐƆƖŊ' 'a-zɛɔɩŋ' | fromdos >words && cat extrawords >>words
# 2) prefixes (abɔ́, ala, ba, bɛ, bɛ́, bɔ́) & suffixes (tɔ, sʋ)  and extrawords (ignore words) are hand compiles
# 3) make the text file with: \xv sample sentence :\lxlexicalword
# the lexical item is deliberately no spaces so that it's not found in 
# 3a) an interim file with just \lx \se and \xv fields without punctuation or capitals.
# egrep '\\lx|\\se|\\xv' ~/.wine/drive_c/My\ Toolbox\ Projects/Nkonya/Nkolex\ in\ Unicode.txt |sed -e 's/\://g'| sed -e 's/\.//g'|sed -e 's/\?//g'|sed -e 's/\;//g'|sed -e 's/\!//g'|sed -e 's/\,//g' |sed -e 's/\"//g'| tr 'A-ZƐƆƖŊ' 'a-zɛɔɩŋ' |fromdos >lxsexv 
# 3b) make the actual text file
# ./putlxseonxv.pl lxsexv  >xvwithlx
# 4) use this script for displaying the residue of words that are in \lx or a suffix or a prefix
#    There's residue so you work your way through
#     The awk command below: awk '/lxafut/,/*/'  displays from \lx afut* through the end of the file
#  ./findwords.pl prefixes words suffixes xvwithlx |grep -v '\\xv  \:' | awk '/lxafut/,/*/' |less

use warnings;
use English;
use v5.12;

# poor man's argument handler
open(PREFIXES, shift @ARGV) || die "failed to open prefixes file: $!";
open(WORDS, shift @ARGV) || die "failed to open words file: $!";
open(SUFFIXES, shift @ARGV) || die "failed to open suffixes file: $!";
open(REPLACE, shift @ARGV) || die "failed to open replacement file: $!";


my @prefixes;
# get all prefixs into an array
while ($_=<PREFIXES>) { 
  chomp; # strip eol
  push @prefixes, $_;
}
@prefixes=sort { length($b) <=> length($a) } @prefixes;

my @suffixes;
# get all suffixes into an array
while ($_=<SUFFIXES>) { 
  chomp; # strip eol
  push @suffixes, $_;
}
@suffixes=sort { length($b) <=> length($a) } @suffixes;


my @words;
# get all words into an array
while ($_=<WORDS>) { 
  chomp; # strip eol
  push @words, $_;
}

for (@words) { s/ /  /g;}
for (@words) { $_ = " ". $_. " ";}

# sort by length (makes sure smaller words don't trump bigger ones); ie, "then" vs "the"
@words=sort { length($b) <=> length($a) } @words;
# slurp text file into one variable.
undef $RS;
my $text = <REPLACE>;


# now for each prefix, do a global search-and-replace;
foreach my $prefix (@prefixes) {
     $text =~ s/ $prefix([^\ ])/ $1/sg;
}

# now for each suffix, do a global search-and-replace;
foreach my $suffix (@suffixes) {
     $text =~ s/([^\ ])$suffix /$1 /sg;
}

# now for each word, do a global search-and-replace;
foreach my $word (@words) {
     $text =~ s/$word//sg;
}

# output "fixed" text
print $text;
