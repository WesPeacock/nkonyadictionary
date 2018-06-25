# for all lines with \ref Bkname:chapter:verse
# convert to \ref Bkno_Bkname:chapter:verse
# e.g. \ref MAT:23:05  becomes \ref 41_MAT:23:05
# hash of booknos by bookname
$bookno{'GEN'} = '01';
$bookno{'EXO'} = '02';
$bookno{'LEV'} = '03';
$bookno{'NUM'} = '04';
$bookno{'DEU'} = '05';
$bookno{'JOS'} = '06';
$bookno{'JDG'} = '07';
$bookno{'RUT'} = '08';
$bookno{'1SA'} = '09';
$bookno{'2SA'} = '10';
$bookno{'1KI'} = '11';
$bookno{'2KI'} = '12';
$bookno{'1CH'} = '13';
$bookno{'2CH'} = '14';
$bookno{'EZR'} = '15';
$bookno{'NEH'} = '16';
$bookno{'EST'} = '17';
$bookno{'JOB'} = '18';
$bookno{'PSA'} = '19';
$bookno{'PRO'} = '20';
$bookno{'ECC'} = '21';
$bookno{'SNG'} = '22';
$bookno{'ISA'} = '23';
$bookno{'JER'} = '24';
$bookno{'LAM'} = '25';
$bookno{'EZK'} = '26';
$bookno{'DAN'} = '27';
$bookno{'HOS'} = '28';
$bookno{'JOL'} = '29';
$bookno{'AMO'} = '30';
$bookno{'OBA'} = '31';
$bookno{'JON'} = '32';
$bookno{'MIC'} = '33';
$bookno{'NAM'} = '34';
$bookno{'HAB'} = '35';
$bookno{'ZEP'} = '36';
$bookno{'HAG'} = '37';
$bookno{'ZEC'} = '38';
$bookno{'MAL'} = '39';
$bookno{'MAT'} = '41';
$bookno{'MRK'} = '42';
$bookno{'LUK'} = '43';
$bookno{'JHN'} = '44';
$bookno{'ACT'} = '45';
$bookno{'ROM'} = '46';
$bookno{'1CO'} = '47';
$bookno{'2CO'} = '48';
$bookno{'GAL'} = '49';
$bookno{'EPH'} = '50';
$bookno{'PHP'} = '51';
$bookno{'COL'} = '52';
$bookno{'1TH'} = '53';
$bookno{'2TH'} = '54';
$bookno{'1TI'} = '55';
$bookno{'2TI'} = '56';
$bookno{'TIT'} = '57';
$bookno{'PHM'} = '58';
$bookno{'HEB'} = '59';
$bookno{'JAS'} = '60';
$bookno{'1PE'} = '61';
$bookno{'2PE'} = '62';
$bookno{'1JN'} = '63';
$bookno{'2JN'} = '64';
$bookno{'3JN'} = '65';
$bookno{'JUD'} = '66';
$bookno{'REV'} = '67';
$bookno{'JDT'} = '69';
$bookno{'ESG'} = '70';
$bookno{'WIS'} = '71';
$bookno{'SIR'} = '72';
$bookno{'BAR'} = '73';
$bookno{'LJE'} = '74';
$bookno{'S3Y'} = '75';
$bookno{'SUS'} = '76';
$bookno{'BEL'} = '77';
$bookno{'1MA'} = '78';
$bookno{'2MA'} = '79';
$bookno{'3MA'} = '80';
$bookno{'4MA'} = '81';
$bookno{'1ES'} = '82';
$bookno{'2ES'} = '83';
$bookno{'MAN'} = '84';
$bookno{'PS2'} = '85';
while (<>) {
	if (/\\ref /) {
# bookname is the first part split by ':' of the second part split by ' '
		$ref= (split /\:/,(split / /)[1])[0];
		$_ =~ s/$ref/$bookno{$ref}_$ref/;
		}
	print;
}

