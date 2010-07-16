use strict;
my $infile = 'frptbifix.txt';
my $infile = 'ptfrbifix.txt';

open OUT, '>quikscan.txt' or die $!;
open IN, $infile or die $!;
while (<IN>) {
	my @p = split /\s*--------->\s*/;
	my $w = $p[0];
	$w=~s:<.+?>::g;
	$w=~s:[#^\$]::g;
	print OUT $w,"\n";
}
close IN;
close OUT;