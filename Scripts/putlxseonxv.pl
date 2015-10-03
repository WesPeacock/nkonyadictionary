#!/usr/bin/perl
# usage ./putlxseonxv.pl <lxsexv |sort >kwik
# see the documentation in findwords.pl for how to use this script

use strict;
use warnings;
use English;

my $lxse="";
my $lx="";
while (<>) {
	chomp;
	if (/\\lx /) { s/ //g; $lxse=$_;$lx=$lxse}
	if (/\\se /) { s/ //g;  $lxse=$_;}
	if (/\\sn /) { s/ //g;  $lxse=$lx;}
	if (/\\xv /) {
		s/ /  /g;
		print "$_  :$lxse\n";
		}
	}
