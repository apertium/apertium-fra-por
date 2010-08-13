use strict;
use MediaWiki::API;
use Time::HiRes qw(usleep);

$| = 1;

#my $cat = 'n';
my $cat = 'np';

#my $source = 'fr'; my $target = 'pt';
my $source = 'pt'; my $target = 'fr';
my $bidixdir = 'frpt';
my $dir = $source.$target;

my $infile = $dir . 'inconsistency.txt';
my $outfile = $dir . 'wiki.txt';

my $wiki = MediaWiki::API->new({
	api_url => "http://$source.wikipedia.org/w/api.php"
});

my %notfound;
while (<DATA>) {
	chomp;
	next unless s/^NOTFOUND:$source://;
	if ($notfound{$_}) {
		warn "Duplicate notfound: $_\n";
		next;
	}
	$notfound{$_} = 1;
#	print "NOTFOUND:$source:$_\n";
}

#exit;

my (%seen_mono, %seen_bi);
open IN, $infile or die "Unable to open file '$infile': $!";
binmode(IN,':utf8');
open OUT, ">$outfile" or die "Unable to create file '$outfile': $!";
binmode(OUT,':utf8');
while (<IN>) {
	next unless m:<$cat>:;	# only get lines that have our category
	next if /REGEX/;	# skip lines containing 'REGEX'
	next unless /@/;	# only get lines with bidix errors

	my ($w) = /\^(.+?)\$/;
	$w=~s/<.+?>//g;
	
	next if $notfound{$w};

	my @t = get_translation($w);
	for my $t (@t) {
		my ($os1,$os2);
		if ($dir eq $bidixdir) {
			($os1,$os2) = ($w,$t);
		}
		else {
			($os1,$os2) = ($t,$w);
		}
		for ($os1,$os2) {
			$_ .= qq(<s n="$cat"/>);
		}
		
		print OUT qq($.\t$_);
		if (length($os1) >= 35) {
			if ($cat eq 'np') {
				print OUT qq(<e>       <p><l>$os1</l><r>$os2</r></p></e>\n);
			}
			else {
				print OUT lc(qq(<e>       <p><l>$os1</l><r>$os2</r></p></e>\n));
			}
		}
		else {
			print OUT "<e>       <p>";
			if ($cat eq 'np') {
				print OUT pack('A42', qq(<l>$os1</l>));
				print OUT qq(<r>$os2</r></p></e>\n);
			}
			else {
				print OUT lc(pack('A42', qq(<l>$os1</l>)));
				print OUT lc(qq(<r>$os2</r></p></e>\n));
			}
		}
	}
}

sub get_translation {
	my ($title, $continue) = @_;
	my $query = {
		action => 'query',
		titles => $title,
		prop => 'langlinks',
		lllimit => 500,
	};
	if ($continue) {
		$query->{llcontinue} = $continue;
	}
	
	my $titles = $wiki->api($query, { skip_encoding => 1 })
		or warn $wiki->{error}->{code} . ': ' . $wiki->{error}->{details}
		and next;

	my ($pageid,$langlinks) = each ( %{ $titles->{query}->{pages} } );

	my @ret;
	for my $link (@{ $langlinks->{langlinks} }) {
		my $lang = $link->{lang};
		next unless ($lang eq $target);
		my $wt = $link->{'*'};
		push @ret, $wt;
	}
#	usleep(500);	# wait a bit to avoid strain on Mediawiki servers
	
	if (my $cont = $titles->{'query-continue'}{langlinks}{llcontinue}) {
		push @ret, get_translation($title, $cont);
	}
	
	@ret or print OUT "NOTFOUND:$source:$title\n";
	@ret;
}

close IN;
close OUT;

