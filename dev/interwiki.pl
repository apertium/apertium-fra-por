use strict;

my $infile = 'interwiki.noun.pt-fr';
my $outfile = 'interwiki.txt';

my %seen;
open IN, $infile or die $!;
binmode(IN,':utf8');
open OUT, ">$outfile" or die $!;
binmode(OUT,':utf8');

while (<IN>) {
	my ($pt) = m:<l>(.+?)</l>:;
	my ($fr) = m:<r>(.+?)</r>:;
	
	for ($pt, $fr) {
		s/_/ /g;
		s/> />/g;
		s/ </</g;
	}
	
	next if $seen{$pt.$fr};
	$seen{$pt.$fr} = 1;
	
	print OUT "<e>       <p>";
	if (length($fr) > 35) {
		print OUT qq(<l>$fr</l>);
	}
	else {
		print OUT pack('A42', qq(<l>$fr</l>));
	}
	print OUT qq(<r>$pt</r></p></e>\n);
}
