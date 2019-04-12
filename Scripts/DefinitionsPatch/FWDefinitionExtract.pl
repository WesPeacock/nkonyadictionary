#!/usr/bin/perl
my $USAGE = "Usage: $0 [--inifile inifile.ini] [--section section] [--debug] [file.sfm]";
# perl ./FWDefinitionExtract.pl
#reads a Fieldworks database. For each Definition:
#    finds the GUID & Text of the Definition
#    Finds the GUID and Form of the LexEntry that owns (or owns the owner) of that Definition
#    Outputs that info as XML info to be processed as a patch file

use 5.020;
use strict;
use warnings;
use English;
use Data::Dumper qw(Dumper);
use utf8;
use open qw/:std :utf8/;
use File::Basename;
my $scriptname = fileparse($0, qr/\.[^.]*/); # script name without the .pl

use XML::LibXML;

use Getopt::Long;
GetOptions (
	'inifile:s'   => \(my $inifilename = "FWDefinitions.ini"), # ini filename
	'section:s'   => \(my $inisection = "FWDefinitionExtract"), # section of ini file to use
	'debug'       => \my $debug,
	) or die $USAGE;

use Config::Tiny;
 # ; FWDefinitions.ini file looks like:
 # [FWDefinitionExtract]
 # Definitionws=en
 # Vernacularws=nko
 # infilename=Nkonya.fwdata
 # patchtag=ltp
 # deftexttag=tt
 # lexsenseguidtag=lsguid
 # lexenttag=let
 #
 # [FWDefinitionEdit]
 # Definitionws=nko
 # infilename=Nkonya.fwdata
 # outfilename=Nkonya.1.fwdata
 # patchfilename=Nkonyafwdata.patch
 # patchtag=ltp
 # deftexttag=tt
 # lexsenseguidtag=lsguid
 # lexenttag=let

say STDERR "read config from:$inifilename";
my $config = Config::Tiny->read($inifilename, 'crlf');
die "Couldn't find the INI file\nQuitting" if !$config;

my $infilename = $config->{"$inisection"}->{infilename};
# ToDo? check that parameters exist

my $lockfile = $infilename . '.lock' ;
die "A lockfile exists: $lockfile\
Don't run $0 when FW is running.\
Run it on a copy of the project, not the original!\
I'm quitting" if -f $lockfile ;

my $DefinitionlanguageEncoding =  $config->{"$inisection"}->{Definitionws};
my $DefinitionTextXpath = q#./Definition/AStr[@ws="# . $DefinitionlanguageEncoding . q#"]#;
say STDERR "DefinitionTextXpath:$DefinitionTextXpath";

my $VernacularlanguageEncoding =  $config->{"$inisection"}->{Vernacularws};
my $FormTextXpath = q#./Form/AUni[@ws="# . $VernacularlanguageEncoding . q#"]#;
say STDERR "FormTextXpath:$FormTextXpath";

say STDERR "Reading fwdata file: $infilename";
say '<?xml version="1.0" encoding="utf-8"?><LexDefinitionPatchSet>';
my $fwdatatree = XML::LibXML->load_xml(location => $infilename);

my $patchtag =  $config->{"$inisection"}->{patchtag};
my $deftexttag =  $config->{"$inisection"}->{deftexttag};
my $lexsenseguidtag =  $config->{"$inisection"}->{lexsenseguidtag};
my $lexenttag =  $config->{"$inisection"}->{lexenttag};

my %varefhash;
# The index is main entry guid, Each item is an array of variant references that point to the main entry.
my %rthash;
foreach my $rt ($fwdatatree->findnodes(q#//rt#)) {
	my $guid = $rt->getAttribute('guid');
	$rthash{$guid} = $rt;
	}
=pod
my $size = keys %varefhash;
say STDERR "$size entries with variants";

my ($lexentguid) ="dcc581be-5494-4856-b18f-8a280d32e093"; # anyɔ "two" test
my $VarTexts ="";
foreach my $VarRefrt (@{$varefhash{$lexentguid} }) {
#	my $x = ($VarRefrt->findnodes('.'))[0]->toString;
#	say $x;
	my ($Varrt) = traverseuptoclass($VarRefrt, 'LexEntry');
	my ($varform, $varguid)=lexentFormAndGuid($Varrt) ;
	$VarTexts .= "<LexEntVarText>$varform</LexEntVarText>";
	}
say $VarTexts;


die;
=cut
my $reccount = 0;
foreach my $seLexSensert ($fwdatatree->findnodes(q#//rt[@class='LexSense']#)) {
	 # say STDERR "LexSense:", $seLexSensert if $debug;
	my $LexSenseguid = $seLexSensert->getAttribute('guid');
	my $Definitiontext = "";
	if ($seLexSensert->findnodes($DefinitionTextXpath)) {
		$Definitiontext =($seLexSensert->findnodes($DefinitionTextXpath))[0]->toString;
		$Definitiontext =~ s/\n//g;
=pod
		 say STDERR "DefinitionAStr:", $Definitiontext if $debug;
		 say STDERR "LexSensert:", $seLexSensert if $debug;
		 say ""; say "";
=cut
		 }

	my ($seOwnerrt) = traverseuptoclass($seLexSensert, 'LexEntry');
#	 say STDERR "seOwnerrt", $seOwnerrt if $debug;

	my ($lexentform, $lexentguid)=lexentFormAndGuid($seOwnerrt) ;
#	 say STDERR "lexentform", $lexentform if $debug;
#	 say STDERR "lexentguid", $lexentguid if $debug;

	say  "<$patchtag>" .
			"<$deftexttag>$Definitiontext</$deftexttag>" .
			"<$lexenttag>$lexentform</$lexenttag>" .
			"<$lexsenseguidtag>$LexSenseguid</$lexsenseguidtag>" .
			"</$patchtag>" ;

	$reccount++;
	#if ($reccount >= 100) {last};
}

say '</LexDefinitionPatchSet>';

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
		$rt = $rthash{$rt->getAttribute('ownerguid')};
	}
#	say 'Found ', rtheader($rt);
	return $rt;
}
sub lexentFormAndGuid {
my ($lexentrt) = @_;
#say STDERR "lexentrt:", $lexentrt if $debug;

my ($formguid) = $lexentrt->findvalue('./LexemeForm/objsur/@guid');
#say STDERR "formguid:", $formguid if $debug;

#say STDERR "hash of formguid:", $rthash{$formguid} if $debug;
my $formstring =($rthash{$formguid}->findnodes($FormTextXpath))[0]->toString;
my $guid = $lexentrt->getAttribute('guid');
return ($formstring, $guid);
}
