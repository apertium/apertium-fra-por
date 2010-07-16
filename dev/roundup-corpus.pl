#! /bin/perl
use strict;

my $fr_corpus = '/cygdrive/u/home/sean/frwikicorpus.txt';
my $pt_corpus = '/cygdrive/u/home/sean/ptwikicorpus.txt';
my $chunk_size = 0x4000;

$| = 1;

process_corpus('fr-pt', $fr_corpus);
#process_corpus('pt-fr', $pt_corpus);

sub process_corpus {
	my ($direction, $corpus_file) = @_;
	
	my $size = -s $corpus_file;
	my $numchunks = $size / $chunk_size;
	if (int($numchunks) != $numchunks) {
		$numchunks = int($numchunks) + 1;
	}
	my $chunknum;
	
	my ($total, $star_total, $at_total, $hash_total);
	
	my $buffer;
	open CRPS, $corpus_file or die $!;
	binmode(CRPS,':utf8');
	while (<CRPS>) {
#last if $. > 10;	# for testing
last if $total >= 1000000;	# limit corpus (cygwin too slow)
		next unless /\S/;
		
		my $pos = tell CRPS;
		my $pct = sprintf('%02.3f', 100*$pos/$size);
		print STDERR "\rReached line $.; $pos of $size bytes ($pct%)";
		
		$buffer .= $_;
		if (length($buffer) >= $chunk_size) {
			my $chunklen = length($buffer);
			$chunknum++;
			
			print STDERR "\nProcessing chunk number $chunknum (of $numchunks predicted)\n";
			my $t = time;
			process_chunk($direction, $buffer, \$total, \$star_total, \$at_total, \$hash_total);
			my $proctime = time - $t;
			$buffer = '';
			
			my $star_pct = sprintf('%02.3f%%', 100*$star_total/$total);
			my $at_pct = sprintf('%02.3f%%', 100*$at_total/$total);
			my $hash_pct = sprintf('%02.3f%%', 100*$hash_total/$total);
			
			my $none_total = $total - $star_total - $at_total - $hash_total;
			my $none_pct = sprintf('%02.3f%%', 100*$none_total/$total);
			
			my $runtime = time - $^T;
			my $total_runtime = ($runtime * $chunknum) * $numchunks;
			my $time_left = $total_runtime - $runtime;
			
			my ($rh, $rm, $rs) = format_runtime($runtime);
			my ($th, $tm, $ts) = format_runtime($total_runtime);
			my ($lh, $lm, $ls) = format_runtime($time_left);
			
			print STDERR <<REPORT;
Latest chunk processed: $chunklen bytes in $proctime seconds
Running time: $runtime seconds ($rh:$rm:$rs)
Predicted total running time: $total_runtime seconds ($th:$tm:$ts)
Predicted time remaining: $time_left ($lh:$lm:$ls)
Interim report:
Direction: $direction
Total words in corpus: $total
-\t$none_total\t$none_pct
*\t$star_total\t$star_pct
@\t$at_total\t$at_pct
#\t$hash_total\t$hash_pct

REPORT
		}
	}
	close CRPS;
	
	if (length($buffer) > 0) {
		process_chunk($direction, $buffer, \$total, \$star_total, \$at_total, \$hash_total);
	}
die if $total == 0;	# shouldn't happen

	print "\n\n";
	
	my $star_pct = sprintf('%02.3f%%', 100*$star_total/$total);
	my $at_pct = sprintf('%02.3f%%', 100*$at_total/$total);
	my $hash_pct = sprintf('%02.3f%%', 100*$hash_total/$total);
	
	my $none_total = $total - $star_total - $at_total - $hash_total;
	my $none_pct = sprintf('%02.3f%%', 100*$none_total/$total);
	
	print <<REPORT;
Direction: $direction
Total words in corpus: $total
-\t$none_total\t$none_pct
*\t$star_total\t$star_pct
@\t$at_total\t$at_pct
#\t$hash_total\t$hash_pct

REPORT
}

sub process_chunk {
	my ($direction, $chunk, $total, $star_total, $at_total, $hash_total) = @_;
	
	# pass to apertium via temp files rather than stdin/stdout;
	# avoids need to escpae quotes and ensures utf8
	
	open TMP, ">tmpin_$direction" or die $!;
	binmode(TMP,':utf8');
	print TMP $chunk;
	close TMP;

	my $result = system(qq(echo "$_" | apertium $direction tmpin_$direction tmpout_$direction));
	
	local $/ = undef;
	open TMP, "tmpout_$direction" or die $!;
	binmode(TMP,':utf8');
	my $result = <TMP>;
	close TMP;
	
	my @words = split /\s+/, $result;
	$$total += @words;
	my @s = $result=~/(\*)/g; $$star_total += @s;
	my @a = $result=~/(@)/g; $$at_total += @a;
	my @r = $result=~/(#)/g; $$hash_total += @r;
	
	return ($total, $star_total, $at_total, $hash_total);
}

sub format_runtime {
	my ($s) = @_;
	my ($h, $m);
	
	$h = int($s/(60*60));
	$s -= $h*60*60;
	
	$m = sprintf('%02d', int($s/60));
	$s-= $m*60;
	
	$s = sprintf('%02d', $s);
	
	return ($h,$m,$s);
}