__DATA__
NOTFOUND:fr:analytique
NOTFOUND:fr:arch�ozoologue
NOTFOUND:fr:ascari
NOTFOUND:fr:attelage
NOTFOUND:fr:bovin
NOTFOUND:fr:bracco�de
NOTFOUND:fr:charognard
NOTFOUND:fr:chiot
NOTFOUND:fr:coccidie
NOTFOUND:fr:collerette
NOTFOUND:fr:comportementaliste
NOTFOUND:fr:d�jection
NOTFOUND:fr:d�mod�cie
NOTFOUND:fr:dipylidiose
NOTFOUND:fr:dirofilariose
NOTFOUND:fr:dog-sitting
NOTFOUND:fr:dressage
NOTFOUND:fr:embonpoint
NOTFOUND:fr:embranchement
NOTFOUND:fr:extermination
NOTFOUND:fr:gamelle
NOTFOUND:fr:garderie
NOTFOUND:fr:gauche
NOTFOUND:fr:giardose
NOTFOUND:fr:gra�o�de
NOTFOUND:fr:habitant
NOTFOUND:fr:handicap�
NOTFOUND:fr:homonyme
NOTFOUND:fr:infra-classe
NOTFOUND:fr:intrus
NOTFOUND:fr:lettrage
NOTFOUND:fr:livreur
NOTFOUND:fr:lupo�de
NOTFOUND:fr:marquage
NOTFOUND:fr:marronnage
NOTFOUND:fr:membrane
NOTFOUND:fr:mignon
NOTFOUND:fr:morsure
NOTFOUND:fr:nettoyage
NOTFOUND:fr:nomade
NOTFOUND:fr:officiel
NOTFOUND:fr:partenaire
NOTFOUND:fr:particulier
NOTFOUND:fr:p�t�e
NOTFOUND:fr:p�domorphisme
NOTFOUND:fr:pelleterie
NOTFOUND:fr:pinces
NOTFOUND:fr:pitbull
NOTFOUND:fr:promeneur
NOTFOUND:fr:ramassage
NOTFOUND:fr:r�glementation
NOTFOUND:fr:rongeur
NOTFOUND:fr:selle
NOTFOUND:fr:senior
NOTFOUND:fr:sous-embranchement
NOTFOUND:fr:terrier
NOTFOUND:fr:tiers
NOTFOUND:fr:toilettage
NOTFOUND:fr:trichuri
NOTFOUND:fr:vermifugation
NOTFOUND:fr:vermifuge
NOTFOUND:fr:v�t�rinaire
NOTFOUND:fr:zooth�rapie
NOTFOUND:pt:Rom�nia
NOTFOUND:pt:acompanhamento
NOTFOUND:pt:adestramento
NOTFOUND:pt:adoe�a
NOTFOUND:pt:afghan hound
NOTFOUND:pt:alcat�ia
NOTFOUND:pt:american pit bull terrier
NOTFOUND:pt:amigdala
NOTFOUND:pt:ancestral
NOTFOUND:pt:ancestralidade
NOTFOUND:pt:angula��o
NOTFOUND:pt:antepassado
NOTFOUND:pt:aparecimento
NOTFOUND:pt:aperfei�oamento
NOTFOUND:pt:apre�o
NOTFOUND:pt:aprisionamento
NOTFOUND:pt:artrologia
NOTFOUND:pt:atendado
NOTFOUND:pt:aux�lio
NOTFOUND:pt:barro
NOTFOUND:pt:basset hound
NOTFOUND:pt:bicho
NOTFOUND:pt:bloodhound
NOTFOUND:pt:border collie
NOTFOUND:pt:cachorrinho
NOTFOUND:pt:calda
NOTFOUND:pt:canalha
NOTFOUND:pt:card�pio
NOTFOUND:pt:cavalheiro
NOTFOUND:pt:choramingo
NOTFOUND:pt:citronela
NOTFOUND:pt:coleira
NOTFOUND:pt:collie
NOTFOUND:pt:collie
NOTFOUND:pt:companheirismo
NOTFOUND:pt:cria
NOTFOUND:pt:d�lmata
NOTFOUND:pt:data��o
NOTFOUND:pt:dermatofitose
NOTFOUND:pt:desambigua��o
NOTFOUND:pt:desestabiliza��o
NOTFOUND:pt:desmame
NOTFOUND:pt:detentor
NOTFOUND:pt:diabetes
NOTFOUND:pt:dinamarqu�s
NOTFOUND:pt:discord�ncia
NOTFOUND:pt:divers�o
NOTFOUND:pt:domin�ncia
NOTFOUND:pt:efermidade
NOTFOUND:pt:empilhadora
NOTFOUND:pt:equiparidade
NOTFOUND:pt:esbranqui�amento
NOTFOUND:pt:esp�dua
NOTFOUND:pt:espermatoz�ide
NOTFOUND:pt:exterm�nio
NOTFOUND:pt:farejador
NOTFOUND:pt:farejamento
NOTFOUND:pt:felino
NOTFOUND:pt:fenda
NOTFOUND:pt:filhote
NOTFOUND:pt:galope
NOTFOUND:pt:goblim
NOTFOUND:pt:golden retriever
NOTFOUND:pt:hist�ria em quadrinhos
NOTFOUND:pt:homozigose
NOTFOUND:pt:horm�nio
NOTFOUND:pt:incha�o
NOTFOUND:pt:indolor
NOTFOUND:pt:invalidez
NOTFOUND:pt:jato
NOTFOUND:pt:labrador retriever
NOTFOUND:pt:lebrel
NOTFOUND:pt:levantador
NOTFOUND:pt:lip�dio
NOTFOUND:pt:material
NOTFOUND:pt:mescla
NOTFOUND:pt:movimenta��o
NOTFOUND:pt:munheca
NOTFOUND:pt:neuroanatomista
NOTFOUND:pt:nevasca
NOTFOUND:pt:ocidentaliza��o
NOTFOUND:pt:ocorr�ncia
NOTFOUND:pt:odiss�ia
NOTFOUND:pt:ovelheiro
NOTFOUND:pt:paralel
NOTFOUND:pt:pastoreio
NOTFOUND:pt:peculiaridade
NOTFOUND:pt:pelagem
NOTFOUND:pt:peniano
NOTFOUND:pt:pioneirismo
NOTFOUND:pt:pote
NOTFOUND:pt:potencial
NOTFOUND:pt:prenhez
NOTFOUND:pt:progenitor
NOTFOUND:pt:propens�o
NOTFOUND:pt:quadrinho
NOTFOUND:pt:q�estionamento
NOTFOUND:pt:qu�mico
NOTFOUND:pt:rafeiro
NOTFOUND:pt:raso
NOTFOUND:pt:rastreador
NOTFOUND:pt:rastreio
NOTFOUND:pt:relaxamento
NOTFOUND:pt:remo��o
NOTFOUND:pt:rinha
NOTFOUND:pt:s�men
NOTFOUND:pt:shar pei
NOTFOUND:pt:shih tzu
NOTFOUND:pt:sobrepeso
NOTFOUND:pt:standard
NOTFOUND:pt:subcategoria
NOTFOUND:pt:subordem
NOTFOUND:pt:subsist�ncia
NOTFOUND:pt:superc�lio
NOTFOUND:pt:surgimento
NOTFOUND:pt:t�rtaro
NOTFOUND:pt:terrier
NOTFOUND:pt:ucraniano
NOTFOUND:pt:vagabundo
NOTFOUND:pt:vasilha
NOTFOUND:pt:visualiza��o
NOTFOUND:pt:yorkshire terrier
NOTFOUND:pt:cent�simo
NOTFOUND:fr:Pica�a
NOTFOUND:fr:Panama
NOTFOUND:fr:Pays Basque
NOTFOUND:fr:Philae
NOTFOUND:fr:p�ninsule de Kamtchatka
NOTFOUND:fr:P�trograd
NOTFOUND:fr:P�ninsule Arabique
NOTFOUND:fr:CCPA
NOTFOUND:fr:CITES
NOTFOUND:fr:CNRTL
NOTFOUND:fr:ITIS
NOTFOUND:fr:IUCN
NOTFOUND:fr:U.S.Navy
NOTFOUND:fr:Wikim�dia
NOTFOUND:fr:Berger Belge Malinois
NOTFOUND:fr:Gos d'Atura
NOTFOUND:fr:Irish Wolfhound
NOTFOUND:fr:Parson russel terrier
NOTFOUND:pt:Pineda
NOTFOUND:pt:Argyreos
NOTFOUND:pt:Bidu
NOTFOUND:pt:Bran
NOTFOUND:pt:Buhriz
NOTFOUND:pt:Chryseos
NOTFOUND:pt:Coliseu
NOTFOUND:pt:Failinis
NOTFOUND:pt:FCI
NOTFOUND:pt:G�rion
NOTFOUND:pt:Giggio
NOTFOUND:pt:Hefestos
NOTFOUND:pt:Maur�cio de Sousa
NOTFOUND:pt:Nem�ia
NOTFOUND:pt:Ortro
NOTFOUND:pt:SRD
NOTFOUND:pt:T'ien-K'uan
NOTFOUND:pt:T�fon