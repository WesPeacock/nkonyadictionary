my $USAGE = "Usage: $0 --varmark \\variantmarker [--recmark lx] [--hmmark hm] [--glossmark ge] [--debug] file.sfm";
# other options:
# --recmark (default \lx)
# --hmmark (default \hm)
# --glossmark (default \ge)
# --hmmax (default 5)
# 
# Daasanach inflection report
# assumes no duplicate \lx\hm combos
# builds a hash of the opl'd file keyed on the \lx\hm
# builds an array of keys to the hash that have the variant
# compile with pp -o InfReport.exe InflectionFormReport.pl

use 5.016;
use strict;
use warnings;
use utf8;
use English;
use open qw/:std :utf8/;
use Data::Dumper qw(Dumper);

use Getopt::Long;
GetOptions (
	'recmark:s'   => \(my $recmark = "lx"), # record mark
	'hmmark:s'    => \(my $hmmark = "hm"), # homograph number
	'glossmark:s' => \(my $glossmark = "ge"), # gloss/definition field marker
	'varmark=s'   => \my $varmark, # variant marker
	'debug'       => \my $debug,
	) or die $USAGE;
$recmark = '\\' . $recmark if ( $recmark !~ /^\\/);
$recmark .= ' '; $recmark =~ s/\\/\\\\/;
$hmmark = '\\' . $hmmark if ( $hmmark !~ /^\\/);
$hmmark .= ' '; $hmmark =~ s/\\/\\\\/;
$glossmark = '\\' . $glossmark if ( $glossmark !~ /^\\/);
$glossmark .= ' '; $glossmark =~ s/\\/\\\\/;
$varmark = '\\' . $varmark if ( $varmark !~ /^\\/);
$varmark .= ' '; $varmark =~ s/\\/\\\\/;

my $variant =$varmark; # Name of Variant for output
$variant =~ s/\\//g;
$variant =~ s/ //g;


my $hmmax = 0;
my $infile = pop @ARGV;
die "InfReport needs an input file\nUsage:InfReport --varmark xx filename\n" if !$infile;

if ($debug) {
	say "rm=$recmark=";
	say "hm=$hmmark=";
	say "ge=$glossmark=";
	say "var=$varmark=";
	say $infile;
	}
	
my @varfields = ("hm", "ps", "mn",  "rt", "dc", "ic", "Cs");  # variable fields to print

my %oplhash; # hash of opl'd file keyed by \lx(\hm)

open(my $fhinfile, '<:encoding(UTF-8)', $infile)
  or die "Could not open file '$infile' $!";

my @varmarkrecs; # keys to records having variants
my $line="";
my $lxkey = "";
while (<$fhinfile>){
	chomp;
	if (/$hmmark/) { #minor tidy on hm
		s/\ +/\ /;
		}
	s/#/\_\_hash\_\_/g;
	my $field = $_;
	if (! /$recmark/ ){
		$line .= $field . "#";
		}
	else {
		if ($line =~ /$recmark([^#]*)#/) {
			$lxkey = $1;
			$oplhash{$lxkey} = "" if ! exists $oplhash{$lxkey};
			
			if ($line =~ m/$hmmark([^#]*)#/) {
				$lxkey .= $1;
				$hmmax = $1 + 0 if $1 + 0 > $hmmax;
				}
			$oplhash{$lxkey} = $line;
			
			if ($line =~ m/$varmark/) {
				push @varmarkrecs, $lxkey;
				}
			}
		
		$line=$field . "#";	
		}
}
close $fhinfile;
#say "oplhash", Dumper(%oplhash);
#say "varmarkrecs", Dumper(@varmarkrecs);

foreach (@varmarkrecs) {
	my $mainrec = $oplhash{$_};
	my $lxkey = $_;
	my $maininfo ="Main Lex:$lxkey";
	while ($mainrec =~  /$glossmark([^#]*)#/g) {
		my $glosstext = $1;
		$maininfo .= "\{" . $glosstext . "\}";
		}

		$mainrec =~  /\\ps ([^#]*)#/;
	my $pstext = $1;
	$maininfo .= " LexPS:\{" . $pstext . "\}";

	$maininfo .= " $variant-Variant:";
	while ($mainrec =~ /$varmark([^#]*)#/g) {
		my $vartext =$1;
		my $reportline = $maininfo . $vartext;
		if ( ! exists $oplhash{$vartext} ) { # variant not there
			say $reportline,  " NOT_FOUND";
			}
		elsif ( $oplhash{$vartext} ) { # variant found as main
			$line = $oplhash{$vartext};
			printvarinfo( $reportline, $line, @varfields);
			}
		else { # loop through the homographs of the variant
			for (my $hmno=1; $hmno <= $hmmax; $hmno++) {
				if (exists $oplhash{$vartext . $hmno}) {
					$line = $oplhash{$vartext . $hmno};
					printvarinfo(  $reportline, $line, @varfields);
					}
				}
			}
		}
	}

sub printvarinfo {
	(my $reportline, my $varline, my @fields) = (@_);
	$reportline .= " MATCHES_GLOSS";
	while ($varline =~  m/$glossmark([^#]*)#/g) { $reportline .="\{$1\}" };
	foreach my $field (@fields) {
		if ($varline =~  m/\\$field ([^#]*)#/) {
			$reportline .= " $field\{$1\}";
			}
		}
	say $reportline;
}
