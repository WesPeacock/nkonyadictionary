#!/usr/bin/perl
# perl ./hackFWvariants.pl
use 5.016;
use strict;
use warnings;
use utf8;

use open qw/:std :utf8/;
use XML::LibXML;
# Todo put these in an .ini file and use  Config::Tiny 
use Config::Tiny;
 # ; hackFWvariants.ini file looks like:
 # [hackFWvariants]
 # modeltag=Model Unspecified Complex Entry
 # modifytag=Complex_Form
 # infilename=Nktest.fwdata
 # outfilename=Nktest.new.fwdata
my $config = Config::Tiny->read( 'PromoteSubentries.ini' );
#ToDo: get the pathname of the INI file from $0 so that the two go together
die "Couldn't find the INI file\nQuitting" if !$config;
my $modeltag = $config->{hackFWvariants}->{modeltag};
my $modifytag = $config->{hackFWvariants}->{modifytag};
my $infilename = $config->{hackFWvariants}->{infilename};
my $outfilename = $config->{hackFWvariants}->{outfilename};

if ( (index($modeltag, $modifytag) != -1) or  (index($modifytag, $modeltag) != -1)) {
# Xpath doesn't use regex and we use Xpath to query the FW project
	say 'Use different tags for modeltag and modifytag. One contains the other:';
	say 'modeltag=', $modeltag;
	say 'modifytag=', $modifytag;
	die;
	}

my $lockfile = $infilename . '.lock' ;
die "A lockfile exists: $lockfile\
Don't run $0 when FW is running.\
Run it on a copy of the project, not the original!\
I'm quitting" if -f $lockfile ;

my $nktree = XML::LibXML->load_xml(location => $infilename);

#ToMaybeDo -- if the script were used over and over:
#  build a hash of all rt's indexed by guid 
# But:
# "Premature optimization is the root of all evil."
#       - Sir Tony Hoare (popularized by Donald Knuth)

my ($modelTextrt) = $nktree->findnodes(q#//*[contains(., '# . $modeltag . q#')]/ancestor::rt#);
if (!$modelTextrt) {
	say "The model, '", $modeltag, "' isn't in any records";
	exit;
	}
# say  rtheader($modelTextrt) ;

my ($modelOwnerrt) = traverseuptoclass($modelTextrt, 'LexEntry');
say  'For the model entry, using:', displaylexentstring($modelOwnerrt);

my ($modelentryref) = $nktree->findnodes(
		q#//rt[@guid= '#  . 
		$modelOwnerrt->findvalue('./EntryRefs/objsur/@guid')
		. q#']#
		);
if ($modelentryref) {
	# Fetch the name of the ComplexEntryType that the model uses
	say 'It has a "', ($nktree->findnodes(
		q#//rt[@guid= '#  . 
		$modelentryref->findvalue('./ComplexEntryTypes/objsur/@guid')
		. q#']/Name/AUni/text()#
		))[0],
		'" EntryType';
	}
else {
	die "The model entry doesn't refer to another entry\nQuitting";
}
my ($modelHideMinorEntryval) = $modelentryref->findvalue('./HideMinorEntry/@val');
my ($modelRefTypeval) = $modelentryref->findvalue('./RefType/@val');
my $modelComplexEntryTypesstring= ($modelentryref->findnodes('./ComplexEntryTypes'))[0]->toString;
my ($modelHasAPrimaryLexemes) = $modelentryref->findnodes('./PrimaryLexemes') ;
my ($modelHasAShowComplexFormsIn) = $modelentryref->findnodes('./ShowComplexFormsIn');
say ''; say '';
=pod
say 'Found the model stuff:';
say 'HideMinorEntry val:', $modelHideMinorEntryval;
say 'RefType val:', $modelRefTypeval;
say 'ComplexEntryTypes (string):', $modelComplexEntryTypesstring;
say 'Has a PrimaryLexemes' if $modelHasAPrimaryLexemes;
say 'Has a ShowComplexFormsIn' if $modelHasAShowComplexFormsIn;
say 'End of the model stuff:';
=cut

foreach my $seToModifyTextrt ($nktree->findnodes(q#//*[contains(., '# . $modifytag . q#')]/ancestor::rt#)) {
	my ($seModifyOwnerrt) = traverseuptoclass($seToModifyTextrt, 'LexEntry'); 
	say  'Modifying Reference for:', displaylexentstring($seModifyOwnerrt) ;	
	my ($entryreftomodify) = $nktree->findnodes(
			q#//rt[@guid= '#  . 
			$seModifyOwnerrt->findvalue('./EntryRefs/objsur/@guid')
			. q#']#
			);
	# say 'EntryRefToModify Before: ', $entryreftomodify;
	# Attribute values are done in place
	(my $attr) = $entryreftomodify->findnodes('./HideMinorEntry/@val');
	$attr->setValue($modelHideMinorEntryval) if $attr; 
	($attr) = $entryreftomodify->findnodes('./RefType/@val');
	$attr->setValue($modelRefTypeval) if $attr; 
	
	# New nodes are built from strings and inserted in order
	my $newnode = XML::LibXML->load_xml(string => $modelComplexEntryTypesstring)->findnodes('//*')->[0];
	# the above expression makes a new tree from the model ComplexEntryTypestring
	$entryreftomodify->insertBefore($newnode, ($entryreftomodify->findnodes('./ComponentLexemes'))[0]);
	
	# Additional new nodes use the objsur@guid from the ComponentLexemes
	# Stringify the ComponentLexemes node, change the tags, nodify the changed string and put the new node in its place
	my ($CLstring) = ($entryreftomodify->findnodes('./ComponentLexemes'))[0]->toString;
	my $tempstring = $CLstring;
	if ($modelHasAPrimaryLexemes)  {
		$tempstring =~ s/ComponentLexemes/PrimaryLexemes/g;
		$newnode = XML::LibXML->load_xml(string => $tempstring)->findnodes('//*')->[0];
		$entryreftomodify->insertBefore($newnode, ($entryreftomodify->findnodes('./RefType'))[0]);
		}
	$tempstring = $CLstring;
	if ($modelHasAShowComplexFormsIn)  {
		$tempstring =~ s/ComponentLexemes/ShowComplexFormsIn/g;
		$newnode = XML::LibXML->load_xml(string => $tempstring)->findnodes('//*')->[0];
		$entryreftomodify->insertAfter($newnode, ($entryreftomodify->findnodes('./RefType'))[0]);
		}
	# remove the VariantEntryTypes (VET) node if it's there
	my ($VETnode) = $entryreftomodify->findnodes('./VariantEntryTypes') ;
		$VETnode->parentNode->removeChild($VETnode) if $VETnode ;
=pod
	say "";
	say "EntryRef After: ", $entryreftomodify ;
	say "";
	say "";
=cut
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
		($rt) = $nktree->findnodes(
			q#//rt[@guid= '#  . 
			$rt->getAttribute('ownerguid') 
			. q#']#
			);
	}
#	say 'Found ', rtheader($rt);
	return $rt;
}
sub displaylexentstring {
my ($lexentrt) = @_;
my ($formguid) = $lexentrt->findvalue('./LexemeForm/objsur/@guid');
my ($formstring) = $nktree->findnodes(
		q#//rt[@guid= '#  . 
		$lexentrt->findvalue('./LexemeForm/objsur/@guid')
		. q#']/Form/AUni/text()#
		);
# If there's more than one encoding, you only get the first

my $guid = $lexentrt->getAttribute('guid');
return qq#$formstring (guid="$guid")#;
}