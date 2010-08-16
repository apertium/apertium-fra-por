use strict;

#my $dir = 'frpt';
my $dir = 'ptfr';

my $want_multiples = 0;
#my $want_multiples = 1;

#my $want_multiwords = 0;
my $want_multiwords = 1;

# closed categories
#my $cat = 'cnjadv';	# clean in both directions
#my $cat = 'cnjcoo';	# clean in both directions
#my $cat = 'cnjsub';	# clean in both directions
#my $cat = 'det';	# clean in both directions
#my $cat = 'num';	# clean in both directions
#my $cat = 'ij';	# clean in both directions
#my $cat = 'pr';	# clean in both directions
#my $cat = 'preadv';	# clean in both directions
#my $cat = 'prn';	# clean in both directions
#my $cat = 'rel';	# clean in both directions
#my $cat = 'vbhaver';	# clean in both directions
#my $cat = 'vbmod';	# not listed with the errors
#my $cat = 'vbser';	# clean in both directions

# other categories
my $cat = 'adj';
#my $cat = 'adv';
#my $cat = 'n';
#my $cat = 'np';	# clean in both directions
#my $cat = 'vblex';

my %diccat = (
	'adj'    => 'adj',
	'adv'    => 'adv',
	'cnjadv' => 'conj',
	'cnjcoo' => 'conj',
	'cnjsub' => 'conj',
	'det'    => '(def|indef)',
	'ij'     => 'interj',
	'num'    => 'num',
	'rel'    => 'pron',
	'np'     => 'n',
	'n'      => 'n',
	'pr'     => 'pr',
	'prn'    => 'prn',
	'vblex'  => '(v|vt|vi)',
	'vbmod'  => '(v|vt|vi)',
	'vbser'  => '(v|vt|vi)',
);
my $diccat = $diccat{$cat} or die "No dictionary category specified for '$cat'";

# vaux? guio? cm? abbr?

my $bidixdir = 'frpt';
my $infile = $dir . 'inconsistency.txt';
my $bifile = $dir . 'bifix.txt';
my $monofile = $dir . 'monofix.txt';
my $dicfile = 'dics/' . $dir . '.dic';

open DIC, $dicfile or die "Unable to open file '$dicfile': $!";
binmode(DIC,':utf8');
my @dic;
while (<DIC>) {
	next unless /$diccat\./;
	chomp;
	push @dic, $_;
}

my (%seen_mono, %seen_bi);
open IN, $infile or die "Unable to open file '$infile': $!";
binmode(IN,':utf8');
open BIFIX, ">$bifile" or die "Unable to create file '$bifile': $!";
binmode(BIFIX,':utf8');
open MONOFIX, ">$monofile" or die "Unable to create file '$monofile': $!";
binmode(MONOFIX,':utf8');
while (<IN>) {
	next unless m:<$cat>:;	# only get lines that have our category
#	next if /REGEX/;	# skips lines containing 'REGEX'
	
	# don't get <det> lines if a noun is also present
	if ($cat eq 'det') {
		next if m:<n>:;
		next if m:<np>:;
	}
	
	# don't get <preadv> lines if a adjective or adverb is also present
	if ($cat eq 'preadv') {
		next if m:<adj>:;
		next if m:<adv>:;
	}
	
	# don't get <adv> lines if a adjective or verb is also present
	if ($cat eq 'adv') {
		next if m:<adj>:;
		next if m:<v:;
	}
	
	# don't get <cnjsub> lines if a verb is also present
	if ($cat eq 'cnjsub') {
		next if m:<v:;
	}
	
	# don't get <prn> lines if a verb is also present
	if ($cat eq 'prn') {
		next if m:<v:;
	}
	
	# don't get <vbhaver> lines if a past participle is also present
	if ($cat eq 'vbhaver') {
		next if m:<pp:;
	}
	
	# don't get <pr> lines if a gerund is also present
	if ($cat eq 'pr') {
		next if m:<ger:;
	}
	
	my @stages = split /\s*--------->\s*/;
	(my $m = $stages[1])=~s/@//;
	my @p;
	while ($m=~s/<(.+?)>//) {
		push @p, $1;
	}
	
#	if ($cat) {
#		next unless $p[0] eq $cat;
#		# sometimes vb* gets translated to prn+vb*
#		# we don't want that if we're looking for prn
#		if ($cat eq 'prn') {
#			next if /vblex/;
#			next if /vbmod/;
#		}
#	}
	
	my ($w) = $m=~/\^(.+?)\$/;
	
	unless ($want_multiwords) {
		next if $w=~/#/;
	}
#print;
	# entries missing from bidix
	if (/@/ and not $seen_bi{$w}) {
		$seen_bi{$w} = 1 unless $want_multiples;
		$w=~s: :<b/>:g;
		my $s1 = $w;
		my @poss;
		ENTRY: for my $entry (@dic) {
			next unless $entry=~/\b$s1\b/i;
			push @poss, $entry;
		}
		@poss or @poss = ($s1);
		
		if ($s1=~/#/) {
			for ($s1, @poss) {
				s:#(.+):<g>$1</g>:;
			}
		}
		
		for my $p (@p) {
			next unless (
				   $p eq $cat
#					or ($cat eq 'n' and ($p eq 'm' or $p eq 'f'))
			);
			for ($s1, @poss) {
				$_ .= qq(<s n="$p"/>);
			}
		}
		
		for my $s2 (@poss) {
			my ($os1,$os2);
			if ($dir eq $bidixdir) {
				($os1,$os2) = ($s1,$s2);
			}
			else {
				($os1,$os2) = ($s2,$s1);
			}
# just print the offending lines
#print BIFIX qq($_);
#next;
			print BIFIX qq($.\t$_);
			if (length($os1) >= 35) {
				if ($cat eq 'np') {
					print BIFIX qq(<e>       <p><l>$os1</l><r>$os2</r></p></e>\n);
				}
				else {
					print BIFIX lc(qq(<e>       <p><l>$os1</l><r>$os2</r></p></e>\n));
				}
			}
			else {
				print BIFIX "<e>       <p>";
				if ($cat eq 'np') {
					print BIFIX pack('A42', qq(<l>$os1</l>));
					print BIFIX qq(<r>$os2</r></p></e>\n);
				}
				else {
					print BIFIX lc(pack('A42', qq(<l>$os1</l>)));
					print BIFIX lc(qq(<r>$os2</r></p></e>\n));
				}
			}
		}
	}

	# entries missing from monodix
	if (/>  *#/ and not $seen_mono{$w}) {
		$seen_mono{$w} = 1 unless $want_multiples;
		(my $w2 = $w)=~s: :<b/>:g;
		my $s = $w;
		for my $p (@p) {
			$s .= qq(<s n="$p"/>);
		}
		my $g;
		if ($w2=~s/#(.+)//) {
			$g = "<p><l>$1</l><r><g>$1</g></r></p>";
			$w=~s/#//;
		}
		my $monodix = <<E;
		  <e lm="$w">
			<i>$w2</i>
			<par n="???__$p[0]"/>
			$g
		  </e>
E
			$monodix=~s/\s+</</g;
		if ($dir eq 'ptfr') {
#			$monodix=~s/^/          /g;
		}
		print MONOFIX qq($.\t$_);
		if ($cat eq 'np') {
			print MONOFIX "$monodix";
		}
		else {
			print MONOFIX lc "$monodix";
		}
	}
}
close IN;
close OUT;
