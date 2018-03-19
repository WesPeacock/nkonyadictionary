#!/usr/bin/perl
# perl checkrts.pl fwdatafilename
# Find all objsur where the guid doesn't exist
# Find all rts where ownerguid doesn't exist
# Note in linux shebang only works if you run
#   dos2unix checkrts.pl


use 5.016;
use strict;
use warnings;
use utf8;

use open qw/:std :utf8/;
use XML::LibXML;

die "No filename given" if !$ARGV[0] ;
 
my $infilename=$ARGV[0];

binmode(STDERR, ":utf8");

my $lockfile = $infilename . '.lock' ;
die "A lockfile exists: $lockfile\
Don't run $0 when FW is running.\
Run it on a copy of the project, not the original!\
I'm quitting" if -f $lockfile ;

my %rthash;

my $nktree = XML::LibXML->load_xml(location => $infilename);

foreach my $rtnode ($nktree->findnodes(q#//rt#)) {
	$rthash{ $rtnode->findvalue('./@guid') } = $rtnode;
	}

foreach my $objsur ($nktree->findnodes(q#//objsur#)) {
	if (!exists $rthash{ $objsur->findvalue('./@guid') }) {
		# dump entire rt element with missing objsur
		say "objsur points to mising guid: ", $objsur->findvalue('./@guid');
		say "in rt:" ;
		say $objsur->findnodes('./ancestor::rt') ;
		}
	}

foreach my $rtnode ($nktree->findnodes(q#//rt#)) {
	my $ownerguid=$rtnode->findvalue('./@ownerguid');
	next if ! $ownerguid;
	if (!exists $rthash{ $ownerguid }) {
		# dump first line of rt element with missing ownerguid
		say "pointer to missing ownerguid: $ownerguid";
		say "in rt: ", rtheader($rtnode);
		}
	}


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
