#!/usr/bin/perl
# perl ./hackFWNonFreeTranslation.pl
use 5.016;
use strict;
use warnings;
use utf8;

use open qw/:std :utf8/;
use XML::LibXML;
use Win32;

use Config::Tiny;
# ; INI file section looks like:
# [hackFWNonFreeTranslation]
# NonFreeTranslationStarttag=xl:
# NonFreeTranslationEndtag=/xl:
# NonFreeTranslationType=Literal translation
# infilename=Nktest.fwdata
# outfilename=Nktest.new.fwdata

# Todo: Look up the NonFreeTranslationRTguid by searching for "Literal translation" and returning the rt's guid
my $config = Config::Tiny->read( 'PromoteSubentries.ini' );
#ToDo: get the pathname of the INI file from $0 so that the two go together
die "Couldn't find the INI file\nQuitting" if !$config;
my $starttag = $config->{hackFWNonFreeTranslation}->{NonFreeTranslationStarttag};
my $endtag = $config->{hackFWNonFreeTranslation}->{NonFreeTranslationEndtag};
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

foreach my $transToModifyrt ($nktree->findnodes(q#//*[contains(., '# . $starttag . q#')]/ancestor::rt#)) {
	my ($run) = $transToModifyrt->findnodes('./Translation/AStr/Run/text()') ;
	my $runstring = $run->toString;
	$runstring =~ /$starttag(.*?)$endtag/;
        my $nftext = $1;
	# say "nftext: $nftext";
	# remove the nonFree text from the <Run>...</Run> whether it's first or second
	$runstring =~ s/$starttag$nftext$endtag\;\ //;
	$runstring =~ s/\;\ $starttag$nftext$endtag//;
	$run->setData($runstring);
	
	my $rtstring = $transToModifyrt->toString;
	$rtstring =~ s/$freetypeguid/$transtypeguid/;
	my $rtguid = $transToModifyrt->findvalue('./@guid');
	my $newguid = lc Win32::GuidGen() =~ s/\{|\}//gr;
	# Win32::GuidGen() is like "{12345678-90AB-CDEF-1234-567890ABCDEF}"
	# say "rtguid $rtguid";
	# say "newguid $newguid";
	$rtstring =~ s/$rtguid/$newguid/;
	$rtstring =~ s#\>$runstring\</Run>#\>$nftext\</Run>#;
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
