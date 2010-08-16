# quick and dirty check for XML problems
use strict;

#my $infile = 'apertium-fr-pt.fr.metadix';
my $infile = 'apertium-fr-pt.pt.dix';
#my $infile = 'apertium-fr-pt.fr-pt.dix';

open IN, $infile or die "Unable to read file '$infile': $!";
binmode(IN,':utf8');
while(<IN>) {
	next if /^<!/;	# ignore commented-out lines
#	next if m:</e>\s*$:;
#	next unless m:</l>\s*\S+\s*<r>:;
#	next unless (m:<pardef: or m:<e>:);
	next unless m:<e:;
	next if m:</e>:;
#	next unless m:<i:;
#	next if m:</i>:;
#	next unless m:<i: and m:<par:;
#	next if m:</i><par:;
	print "$.\t$_";
}
close IN;

open IN, $infile or die "Unable to read file '$infile': $!";
binmode(IN,':utf8');
local $/ = undef;
my $xml = <IN>;
close IN;

=pod

my @pardefs = $xml=~m:<pardef n="(.+?)">(.+?)</pardef>:msg;
while (@pardefs) {
	my $id = shift @pardefs;
	my $content = shift @pardefs;
	$content=~s:<e[^>]*>(.+?)</e>::msg;
	$content=~/\S/ or next;
	print "$id: $content\n\n";
}

=cut

=pod

my @e = $xml=~m:<e[^>]*>(.+?)</e>:msg;
while (@e) {
	my $e = shift @e;
	$e=~/<r/ and next;
	$e=~/<i/ and next;
	print "$e\n\n";
}

=cut
