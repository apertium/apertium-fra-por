use strict;

# for testing
@ARGV = qw(sample.fr-pt sample.pt-fr);

my (@at, @hash);
for my $sample (@ARGV) {
	@at = @hash = ();
	
	open IN, $sample or die "Unable to open $sample: $!";
	binmode(IN,':utf8');
	
	open OUT, ">$sample.scan" or die "Unable to create $sample.scan: $!";
	binmode(OUT, ':utf8');
	print OUT "SECTION: *\n";
	
	while (<IN>) {
		# ignore image indicators
		s/\[\*IMG\]//g;
		next unless /\S/;
		
		# check for *
		if (/\*/) {
			print OUT "$.\t$_";
		}
		if (/@/){
			push @at, "$.\t$_";
		}
		if (/#/){
			push @hash, "$.\t$_";
		}
	}
	close IN;
	
	print OUT "\n\nSECTION: @\n";
	print OUT @at;
	print OUT "\n\nSECTION: #\n";
	print OUT @hash;
	close OUT;
}
