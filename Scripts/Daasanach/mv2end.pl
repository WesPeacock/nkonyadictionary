#!/usr/bin/perl
my $USAGE = "Usage: $0 [--inifile inifile.ini] [--section section] [--debug] [file.sfm]";

=pod
This script reads a list of SFM field markers and moves those fields to the end of the record.
The ini file should have a section with syntax like this:
[mv2end]
MoveSFMs=J1,J2,ind,dt

The markers are moved to the end of the record, in the order that they are in the list. If you make the last marker the date marker(s) they will appear last in the list.

This script is built from a stub that provides the code for opl'ing and de_opl'ing an input file
It also includes code to:
	- use an ini file
	- process command line options including debugging
=cut

use 5.020;
use utf8;
use open qw/:std :utf8/;

use strict;
use warnings;
use English;
use Data::Dumper qw(Dumper);


use File::Basename;
my $scriptname = fileparse($0, qr/\.[^.]*/); # script name without the .pl (or .exe)

use Getopt::Long;
GetOptions (
	'inifile:s'   => \(my $inifilename = "$scriptname.ini"), # ini filename
	'section:s'   => \(my $inisection = "mv2end"), # section of ini file to use
# additional options go here.
# 'sampleoption:s' => \(my $sampleoption = "optiondefault"),
	'debug'       => \my $debug,
	) or die $USAGE;

# check your options and assign their information to variables here

# if you need  a config file uncomment the following and modify it for the initialization you need.
# if you have set the $inifilename & $inisection in the options, you only need to set the parameter variables according to the parameter names

use Config::Tiny;
my $config = Config::Tiny->read($inifilename, 'crlf');
die "Quitting: couldn't find the INI file $inifilename\n$USAGE\n" if !$config;
my @movesfms = split(",", $config->{"$inisection"}->{MoveSFMs});
if ($debug) {
	foreach my $movesfm (@movesfms) {
		say STDERR "MoveSFM:$movesfm"
		}
	}
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
# insert code here to perform on each opl'ed line.	
foreach my $movesfm (@movesfms) {
	$oplline =~ s/(\\$movesfm\ .*?)(\\.*)/$2$1/; 
	}

#de_opl this line
	for ($oplline) {
		s/#/\n/g;
		s/\_\_hash\_\_/#/g;
		print;
		say STDERR "oplline:", Dumper($oplline) if $debug;
		}
	}

