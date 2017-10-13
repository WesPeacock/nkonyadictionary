#!/usr/bin/perl
# perl trupto.pl SearchString [class]
# Transverse up to the rt of the class that contains SearchString

my $infilename="./NkTest.fwdata";


use 5.016;
use strict;
use warnings;
use utf8;

use open qw/:std :utf8/;
use XML::LibXML;

die "No search string given" if !$ARGV[0] ;
 
my $searchstring=$ARGV[0];

my $class = 'LexEntry'; 
if ($ARGV[1]) { $class=$ARGV[1]} ;

binmode(STDERR, ":utf8");
say STDERR "searchstring:$searchstring:\nclass:$class:";


my $lockfile = $infilename . '.lock' ;
die "A lockfile exists: $lockfile\
Don't run $0 when FW is running.\
Run it on a copy of the project, not the original!\
I'm quitting" if -f $lockfile ;

my $nktree = XML::LibXML->load_xml(location => $infilename);


my ($matchTextrt) = $nktree->findnodes(q#//*[contains(., '# . $searchstring . q#')]/ancestor::rt#);
if (!$matchTextrt) {
	say "The string, '", $searchstring, "' isn't in any records";
	exit;
	}

my ($foundOwnerrt) = traverseuptoclass($matchTextrt, $class);

my $xmlstring = $foundOwnerrt->toString;
# Some miscellaneous Tidying differences
$xmlstring =~ s#><#>\n<#g;
$xmlstring =~ s#(<Run.*?)/\>#$1\>\</Run\>#g;
$xmlstring =~ s#/># />#g;
binmode(STDOUT, ":utf8");
print $xmlstring;


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
