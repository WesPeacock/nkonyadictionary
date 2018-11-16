#! /bin/perl opl-bsl.pl
# concatenate all lines that don't start with a \ character
# replacing the newline with an octothorpe
# replace pre-existing octothorpes with "__hash__"
my $str = do {
    local $/;
    <STDIN>
};
$str =~ s/#/__hash__/g;
$str =~ s/\n(?!\\)/#/g;
print $str;
