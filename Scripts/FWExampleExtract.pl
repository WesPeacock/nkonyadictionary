#!/usr/bin/perl
# perl ./FWExampleExtract.pl
#reads a Fieldworks database. For each example:
#    finds the GUID & Text of the the example
#    Finds the GUID and Form of the LexEntry that owns (or owns the owner) of that example 
use 5.016;
use strict;
use warnings;
use utf8;

use open qw/:std :utf8/;
use XML::LibXML;
use Config::Tiny;

 # ; FWExamples.ini file looks like:
 # [FWExampleExtract]
 # Examplews=nko
 # infilename=Nkonya.fwdata
 # [FWExampleEdit]
 # Examplews=nko
 # infilename=Nkonya.fwdata
 # outfilename=Nkonya.1.fwdata
 # patchfilename=Nkonyafwdata.patch

 my $configfile = 'FWExamples.ini';

say STDERR "read config from:$configfile";
# Windows CRLF nonsense
if ( $^O =~ /linux/)  {
	`dos2unix < $configfile  >/tmp/$configfile ` ;
	$configfile = '/tmp/'.$configfile;
	}
my $config = Config::Tiny->read($configfile);
#ToDo: get the pathname of the INI file from $0 so that the two go together
die "Couldn't find the INI file\nQuitting" if !$config;

my $infilename = $config->{FWExampleExtract}->{infilename};
# ToDo? check that parameters exist

my $lockfile = $infilename . '.lock' ;
die "A lockfile exists: $lockfile\
Don't run $0 when FW is running.\
Run it on a copy of the project, not the original!\
I'm quitting" if -f $lockfile ;

my $languageEncoding =  $config->{FWExampleExtract}->{Examplews};
my $ExampleTextXpath = q#./Example/AStr[@ws="# . $languageEncoding . q#"]#;
say STDERR "ExampleTextXpath:$ExampleTextXpath";
say STDERR "Reading fwdata file: $infilename";
say '<?xml version="1.0" encoding="utf-8"?><LexExamplePatchSet>';
my $fwdatatree = XML::LibXML->load_xml(location => $infilename);

#ToDo? -- if the script were used over and over:
#  build a hash of all rt's indexed by guid 
# But:
# "Premature optimization is the root of all evil."
#       - Sir Tony Hoare (popularized by Donald Knuth)

my $reccount = 0;
foreach my $seExamplert ($fwdatatree->findnodes(q#//rt[@class='LexExampleSentence']#)) {
	# say "Example:", $seExamplert;

	my $exampleguid = $seExamplert->getAttribute('guid');
	my $exampletext = "";
	if ($seExamplert->findnodes($ExampleTextXpath)) {
		$exampletext =($seExamplert->findnodes($ExampleTextXpath))[0]->toString;
		$exampletext =~ s/\n//g;
		#say "ExampleAStr:", $exampletext;
		#say "Examplert:", $seExamplert;
		}

	my ($seOwnerrt) = traverseuptoclass($seExamplert, 'LexEntry');
	my ($lexentform, $lexentguid)=lexentFormAndGuid($seOwnerrt) ;

	say  "<LexExamplePatch exampleguid=\"$exampleguid\"><LexEntText>$lexentform</LexEntText><ExampleText>$exampletext</ExampleText></LexExamplePatch>" ;

	$reccount++;
	#if ($reccount >= 5) {last};
}

say '</LexExamplePatchSet>';

# Subroutines
sub rtheader { # dump the <rt> part of the record
my ($node) = @_;
return  ( split /\n/, $node )[0];
}

sub traverseuptoclass { 
	# starting at $rt
	#    go up the ownerguid links until you reach an
	#         rt @class == $rtclass
	#    or 
	#         no more ownerguid links
	# return the rt you found.
my ($rt, $rtclass) = @_;
	while ($rt->getAttribute('class') ne $rtclass) {
#		say ' At ', rtheader($rt);
		if ( !$rt->hasAttribute('ownerguid') ) {last} ;
		# find node whose @guid = $rt's @ownerguid
		($rt) = $fwdatatree->findnodes(
			q#//rt[@guid= '#  . 
			$rt->getAttribute('ownerguid') 
			. q#']#
			);
	}
#	say 'Found ', rtheader($rt);
	return $rt;
}
sub lexentFormAndGuid {
my ($lexentrt) = @_;
my ($formguid) = $lexentrt->findvalue('./LexemeForm/objsur/@guid');
my ($formstring) = ($fwdatatree->findnodes(
		q#//rt[@guid='#  . 
		$lexentrt->findvalue('./LexemeForm/objsur/@guid')
		. q#']/Form/AUni[@ws="# . $languageEncoding  . q#"]#
		))[0]->toString;

my $guid = $lexentrt->getAttribute('guid');
return ($formstring, $guid);
}
