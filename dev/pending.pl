use strict;

my $source = 'fr'; my $target = 'pt';
#my $source = 'pt'; my $target = 'fr';

my @cats = qw(n adj adv);

my $catrx = join('|', @cats);
my $dir = $source . $target;
my $bidixdir = 'frpt';
my $infile = $dir . 'inconsistency.txt';
my $dixfile = "../apertium-fr-pt.$source." . ($source eq 'fr' ? 'metadix' : 'dix');
my $keepers = $dir . '.keepers';
my $pending = $dir . '.pending';

open LOG, ">log.pending.txt" or die "Unable to create file 'log.pending.txt': $!";
binmode(LOG,':utf8');

my %bad;
open IN, $infile or die "Unable to open file '$infile': $!";
binmode(IN,':utf8');
while (<IN>) {
	next unless /[@#]/;
	
	my ($main_cat) = /<(.+?)>/;
	next unless $main_cat=~/^($catrx)$/;
	
	my ($word) = m/\^(.+?)\$/;
	$word=~s/<.+?>//g;
	$word=~s/#//;
	
	$word=~s/([IVXLCDM]+)ème/$1/;	# French Roman numeral adjectives
	
	$bad{lc $word}{$main_cat}++;
	print LOG "Adding $word ($main_cat) to the list of bad entries\n";
}
close IN;

print LOG "\n\nChecking\n";

open DIX, $dixfile or die "Unable to open file '$dixfile': $!";
binmode(DIX,':utf8');
open KEEPERS, ">$keepers" or die "Unable to create file '$keepers': $!";
binmode(KEEPERS,':raw:utf8');
open PENDING, ">$pending" or die "Unable to create file '$pending': $!";
binmode(PENDING,':raw:utf8');

# skip to the beginning of the sections
while (<DIX>) {
	print KEEPERS;
	last if m:</pardefs>:;
}

select DIX;
$/ = '</e>';
select STDOUT;

my $comment;
while (<DIX>) {
print LOG "Checking [$_]\n";
	if (my @nc = /(<!--)/g) {
		$comment += @nc;
		print LOG "Opening comment ($comment)\n";
	}
	if (my @nc = /(-->)/g) {
		$comment -= @nc;
		print LOG "Closing comment ($comment)\n";
	}
	
	if ($comment) {
print LOG "Inside a comment ($comment)\n";
		print KEEPERS;
		next;
	}
	
	s:(\s*<e\W.+?</e>)::s;
	my $entry = $1;
print LOG "Got [$entry]\n";
	
	print KEEPERS;
	
	my ($lm) = $entry=~/lm="(.+?)"/;
	my $cat;
	my ($par) = $entry=~/par n="(.+?)"/;
	if ($par) {
		($cat) = $par=~/__(.+?)$/;
	}
	else {
		($cat) = $entry=~m:<s n="(.+?)"/>:
	}
print LOG "Checking $lm ($cat)\n";
	if (exists $bad{lc $lm}{$cat}) {
		$bad{lc $lm}{$cat}--;
print LOG "\tPrinted to pending\n";
		print PENDING $entry;
	}
	else {
print LOG "\tPrinted to keepers\n";
		print KEEPERS $entry;
	}
}

close DIX;
close KEEPERS;
close PENDING;

print LOG "Leftovers\n";
for my $word (sort keys %bad) {
	for my $cat (sort keys %{ $bad{$word} }) {
		next unless $bad{$word}{$cat};
		print LOG "$word ($cat): $bad{$word}{$cat}\n";
	}
}
# run through %bad and print erroneous entries to LOG
close LOG;

__END__
