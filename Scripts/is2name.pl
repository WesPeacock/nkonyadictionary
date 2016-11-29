#!/usr/bin/perl
# perl ./Scripts/is2name.pl
# This script does a lookup on a Semantic Domain XML file to give names to the \is codes
# It runs on a copy of the SFM file in which \n is replaced by '#' except before \lx
#  ToDo: run on SFM file inserting fields (but what?) after the \is code
# ToDo?: add this to the Subentry Promotion Suite with an ini file

use 5.016;
use strict;
use warnings;
use utf8;
use XML::LibXML;
use File::HomeDir;
use open qw/:std :utf8/;

my $isfilename = File::HomeDir->my_home . '/Documents/work/LexicalTraining/SemanticDomainList.list';
my $istree = XML::LibXML->load_xml(location => $isfilename);
my %namehash;
my $name;
while (<>) {
	chomp;
	say;
	my @x= (/(?<=\\is\ ).*?(?=\#)/g) ;
	foreach my $x (@x) {
		 if (exists $namehash{$x}) {
			$name=$namehash{$x};
			}
		else {
			 ($name) = $istree->findnodes(q#//AUni[text()="# . $x . q#"]/../../Name/AUni/text()#);
			$namehash{$x}=$name;
			}
		say " $x:$name";
		}
	}
=cut
	