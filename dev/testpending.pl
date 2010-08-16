#! /usr/bin/perl
use utf8;
use strict;

my ($do_tag, $do_reverse, $print_cmd, $print_expected);

$do_tag = 1;
$do_reverse = 1;
$print_cmd = 1;
$print_expected = 1;

# assuming this file lives in the dev folder, we can determine where
# the modes folder is and where to put the log file
my ($modes_folder, $log_folder);
($log_folder = $0)=~s:[/\\]?[^/\\]+$::;
# if we're in the dev folder, use the parent folder for modes
if ($log_folder eq '.' or not $log_folder) {
	$modes_folder = '..';
}
else {
	# we're probably somewhere above the dev folder, so strip the dev folder
	($modes_folder = $log_folder)=~s:[/\\]?dev$::;
	$modes_folder ||= '.';
	# if we're somewhere below the dev folder, go up one level
	if ($modes_folder eq $log_folder) {
		$modes_folder .= '/..';
	}
}

my @tests = (
#	direction	source						target

# on <> reflexive
	'fr-pt',	'On ne parle pas',			'Não se fala',
	
# identical first/third person forms (unfixed)
	'pt-fr',	'João queria',				'João voulait',
	'pt-fr',	'Ele queria',				'Il voulait',
	'pt-fr',	'Eu queria',				'Je voulais',

# en/em
	'fr-pt',	'en ville',					'na cidade',
	'fr-pt',	'en France',				'em França',
	'fr-pt',	'en France',				'na França',

# empty entry to stop processing
#	'',	'',	'',
	
# move completed items down here instead of deleting them
# (we leave them for regression testing)

# ordinary transfer
	'pt-fr',	'o gato branco',			'le chat blanc',
	
# gender mismatch
	'pt-fr',	'uma advertência',			'un avertissement',

# adjective movement
	'pt-fr',	'uma advertência grande',	'un grand avertissement',
	'pt-fr',	'um cavalo velho',			'un vieux cheval',
	
# pre-vocalic forms
	'pt-fr',	'uma advertência nova',		'un nouvel avertissement',
	'pt-fr',	'uma advertência velha',	'un vieil avertissement',
	'pt-fr',	'uma advertência bela',		'un bel avertissement',

# tanto/quanto <> autant/que; tão/quanto <> aussi/que
	'pt-fr',	'tanto chá quanto você',	'autant de thé que vous',	# ordinary pronoun
	'pt-fr',	'tantas casas quanto João',	'autant de maisons que João',	# noun
	'pt-fr',	'tantos cavalos quanto eu',	'autant de chevaux que moi',	# 1ps
	'pt-fr',	'tanta água quanto tu',		'autant d\'eau que toi',	# 2ps
	'pt-fr',	'tão brancas quanto nós',	'aussi blanches que nous',	# ordinary pronoun
	'pt-fr',	'tão pequena quanto Sara',	'aussi petite que Sara',	# noun
	'pt-fr',	'tão alto quanto ele',		'aussi haut que lui',	# 3ps
	'pt-fr',	'tão pobre quanto eles',	'aussi pauvre qu\'eux',	# 3pp

# possessive pronouns
	'fr-pt',	'le vôtre',					'o vosso',
	'fr-pt',	'du vôtre',					'do vosso',
	'fr-pt',	'au vôtre',					'ao vosso',

# duplicated pronouns
	'pt-fr',	'João quer',				'João veut',
	'pt-fr',	'Ele quer',					'Il veut',
	'pt-fr',	'Eu quero',					'Je veux',

# il vs ce
	'pt-fr',	'É grande',					"C'est grand",
	'pt-fr',	'Ele é grande',				'Il est grand',
	'pt-fr',	'Come',						'Il mange',
	'pt-fr',	'Ele come',					'Il mange',

# demonstratives (fr-pt plurals not working yet)
	'pt-fr',	'esse gato',				'ce chat',
	'pt-fr',	'este gato',				'ce chat-ci',
	'pt-fr',	'aquele gato',				'ce chat-là',

# clitic placement/recognition
	'pt-fr',	'O farei',					'Je le ferai',
	'pt-fr',	'Eu o farei',				'Je le ferai',
);

open LOG, ">$log_folder/testpending.txt";
binmode(LOG,':utf8');
select LOG;
$| = 1;
select STDOUT;

while (@tests) {
	my $direction = shift @tests or last;
	my $source = shift @tests;
	my $target = shift @tests;
	
	if ($print_expected) {
		my $cmd = qq(echo "$source > $target");
		do_cmd($cmd);
	}
	if ($do_tag) {
		my $cmd = qq(echo "$source" | apertium -d $modes_folder $direction-tagger);
		do_cmd($cmd);
	}
	my $cmd = qq(echo "$source" | apertium $direction);
	do_cmd($cmd);
	print "\n";
	print LOG "\n";
	
	next unless $do_reverse;
	
	(my $reverse = $direction)=~s/(.+)-(.+)/$2-$1/;
	
	if ($print_expected) {
		my $cmd = qq(echo "$target > $source");
		do_cmd($cmd);
	}
	if ($do_tag) {
		my $cmd = qq(echo "$target" | apertium -d $modes_folder $reverse-tagger);
		do_cmd($cmd);
	}
	my $cmd = qq(echo "$target" | apertium $reverse);
	do_cmd($cmd);
	print "\n";
	print LOG "\n";
}

close LOG;
unlink 'tmp' if ($^O eq 'cygwin');

sub do_cmd {
	my ($cmd) = @_;
	my $result;
	if ($^O eq 'cygwin') {
		# something wrong with backticks on cygwin (?), so use temp file
		$result = system(qq($cmd > tmp));
		local $/ = undef;
		open TMP, 'tmp' or die $!;
		binmode(TMP,':utf8');
		$result = <TMP>;
		close TMP;
	}
	else {
		$result = `$cmd`;
	}
	print $cmd,"\n";
	print LOG $cmd,"\n";
	print $result,"\n";
	print LOG $result,"\n";
}
