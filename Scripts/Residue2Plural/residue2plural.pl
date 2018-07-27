#!/usr/bin/perl
#usage (Linux only -- No Strawberry perl Data::UUID):
# xmlstarlet command below | perl -nf ./residue2plural.pl

# build plural variant RTs for an fwdata file from import residues
# The Import Residue (Sense) contain "\pl plural_form"
#
# reads a file of OrigLexEntGUID$OrigPluralForm
# build that file like:
     # xmlstarlet sel -t -m "//ImportResidue/Str/Run" -v 'concat(../../../@ownerguid, "$", substring(., 5))' -n Nafaanra.fwdata
	# meaning: for each ImportResidue text get the ownerguid of the current sense; $; strip off "\pl " from the string;
# builds new Variant Entry with for the OrigLexEnt using the OrigPluralForm
#
# The magic template was made from a diff patch of the .fwdata file
    # comparing before and after a single manual changing a residue to a plural variant
    # The guids and the plural Form get changed into unique strings:
    # _NewLexEntGUID_
    # _NewLexRefGUID_
    # _NewLexFormGUID_
    # _OrigPluralForm_
    # _OrigLexEntGUID_

use 5.016;
use strict;
use warnings;
use utf8;
use Data::UUID;

use open qw/:std :utf8/;

my $template  = <<'END_RTs';
<rt class="LexEntry" guid="_NewLexEntGUID_">
<DateCreated val="2018-7-25 15:42:39.93" />
<DateModified val="2018-7-25 15:42:43.998" />
<DoNotUseForParsing val="False" />
<EntryRefs>
<objsur guid="_NewLexRefGUID_" t="o" />
</EntryRefs>
<HomographNumber val="0" />
<LexemeForm>
<objsur guid="_NewLexFormGUID_" t="o" />
</LexemeForm>
</rt>

<rt class="MoStemAllomorph" guid="_NewLexFormGUID_" ownerguid="_NewLexEntGUID_">
<Form>
<AUni ws="nfr">_OrigPluralForm_</AUni>
</Form>
<IsAbstract val="False" />
<MorphType>
<objsur guid="d7f713e8-e8cf-11d3-9764-00c04f186933" t="r" />
</MorphType>
</rt>

<rt class="LexEntryRef" guid="_NewLexRefGUID_" ownerguid="_NewLexEntGUID_">
<ComponentLexemes>
<objsur guid="_OrigLexEntGUID_" t="r" />
</ComponentLexemes>
<HideMinorEntry val="1" />
<RefType val="0" />
<VariantEntryTypes>
<objsur guid="a32f1d1c-4832-46a2-9732-c2276d6547e8" t="r" />
</VariantEntryTypes>
</rt>
END_RTs


chomp;
# say "IN:$_";
(my $origlexguid, my $plform) = split (/\$/, $_ );
$template =~ s/_OrigLexEntGUID_/$origlexguid/g;
$template =~ s/_OrigPluralForm_/$plform/g;

my $ug = Data::UUID->new;
my $newlexguid = lc $ug->create_str();
$template =~ s/_NewLexEntGUID_/$newlexguid/g;

$ug = Data::UUID->new;
my $newlexformguid = lc $ug->create_str();
$template =~ s/_NewLexFormGUID_/$newlexformguid/g;

$ug = Data::UUID->new;
my $newlexrefguid = lc $ug->create_str();
$template =~ s/_NewLexRefGUID_/$newlexrefguid/g;

say $template;
