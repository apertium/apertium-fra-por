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

open IN, $infile or die "Unable to open file '$infile': $!";
binmode(IN,':utf8');
open DIX, $dixfile or die "Unable to open file '$dixfile': $!";
binmode(DIX,':utf8');
open KEEPERS, ">$keepers" or die "Unable to create file '$keepers': $!";
binmode(KEEPERS,':raw:utf8');
open PENDING, ">$pending" or die "Unable to create file '$pending': $!";
binmode(PENDING,':raw:utf8');
open LOG, ">log.pending.txt" or die "Unable to create file 'log.pending.txt': $!";
binmode(LOG,':utf8');

# skip to the beginning of the sections
while (<DIX>) {
	print KEEPERS;
	last if m:</pardefs>:;
}

my %seen;
while (<IN>) {
	next unless /[@#]/;
	
	my ($main_cat) = /<(.+?)>/;
	next unless $main_cat=~/^($catrx)$/;
	
	my ($word) = m/\^(.+?)\$/;
	$word=~s/<.+?>//g;
	$word=~s/#//;
	
	if ($dir eq 'frpt') {
		# skip these for now

=pod

		$word=~s/([IVXLCDM]+)ème/$1/;
		next if $word eq 'chanceli';
		next if $word eq 'lentillede  verre';
		next if $word eq 'resposabilité';
		next if $word eq 'assemblée nationale';
		next if $word eq 'obligation convertible';
		next if $word eq 'corps de métier';
		next if $word eq 'eau de javel';
		next if $word eq 'lentillede contact';
		next if $word eq 'moyen de production';
		next if $word eq 'moyen de transport';
		next if $word eq 'exportateur';
		next if $word eq 'voilà tout';
		next if $word eq 'dans une situation désavantageuse';
		next if $word eq 'dépouille';
		next if $word eq 'arc -en-ciel';
		next if $word eq 'poste de police';
		next if $word eq 'chèque nominatif';
		next if $word eq 'organisateueur';
		next if $word eq 'compte avec possibilité de découver';
		next if $word eq 'compte de résultat';
		next if $word eq 'compte salaire';
		next if $word eq 'compte du salaire';
		next if $word eq "compte d'exploitation";
		next if $word eq "compte d'épargne-logement";
		next if $word eq 'compte de charge';
		next if $word eq "compte d'épargne";
		next if $word eq "service d'intercommunication des caisses d'épargne";
		next if $word eq 'exécutiff';
		next if $word eq 'voilier';
		next if $word eq 'obligation convertible';
		next if $word eq 'bien entendu';
		next if $word eq 'de mon temps';
		next if $word eq "d'un bout à l'autre";
		next if $word eq 'en son temps';
		next if $word eq 'encore plus';
		next if $word eq 'et de loin';
		next if $word eq 'loin de là';
		next if $word eq 'chanceli';
		next if $word eq 'chanceli';
		next if $word eq 'chanceli';
		next if $word eq 'chanceli';
		next if $word eq 'chanceli';
		next if $word eq 'chanceli';
		next if $word eq 'chanceli';
		next if $word eq 'chanceli';

=cut

	}
	
	next if $seen{$word}{$main_cat};
	$seen{$word}{$main_cat} = 1;
	
print LOG "Searching for $word ($main_cat)\n\t$_";
	# now we have an error line for one of our categories
	# find the same word in the dix file
	my $etag = '';
	ETAG: while (<DIX>) {
		if ($etag) {
			$etag .= $_;
		}
		if (/<e\W/) {
			$etag = $_;
		}
		if ($etag) {
			next unless $etag=~m:</e>:;
			# now we have an e element; does it contain our word and category?
			my ($lm) = $etag=~/lm="(.+?)"/;
			my ($par) = $etag=~/par n="(.+?)"/;
			
print LOG "\tFound $lm ($par)\n";
			if (lc $lm eq lc $word and $par=~/__$main_cat$/) {
print LOG "\t\tPrinted to pending\n";
				print PENDING $etag;
				last ETAG;
			}
			if (lc $lm eq lc $word and $etag=~m:<s n="$main_cat"/>:) {
print LOG "\t\tPrinted to pending\n";
				print PENDING $etag;
				last ETAG;
			}
print LOG "\t\tPrinted to keepers\n";
			print KEEPERS $etag;
			$etag = '';
		}
		else {
			print KEEPERS;
		}
	}
}

# get anything left in the dix file
while (<DIX>) {
	print KEEPERS;
}

close IN;
close KEEPERS;
close PENDING;

__END__
