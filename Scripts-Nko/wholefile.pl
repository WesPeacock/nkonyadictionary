# Version 1.0.1
    undef $/;
    $_ = <FH>;          # whole file now here
    s/(\\ge(\s\S+)+)\n(\\ps(\s\S+)+)/$2\n$1/g;
	print $_;
	