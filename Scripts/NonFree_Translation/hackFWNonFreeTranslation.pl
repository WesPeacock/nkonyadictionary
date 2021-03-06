#!/usr/bin/perl
# perl ./hackFWNonFreeTranslation.pl
use 5.016;
use strict;
use warnings;
use utf8;

use open qw/:std :utf8/;
use XML::LibXML;

# Different modules and calls for GUIDs under Windows and Linux.
use if $^O eq q(MSWin32), q(Win32);
use if $^O ne q(MSWin32), q(Data::GUID);
my $uidcall =  $^O eq q(MSWin32) ? q[lc Win32::GuidGen() =~ s/\{|\}//gr;] : q[lc Data::GUID->new->as_string] ;
# Win32::GuidGen() is like "{12345678-90AB-CDEF-1234-567890ABCDEF}", i.e., with uc with curly brackets
# Data::GUID->new->as_string is like "12345678-90AB-CDEF-1234-567890ABCDEF", i.e. uc
# FLEx needs like  "12345678-90ab-cdef-1234-567890abcdef"


use Config::Tiny;
# ; INI file section looks like:
# [hackFWNonFreeTranslation]
# FreeTranslationType=Free translation
# NonFreeTranslationStarttag=xl:
# NonFreeTranslationEndtag=/xl:
# NonFreeTranslationType=Literal translation
# infilename=Nktest.fwdata
# outfilename=Nktest.new.fwdata

my $configfile = 'PromoteSubentries.ini';
my $config = Config::Tiny->read($configfile, 'crlf');

#ToDo: get the pathname of the INI file from $0 so that the two go together
die "Couldn't find the INI file\nQuitting" if !$config;
my $starttag = $config->{hackFWNonFreeTranslation}->{NonFreeTranslationStarttag};
say "starttag: $starttag";

my $endtag = $config->{hackFWNonFreeTranslation}->{NonFreeTranslationEndtag};
say "endtag: $endtag";

my $transtype = $config->{hackFWNonFreeTranslation}->{NonFreeTranslationType};
my $freetype = $config->{hackFWNonFreeTranslation}->{FreeTranslationType};
my $infilename = $config->{hackFWNonFreeTranslation}->{infilename};
my $outfilename = $config->{hackFWNonFreeTranslation}->{outfilename};

my $lockfile = $infilename . '.lock' ;
die "A lockfile exists: $lockfile\
Don't run $0 when FLex is running.\
Run it on a copy of the project, not the original!\
I'm quitting" if -f $lockfile ;

my $nktree = XML::LibXML->load_xml(location => $infilename);

my ($freetypert) = $nktree->findnodes(q#//*[contains(., '# . $freetype . q#')]/ancestor::rt#);
if (!$freetypert) {
	say "The translation type, '", $freetype, "' wasn't found";
	exit;
	}
if ($freetypert->getAttribute('class') ne "CmPossibility") {
	say "I found the string: '", $freetype, "' but it isn't in a Translation Type list";
	exit;
	}

my $freetypeguid = $freetypert->getAttribute('guid');
say "Free translation guid is $freetypeguid" ;
#Todo instead of exiting if the first is not a  CmPossibility, keep looking and only exit if you don't find any; same below.

my ($transtypert) = $nktree->findnodes(q#//*[contains(., '# . $transtype . q#')]/ancestor::rt#);
if (!$transtypert) {
	say "The translation type, '", $transtype, "' wasn't found";
	exit;
	}
if ($transtypert->getAttribute('class') ne "CmPossibility") {
	say "I found the string: '", $transtype, "' but it isn't in a Translation Type list";
	exit;
	}
my $transtypeguid = $transtypert->getAttribute('guid');
say "$transtype guid is $transtypeguid" ;

# Todo: log output of each modified entry
foreach my $transToModifyrt ($nktree->findnodes(q#//*[contains(., '# . $starttag . q#')]/ancestor::rt#)) {
	my ($run) = $transToModifyrt->findnodes('./Translation/AStr/Run/text()') ;
	my $runstring = $run->toString;
	$runstring =~ /$starttag(.*?)$endtag/;
        my $nftext = $1;
	# say "nftext: $nftext";
	# remove the nonFree text from the <Run>...</Run> whether it's first or second
	$runstring =~ s/$starttag(.*?)$endtag\;\ //;
	$runstring =~ s/\;\ $starttag(.*?)$endtag//;
	$run->setData($runstring);
	
	my $rtstring = $transToModifyrt->toString;
	$rtstring =~ s/$freetypeguid/$transtypeguid/;
	my $rtguid = $transToModifyrt->findvalue('./@guid');
	my $newguid = eval $uidcall;
	# say "rtguid $rtguid";
	# say "newguid $newguid";
	$rtstring =~ s/$rtguid/$newguid/;
	$rtstring =~ s#\>(.*?)\</Run>#\>$nftext\</Run>#;
	# say $rtstring;
	my $newnode = XML::LibXML->load_xml(string => $rtstring)->findnodes('//*')->[0];
	$transToModifyrt->parentNode->insertAfter($newnode, $transToModifyrt);
	# say $transToModifyrt;
	
	my ($ownerpointer) = $nktree->findnodes(q#//Translations/objsur[@guid='# . $rtguid . q#']#); 
	my $newownerpointerstring = $ownerpointer->toString =~ s/$rtguid/$newguid/r;
	$newnode = XML::LibXML->load_xml(string => $newownerpointerstring)->findnodes('//*')->[0];
	$ownerpointer->parentNode->insertAfter($newnode, $ownerpointer);
	# say $ownerpointer->parentNode;

	}
	
my $xmlstring = $nktree->toString;
# Some miscellaneous Tidying differences
$xmlstring =~ s#><#>\n<#g;
$xmlstring =~ s#(<Run.*?)/\>#$1\>\</Run\>#g;
$xmlstring =~ s#/># />#g;
open my $out_fh, '>:raw', $outfilename;
print {$out_fh} $xmlstring;

exit;
