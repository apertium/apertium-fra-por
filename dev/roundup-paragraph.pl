#! /usr/bin/perl
use utf8;
use strict;

my $fr_para = qq(Une encyclopédie est un ouvrage couvrant l'ensemble des champs du savoir ou des connaissances, ou une partie déterminée de ceux-ci. Sa conception repose sur une organisation du savoir, qu'il s'agisse d'une classification thématique, alphabétique ou tout autre mode classificatoire permettant au chercheur d'information de se repérer dans l'ensemble des données. Plusieurs types d'organisation peuvent également être utilisés de façon croisée.);

my $pt_para = qq(
Enciclopédia é uma coletânea de escritos em larga escala, cujo objetivo principal é descrever o mais aproximado possível o relativo à concepção atual do conhecimento humano. Mais especificado, pode-se definir como uma obra que trata de todas as ciências e artes que é concedida em um máximo limite do conhecimento do homem atual. Comumente é interpretada através de um livro de referência para praticamente qualquer assunto do domínio humano. Porém, nos dias atuais, as enciclopédias podem ser redigidas de maneiras alternativas, como por exemplo, na internet.);

binmode(STDOUT,':utf8');

process_chunk('fr-pt', $fr_para);
process_chunk('pt-fr', $pt_para);

sub process_chunk {
	my ($direction, $chunk) = @_;
	
#	my $result = `echo "$_" | apertium $direction`;
	# fix: something wrong with backticks on cygwin (?), so use temp file
		my $result = system(qq(echo "$chunk" | apertium $direction > tmp));
		local $/ = undef;
		open TMP, 'tmp' or die $!;
		binmode(TMP,':utf8');
		my $result = <TMP>;
		close TMP;
	# end of fix
	
	
	print <<REPORT;
$chunk

$result

REPORT
}
