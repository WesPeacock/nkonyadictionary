#!/usr/bin/env perl
# perl ./setFWVariantUnderEntry.pl
# this script modifies a Field Works Project. It changes variants
# (plural, spelling, dialectal, singular) so that they are under the entry
# rather than the first sense.
# It does this by checking whether the ComponentLexemes[0] has @ownerguid attributes
# a Sense has an @ownerguid attribute, a LexEntry doesn't
use 5.016;
use strict;
use warnings;
use utf8;

use open qw/:std :utf8/;
use XML::LibXML;
use Config::Tiny;
 # ; setFWVariantUnderEntry.ini file looks like:
 # [setFWVariantUnderEntry]
 # infilename=Nktest.fwdata
 # outfilename=Nktest.new.fwdata
 #  Variantguidlist=3942addb-99fd-43e9-ab7d-99025ceb0d4e,024b62c9-93b3-41a0-ab19-587a0030219a,4343b1ef-b54f-4fa4-9998-271319a6d74c,01d4fbc1-3b0c-4f52-9163-7ab0d4f4711c,0c4663b3-4d9a-47af-b9a1-c8565d8112ed,3bba8239-92eb-4a0d-97e8-d599572931ed,0d6af2de-38bc-420f-9ec1-1cc3168fe1c5,a32f1d1c-4832-46a2-9732-c2276d6547e8,924ef9ce-5a99-4daf-b59d-366b810b65ed,837ebe72-8c1d-4864-95d9-fa313c499d78
# ; Unspecified Variant,Dialectal Variant,Free Variant,Irregularly Inflected Form,Spelling Variant,Contraction,Allophonic Variant,Plural,Singular,Past

my $configfile = 'setFWVariantUnderEntry.ini';
# Windows CRLF nonsense
if ( $^O =~ /linux/)  {
	`dos2unix < $configfile  >/tmp/$configfile ` ;
	$configfile = '/tmp/'.$configfile;
	}
my $config = Config::Tiny->read($configfile);
die "Couldn't find the INI file\nQuitting" if !$config;
my $infilename = $config->{setFWVariantUnderEntry}->{infilename};
my $outfilename = $config->{setFWVariantUnderEntry}->{outfilename};
my $variantlist = $config->{setFWVariantUnderEntry}->{Variantguidlist};

my $lockfile = $infilename . '.lock' ;
die "A lockfile exists: $lockfile\
Don't run $0 when FW is running.\
Run it on a copy of the project, not the original!\
I'm quitting" if -f $lockfile ;

say "infile:$infilename outfile:$outfilename";

my $nktree = XML::LibXML->load_xml(location => $infilename);

foreach my $entryreftomodify ($nktree->findnodes(q#//VariantEntryTypes/..#)) {
	(my $componentlexguid) = $entryreftomodify->findvalue('./ComponentLexemes/objsur/@guid');
	next if (!$componentlexguid) ; # LexDB has VariantEntryTypes but not ComponentLexemes
	(my $variantguid )=  $entryreftomodify->findvalue('./VariantEntryTypes/objsur/@guid');
	next if ( index($variantlist,  $variantguid) == -1 ) ; # ignore variants not in the list
	(my $componentlexrt) = $nktree->findnodes(
		q#//rt[@guid= '#  . $componentlexguid . q#']#
		) ;
	(my $componentlexownerguid) = $componentlexrt->findvalue('./@ownerguid') ;
	next if (!$componentlexownerguid) ; #LexEntry has no owner, LexSense does
	#Found a reference to a LexSense change the reference to the LexSense owner
	(my $attr) = $entryreftomodify->findnodes('./ComponentLexemes/objsur/@guid');
	$attr->setValue($componentlexownerguid);
	}

my $xmlstring = $nktree->toString;
# Some miscellaneous Tidying differences
$xmlstring =~ s#><#>\n<#g;
$xmlstring =~ s#(<Run.*?)/\>#$1\>\</Run\>#g;
$xmlstring =~ s#/># />#g;
open my $out_fh, '>:raw', $outfilename;
print {$out_fh} $xmlstring;

# Subroutines
sub rtheader { # dump the <rt> part of the record
my ($node) = @_;
return  ( split /\n/, $node )[0];
}
