#!/usr/bin/perl
# perl ./FWReverseMerge.pl
# reads a Fieldworks database.
# Detects multiple ReversalIndexEntry's with identical ReversalForm
#	guids of 2nd & subsequent are stored as duplicates with corresponding original
# changes all LexEntry's that point to duplicates to the originals
use 5.016;
use strict;
use warnings;
use utf8;

use open qw/:std :utf8/;
use XML::LibXML;
use Config::Tiny;
use Data::Dumper qw(Dumper);

my $now_string = localtime; say STDERR $now_string;
 my $configfile = 'FWReverseMerge.ini';
 # ; FWReverseMerge.ini file looks like:
 # [FWReverseMerge]
 # infilename=Dii.fwdata
 # outfilename=Dii.1.fwdata
 # logfilename=Dii.ReverseMerge.log

say STDERR "read config from:$configfile";

my $config = Config::Tiny->read($configfile, 'crlf');
#ToDo: get the pathname of the INI file from $0 so that the two go together
die "Couldn't find the INI file\nQuitting" if !$config;

my $infilename = $config->{FWReverseMerge}->{infilename};
my $outfilename = $config->{FWReverseMerge}->{outfilename};
# ToDo? check that parameters exist

my $lockfile = $infilename . '.lock' ;
die "A lockfile exists: $lockfile\
Don't run $0 when FW is running.\
Run it on a copy of the project, not the original!\
I'm quitting" if -f $lockfile ;

open(my $loghandle, '>', $config->{FWReverseMerge}->{logfilename})
	or die "Couldn't open logfile";

say STDERR "Reading fwdata file: $infilename";
my $fwdatatree = XML::LibXML->load_xml(location => $infilename);

my $reccnt = 0;
my %revhash;  # Hash with key of the text contains the first guid
my %dupehash; # Hash with key of duplicate guid contains the duplicated text
foreach my $revformnode ($fwdatatree->findnodes(q#//ReversalForm#)) {
	my $revguid = $revformnode->parentNode->getAttribute('guid');
	my $text = ($revformnode->toString);
	$text =~ s/\r*\n//g;
	if (!exists $revhash{$text}) {
		$revhash{$text} = $revguid;
		}
	else {
		$dupehash{$revguid} = $text;
		}

	# $reccnt++; last if $reccnt > 10;
	}

# print Dumper \%dupehash;

my @logarray;
while( my( $dupeguid, $dupetext ) = each %dupehash ) {
	my $firstguid = $revhash{$dupetext};
	push @logarray, qq|Text:$dupetext Substitute $firstguid instead of $dupeguid|;
	foreach my $Revlinknode ($fwdatatree->findnodes(
					q#//ReversalEntries/objsur[@guid='# .
					$dupeguid .
					q#']#)) {
		$Revlinknode->setAttribute(guid => "$firstguid");
		}
	}
foreach my $line (sort @logarray) {say $loghandle $line} ;
my $xmlstring = $fwdatatree->toString;
# Some miscellaneous Tidying differences
$xmlstring =~ s#><#>\n<#g;
$xmlstring =~ s#(<Run.*?)/\>#$1\>\</Run\>#g;
$xmlstring =~ s#/># />#g;
say STDERR "Finished processing, writing modified  $outfilename" ;
open my $out_fh, '>:raw', $outfilename;
print {$out_fh} $xmlstring;
