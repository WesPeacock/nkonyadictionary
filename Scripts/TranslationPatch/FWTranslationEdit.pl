#!/usr/bin/perl
my $USAGE = "Usage: $0 [--inifile inifile.ini] [--section section] [--debug] [file.sfm]";
# Takes an Example Translations patch file and applies it to an FWdata file
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
	'inifile:s'   => \(my $inifilename = "FWTranslations.ini"), # ini filename
	'section:s'   => \(my $inisection = "FWTranslationEdit"), # section of ini file to use
	'debug'       => \my $debug,
	) or die $USAGE;

use Config::Tiny;
 # ; FWTranslations.ini file looks like:
 # [FWTranslationExtract]
 # Translationws=en
 # Vernacularws=nko
 # infilename=Nkonya.fwdata
 # patchtag=ltp
 # transtexttag=tt
 # transguidtag=tguid
 # lexenttag=let
 #
 # [FWTranslationEdit]
 # Translationws=nko
 # infilename=Nkonya.fwdata
 # outfilename=Nkonya.1.fwdata
 # patchfilename=Nkonyafwdata.patch
 # patchtag=ltp
 # transtexttag=tt
 # transguid=tguid
 # lexenttag=let

say STDERR "read config from:$inifilename";
my $config = Config::Tiny->read($inifilename, 'crlf');
die "Couldn't find the INI file\nQuitting" if !$config;

my $TranslationlanguageEncoding =  $config->{"$inisection"}->{Translationws};
my $TranslationTextXpath = q#./Translation/AStr[@ws="# . $TranslationlanguageEncoding . q#"]#;
say STDERR "TranslationTextXpath:$TranslationTextXpath";

my $infilename = $config->{"$inisection"}->{infilename};
# ToDo? check that parameters exist

my $lockfile = $infilename . '.lock' ;
die "A lockfile exists: $lockfile\
Don't run $0 when FW is running.\
Run it on a copy of the project, not the original!\
I'm quitting" if -f $lockfile ;

my $outfilename = $config->{"$inisection"}->{outfilename};
my $patchfilename = $config->{"$inisection"}->{patchfilename};

say STDERR "Processing fwdata file: $infilename";
my $fwdatatree = XML::LibXML->load_xml(location => $infilename);
#  build a hash of all CmTranslation rt's indexed by guid
my %rthash;
foreach my $rt ($fwdatatree->findnodes(q#//rt[@class='CmTranslation']#)) {
	my $guid = $rt->getAttribute('guid');
	$rthash{$guid} = $rt;
	}

say STDERR "Applying patch file: $patchfilename";
my $patchtree = XML::LibXML->load_xml(location => $patchfilename);
my $patchtag =  $config->{"$inisection"}->{patchtag};
my $transtexttag =  $config->{"$inisection"}->{transtexttag};
my $transguidtag =  $config->{"$inisection"}->{transguidtag};
my $lexenttag =  $config->{"$inisection"}->{lexenttag};

foreach my $patch ($patchtree->findnodes(q#//# . $patchtag)) {
	say STDERR "patch:$patch" if $debug;
	my ($transguid) = $patch->findnodes(q#./# . $transguidtag . q#/text()#);
	# say STDERR  "transguid:$transguid" if $debug;
	my ($PatchTextNode) = $patch->findnodes(q#./# . $transtexttag . q#/AStr#);
	my ($PatchTextAsString) = $PatchTextNode->toString;
	# say STDERR  "PatchTextAsString:$PatchTextAsString" if $debug;
	my $newnode = XML::LibXML->load_xml(string => $PatchTextAsString);
	if (!exists $rthash{$transguid}) {
		say STDERR "Translation guid not in fwdata:$transguid ";
		next;
		}
	my $fwdataTranslation = $rthash{$transguid};
	say STDERR  "fwdataTranslation Before:", $fwdataTranslation->toString if $debug;
	my ($fwdataTranslationText) = $fwdataTranslation->findnodes($TranslationTextXpath);
	$fwdataTranslationText->parentNode()->insertAfter($PatchTextNode, $fwdataTranslationText);
	$fwdataTranslationText->unbindNode();
	say STDERR  "fwdataTranslation After:", $fwdataTranslation->toString if $debug;
}

my $xmlstring = $fwdatatree->toString;
# Some miscellaneous Tidying differences
$xmlstring =~ s#><#>\n<#g;
$xmlstring =~ s#(<Run.*?)/\>#$1\>\</Run\>#g;
$xmlstring =~ s#/># />#g;
say "Finished processing, writing modified  $outfilename" ;
open my $out_fh, '>:raw', $outfilename;
print {$out_fh} $xmlstring;
