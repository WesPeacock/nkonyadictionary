#! /bin/perl de_opl-bsl.pl
# replace octothorpes with a newline
# replace "__hash__" with octothorpe
# undoes opl-bsl.pl
my $str = do {
    local $/;
    <STDIN>
};
$str =~ s/#/\n/g;
$str =~ s/__hash__/#/g;
print $str;
