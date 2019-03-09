#!/usr/bin/perl
# perl ./FWExampleEdit.pl
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
my $config = Config::Tiny->read($configfile, 'crlf');
#ToDo: get the pathname of the INI file from $0 so that the two go together
die "Couldn't find the INI file\nQuitting" if !$config;

my $ExampleTextXpath = q#./Example/AStr[@ws="#. $config->{FWExampleEdit}->{Examplews} . q#"]#;
say "ExampleTextXpath:$ExampleTextXpath";

my $infilename = $config->{FWExampleEdit}->{infilename};
my $outfilename = $config->{FWExampleEdit}->{outfilename};
my $patchfilename = $config->{FWExampleEdit}->{patchfilename};

my $lockfile = $infilename . '.lock' ;
die "A lockfile exists: $lockfile\
Don't run $0 when FW is running.\
Run it on a copy of the project, not the original!\
I'm quitting" if -f $lockfile ;

say STDERR "Processing fwdata file: $infilename";
my $fwdatatree = XML::LibXML->load_xml(location => $infilename);

say STDERR "Applying patch file: $patchfilename";
my $patchtree = XML::LibXML->load_xml(location => $patchfilename);
#ToDo? -- if the script were used over and over:
#  build a hash of all rt's indexed by guid 
# But:
# "Premature optimization is the root of all evil."
#       - Sir Tony Hoare (popularized by Donald Knuth)

foreach my $patch ($patchtree->findnodes(q#//LexExamplePatch#)) {
	# say "patch", $patch;
	my $ExampleGuid = $patch->getAttribute('exampleguid');
	#say "ExampleGuid $ExampleGuid";
	my ($PatchTextNode) = $patch->findnodes('./ExampleText/AStr');
	my ($PatchTextAsString) = $PatchTextNode->toString;
	my $newnode = XML::LibXML->load_xml(string => $PatchTextAsString);
	my ($fwdataExample) = $fwdatatree->findnodes(q#//rt[@guid='# . $ExampleGuid . q#']#);
	#say "fwdataExample Before", $fwdataExample->toString;
	my ($fwdataExampleText) = $fwdataExample->findnodes($ExampleTextXpath);
	#say "fwdata Text", $fwdataExampleText->toString;
	$fwdataExampleText->parentNode()->insertAfter($PatchTextNode, $fwdataExampleText);
	$fwdataExampleText->unbindNode();
	#say "fwdataExample After", $fwdataExample->toString;
}


my $xmlstring = $fwdatatree->toString;
# Some miscellaneous Tidying differences
$xmlstring =~ s#><#>\n<#g;
$xmlstring =~ s#(<Run.*?)/\>#$1\>\</Run\>#g;
$xmlstring =~ s#/># />#g;
say "Finished processing, writing modified  $outfilename" ;
open my $out_fh, '>:raw', $outfilename;
print {$out_fh} $xmlstring;



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
my ($formstring) = $fwdatatree->findnodes(
		q#//rt[@guid= '#  . 
		$lexentrt->findvalue('./LexemeForm/objsur/@guid')
		. q#']/Form/AUni/text()#
		);
# If there's more than one encoding, you only get the first

my $guid = $lexentrt->getAttribute('guid');
return ($formstring, $guid);
}
