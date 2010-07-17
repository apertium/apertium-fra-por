use strict;

my $cat = 'np';
#my $cat = 'n';

#my $source = 'fr'; my $target = 'pt';
my $source = 'pt'; my $target = 'fr';
my $dir = $source.$target;

my $infile = $dir . 'wiki.txt';
my $outfile = 'wikifix.txt';

open IN, $infile or die $!;
binmode(IN,':utf8');
open OUT, ">$outfile" or die $!;
binmode(OUT,':utf8');
while (<IN>) {
	next if /^\d/;
	if (s/^NOTFOUND:$source://) {
		format_notfound($_);
		next;
	}
	print;
}
close IN;
close OUT;

sub format_notfound {
	my $w = $_[0];
	chomp $w;
	
	$w .= qq(<s n="$cat"/>);
	if (length($w) >= 35) {
		if ($cat eq 'np') {
			print OUT qq(<e>       <p><l>$w</l><r>$w</r></p></e>\n);
		}
		else {
			print OUT lc(qq(<e>       <p><l>$w</l><r>$w</r></p></e>\n));
		}
	}
	else {
		print OUT "<e>       <p>";
		if ($cat eq 'np') {
			print OUT pack('A42', qq(<l>$w</l>));
			print OUT qq(<r>$w</r></p></e>\n);
		}
		else {
			print OUT lc(pack('A42', qq(<l>$w</l>)));
			print OUT lc(qq(<r>$w</r></p></e>\n));
		}
	}
}
