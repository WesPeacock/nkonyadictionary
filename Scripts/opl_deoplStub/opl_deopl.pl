#!/usr/bin/perl
my $USAGE = "Usage: $0 [--inifile inifile.ini] [--section section] [--debug] [file.sfm]";
=pod	
This script is a stub that provides the code for opl'ing and de_opl'ing an input file
It also includes code to:
	- use an ini file
	- process command line options including debugging
	- 
The ini file should have sections with syntax like this:
[section]
Param1=Value1
Param2=Value2

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
#	'inifile:s'   => \(my $inifilename = "$scriptname.ini"), # ini filename
#	'section:s'   => \(my $inisection = "section"), # section of ini file to use
# additional options go here.
# 'sampleoption:s' => \(my $sampleoption = "optiondefault"),
	'debug'       => \my $debug,
	) or die $USAGE;

# check your options and assign their information to variables here

# if you need  a config file uncomment the following and modify it for the initialization you need.
# if you have set the $inifilename & $inisection in the options, you only need to set the parameter variables according to the parameter names
=pod
use Config::Tiny;
my $config = Config::Tiny->read($inifilename, 'crlf');
die "Quitting: couldn't find the INI file $inifilename\n$USAGE\n" if !$config;
my $param1 = $config->{"$inisection"}->{Param1};
say STDERR "Param1:$param1" if $debug;
my $param2 = $config->{"$inisection"}->{Param2};
say STDERR "Param2:$param2" if $debug;
=cut

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

#de_opl this line
	for ($oplline) {
		s/#/\n/g;
		s/\_\_hash\_\_/#/g;
		print;
		say STDERR "oplline:", Dumper($oplline) if $debug;
		}
	}

