use strict;

#my $source = 'fr'; my $target = 'pt';
my $source = 'pt'; my $target = 'fr';
my $dir = $source.$target;

my ($ant, $loc, $al);
if ($target eq 'fr') {
	$ant = 'Nom';
	$loc = 'Lieu';
	$al = 'Autre';
}
else {
	$ant = 'Nome';
	$loc = 'Lugar';
	$al = 'Outro';
}

my $infile = $dir . 'monofix.txt';
my $outfile = 'npfix.txt';

open IN, $infile or die $!;
binmode(IN,':utf8');
open OUT, ">$outfile" or die $!;
binmode(OUT,':utf8');
while (<IN>) {
	next unless /^\d/;
	# / means couldn't decide between targets in the target language
	# don't give it another target to choose from
	next if m:/:;
	my @w = /\^(.+?)</g;
	my $w1 = $w[1];
	(my $w2 = $w1)=~s: :<b/>:g;
	if (/<ant>/) {
		print OUT qq(<e lm="$w1"><i>$w2</i><par n="${ant}__np"/></e>\n);
		next;
	}
	if (/<loc>/) {
		print OUT qq(<e lm="$w1"><i>$w2</i><par n="${loc}__np"/></e>\n);
		next;
	}
	if (/<al>/) {
		print OUT qq(<e lm="$w1"><i>$w2</i><par n="${al}__np"/></e>\n);
		next;
	}
	warn "Oops!: $_";
}