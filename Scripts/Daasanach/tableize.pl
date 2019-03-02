#!/usr/bin/perl
my $USAGE = "Usage: $0  [--debug] [--starttab=sfm] [--endtab=sfm] [file.sfm]";
=pod
this script converts all  \'s in  all \SFMs between a table start marker (no \, default pd) and a table finish marker (no \, default npd) 
it changes them to @'s i.e.: s/\\/@/g
For Example, table start marker is \pd and table end marker is \npd with a table like:
		\pd  
		SG     ;          PL
		\Cp             ; đuufáa
		\P1 đuule    ; đufe2
		\IN đuulminy ; đufuminy
		\npd
It would become:
		\pd  
		SG     ;          PL
		@Cp             ; đuufáa
		@P1 đuule    ; đufe2
		@IN đuulminy ; đufuminy
		\npd
It opl's the file then uses a double level regex substitution to make the change.
=cut
use 5.020;
use utf8;
use open qw/:std :utf8/;

use strict;
use warnings;
use English;
use Data::Dumper qw(Dumper);

use File::Basename;
my $scriptname = fileparse($0, qr/\.[^.]*/); # script name without the .pl
use Getopt::Long;
GetOptions (
	'starttab:s'  => \(my $starttab = "pd"),
	'endtab:s'    => \(my $endtab = "npd"),
	'debug'       => \my $debug,
	) or die $USAGE;

my $startregex = qr/\\$starttab[\ |#]/;
my $endregex = qr/\\$endtab[\ |#]/;
say STDERR "startregex:$startregex" if $debug;
say STDERR "endregex:$endregex" if $debug;

# generate array of the input file with one SFM record per line (opl)
my @opledfile_in;
my $line = ""; # accumulated SFM record
while (<>) {
	s/\R//g; # chomp that doesn't care about Linux & Windows
	#perhaps s/\R*$//; if we want to leave in \r characters in the middle of a line
	s/#/\_\_hash\_\_/g;
	$_ .= "#";
	if (/^\\lx /) {
		$line =~ s/#$/\n/;
		push @opledfile_in, $line;
		$line = $_;
		}
	else { $line .= $_ }
	}
push @opledfile_in, $line;

for my $oplline (@opledfile_in) {

	if ($oplline =~ /#$startregex.*?$endregex/) {
		#  This funky substitution between two regex's is courtesy of:
		# https://stackoverflow.com/questions/54935455/perl-substitution-between-a-start-regex-and-an-end-regex
		$oplline =~ s/$startregex\K(.*?)(?=$endregex)/$1 =~ s{#\\}{#@}gr /eg;
		# inner substitution regex has initial # so that \'s not in an SFM doesn't get changed
		say STDERR $oplline;
		}

#de_opl this line
	for ($oplline) {
		s/#/\n/g;
		s/\_\_hash\_\_/#/g;
		print;
		say STDERR "oplline:", Dumper($oplline) if $debug;
		}
	}

