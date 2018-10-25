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
my $config = Config::Tiny->read($configfile, 'crlf');
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
#my $FormTextXpath = q#./Form/AUni[@ws="# . $languageEncoding . q#"]/text()#;
my $FormTextXpath = q#./Form/AUni[@ws="# . $languageEncoding . q#"]#;
say STDERR "FormTextXpath:$FormTextXpath";

say STDERR "Reading fwdata file: $infilename";
say '<?xml version="1.0" encoding="utf-8"?><LexExamplePatchSet>';
my $fwdatatree = XML::LibXML->load_xml(location => $infilename);

my %varefhash;
# The index is main entry guid, Each item is an array of variant references that point to the main entry.
my %rthash;
foreach my $rt ($fwdatatree->findnodes(q#//rt#)) {
	my $guid = $rt->getAttribute('guid');
	$rthash{$guid} = $rt;

	if (($rt->getAttribute('class') eq "LexEntryRef") 
	   && ( ($rt->findnodes('./RefType/@val')) eq "0") )  { # variants have <RefType val="0" />
			(my $mainguid) = $rt->findvalue('./ComponentLexemes/objsur/@guid');
			push(@{ $varefhash{$mainguid} }, $rt->getAttribute('guid')); # add this guid for the target Lexentry 
			}
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
foreach my $seExamplert ($fwdatatree->findnodes(q#//rt[@class='LexExampleSentence']#)) {
	# say "Example:", $seExamplert;
	my $exampleguid = $seExamplert->getAttribute('guid');
	my $exampletext = "";
	if ($seExamplert->findnodes($ExampleTextXpath)) {
		$exampletext =($seExamplert->findnodes($ExampleTextXpath))[0]->toString;
		$exampletext =~ s/\n//g;
=pod
		 say "ExampleAStr:", $exampletext;
		 say "Examplert:", $seExamplert;
		 say ""; say "";
=cut
		 }

	my ($seOwnerrt) = traverseuptoclass($seExamplert, 'LexEntry');

	my ($lexentform, $lexentguid)=lexentFormAndGuid($seOwnerrt) ;
	
	my $VarTexts ="";
	foreach my $VarRefguid (@{$varefhash{$lexentguid} }) {
		my ($VarEntrt) = traverseuptoclass( $rthash{$VarRefguid}, 'LexEntry');
		my ($varform, $varguid)=lexentFormAndGuid($VarEntrt) ;
		$VarTexts .= "<LexEntVarText>$varform</LexEntVarText>";
		}
	say  "<LexExamplePatch exampleguid=\"$exampleguid\"><LexEntText>$lexentform</LexEntText>$VarTexts<ExampleText>$exampletext</ExampleText></LexExamplePatch>" ;

	$reccount++;
	#if ($reccount >= 100) {last};
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
		$rt = $rthash{$rt->getAttribute('ownerguid')};
	}
#	say 'Found ', rtheader($rt);
	return $rt;
}
sub lexentFormAndGuid {
my ($lexentrt) = @_;
my ($formguid) = $lexentrt->findvalue('./LexemeForm/objsur/@guid');
my $formstring =($rthash{$formguid}->findnodes($FormTextXpath))[0]->toString;
my $guid = $lexentrt->getAttribute('guid');
return ($formstring, $guid);
}
