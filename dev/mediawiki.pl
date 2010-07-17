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

exit;

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
NOTFOUND:pt:Albiol
NOTFOUND:pt:Bragance
289159	^Candelaria<np><ant>$    --------->  ^@Candelaria<np><ant>$    --------->  \@Candelaria\<np\>\<ant\> ~.
<e>       <p><l>Candelaria (Santa Cruz de T�n�rife)<s n="np"/></l><r>Candelaria<s n="np"/></r></p></e>
NOTFOUND:pt:Carri�n
NOTFOUND:pt:Chamorro
NOTFOUND:pt:Ernest
NOTFOUND:pt:Galil�e
NOTFOUND:pt:Horace
NOTFOUND:pt:Iris
NOTFOUND:pt:Lucia
NOTFOUND:pt:Natalia
289476	^Nature<np><al>$    --------->  ^@Nature<np><al>$    --------->  \@Nature\<np\>\<al\> ~.
<e>       <p><l>Nature (revue)<s n="np"/></l>          <r>Nature<s n="np"/></r></p></e>
NOTFOUND:pt:Osasuna
289531	^Ponce<np><ant>$    --------->  ^@Ponce<np><ant>$    --------->  \@Ponce\<np\>\<ant\> ~.
<e>       <p><l>Ponce (Porto Rico)<s n="np"/></l>      <r>Ponce<s n="np"/></r></p></e>
289533	^Pont<np><al>$    --------->  ^@Pont<np><al>$    --------->  \@Pont\<np\>\<al\> ~.
<e>       <p><l>Pont (C�te-d'Or)<s n="np"/></l>        <r>Pont<s n="np"/></r></p></e>
NOTFOUND:pt:P�n�lope
NOTFOUND:pt:Satan
NOTFOUND:pt:Trias
NOTFOUND:pt:Virginia
NOTFOUND:pt:Beno�t XVI
NOTFOUND:pt:Dominique
NOTFOUND:pt:Philippe
NOTFOUND:pt:Abdallah
NOTFOUND:pt:Agn�s
NOTFOUND:pt:Al-Qaida
NOTFOUND:pt:Angela
NOTFOUND:pt:Apple
289732	^Arnaud<np><ant>$    --------->  ^@Arnaud<np><ant>$    --------->  \@Arnaud\<np\>\<ant\> ~.
<e>       <p><l>Arnaud (Ha�ti)<s n="np"/></l>          <r>Arnaud<s n="np"/></r></p></e>
NOTFOUND:pt:Augustin
NOTFOUND:pt:Beno�t
289768	^Berry<np><ant>$    --------->  ^@Berry<np><ant>$    --------->  \@Berry\<np\>\<ant\> ~.
<e>       <p><l>Berri<s n="np"/></l>                   <r>Berry<s n="np"/></r></p></e>
NOTFOUND:pt:Bild
NOTFOUND:pt:Breton
289821	^Christophe<np><ant>$    --------->  ^@Christophe<np><ant>$    --------->  \@Christophe\<np\>\<ant\> ~.
<e>       <p><l>Christophe (chanteur)<s n="np"/></l>   <r>Christophe<s n="np"/></r></p></e>
NOTFOUND:pt:Cl�ment
NOTFOUND:pt:Constance
NOTFOUND:pt:Copenhague
NOTFOUND:pt:Coran
NOTFOUND:pt:Corinne
NOTFOUND:pt:Darfour
NOTFOUND:pt:Djihad
NOTFOUND:pt:Dunkerque
289924	^Florence<np><ant>$    --------->  ^@Florence<np><ant>$    --------->  \@Florence\<np\>\<ant\> ~.
<e>       <p><l>Florence (homonymie)<s n="np"/></l>    <r>Florence<s n="np"/></r></p></e>
NOTFOUND:pt:Gaumont
NOTFOUND:pt:Hallyday
NOTFOUND:pt:Hezbollah
NOTFOUND:pt:Intel
NOTFOUND:pt:Jacob
NOTFOUND:pt:J�r�me
NOTFOUND:pt:Jos�phine
NOTFOUND:pt:Julien
NOTFOUND:pt:L�nine
NOTFOUND:pt:L�o
NOTFOUND:pt:L�onard
NOTFOUND:pt:L�opold
NOTFOUND:pt:Marie-Antoinette
NOTFOUND:pt:Mikha�l
NOTFOUND:pt:P�ques
NOTFOUND:pt:Rapha�l
NOTFOUND:pt:Roland
NOTFOUND:pt:Serge
NOTFOUND:pt:Shoah
NOTFOUND:pt:Soyouz
NOTFOUND:pt:T�l�thon
NOTFOUND:pt:Tintin
290395	^Toussaint<np><al>$    --------->  ^@Toussaint<np><al>$    --------->  \@Toussaint\<np\>\<al\> ~.
<e>       <p><l>Toussaint (Seine-Maritime)<s n="np"/></l><r>Toussaint<s n="np"/></r></p></e>
NOTFOUND:pt:Tsahal
NOTFOUND:pt:Willy
NOTFOUND:pt:Amstel
NOTFOUND:pt:Hannibal Barca
NOTFOUND:pt:Ankaraspor
NOTFOUND:pt:Chanel
NOTFOUND:pt:Aquarium
NOTFOUND:pt:Achille
NOTFOUND:pt:Grand Schisme d'Occident
NOTFOUND:pt:Colonnes d'Hercule
NOTFOUND:pt:mer Baltique
NOTFOUND:pt:Catherine d'Aragon
NOTFOUND:pt:mer Adriatique
NOTFOUND:pt:Parti social-d�mocrate d'Allemagne
NOTFOUND:pt:Union europ�enne
NOTFOUND:pt:D�claration universelle des droits de l'homme
NOTFOUND:pt:Organisation des Nations unies
NOTFOUND:pt:Conseil de s�curit� des Nations unies
NOTFOUND:pt:Bible
NOTFOUND:pt:Jean Cabot
NOTFOUND:pt:Ca�phe
NOTFOUND:pt:Ca�n
NOTFOUND:pt:Jean Calvin
NOTFOUND:pt:Chambre des Lords
NOTFOUND:pt:Cambyse II
NOTFOUND:pt:Chanson de Roland
NOTFOUND:pt:Chapelle Sixtine
NOTFOUND:pt:Carloman
NOTFOUND:pt:Charles Martel
NOTFOUND:pt:Maison Blanche
NOTFOUND:pt:Cassandre
NOTFOUND:pt:Cassiop�e
NOTFOUND:pt:Catherine de M�dicis
NOTFOUND:pt:Jules C�sar
NOTFOUND:pt:Organisation mondiale du tourisme
NOTFOUND:pt:prince des Asturies
NOTFOUND:pt:Rois mages
NOTFOUND:pt:Gueorgui Parvanov
NOTFOUND:pt:Tassos Papadopoulos
NOTFOUND:pt:Mikheil Saakachvili
NOTFOUND:pt:K�rolos Papo�lias
NOTFOUND:pt:Lech
NOTFOUND:pt:Vladimir Poutine
NOTFOUND:pt:Viktor Iouchtchenko
NOTFOUND:pt:Mikha�l Gorbatchev
NOTFOUND:pt:Nicanor Duarte Frutos
NOTFOUND:pt:Robert Kotcharian
NOTFOUND:pt:Kalkot Matas Kelekele
NOTFOUND:pt:Miguel �ngel Revilla Roiz
NOTFOUND:pt:Oc�anie
NOTFOUND:pt:Atl�tico de Madrid
NOTFOUND:pt:Real Sociedad
NOTFOUND:pt:Fabian
NOTFOUND:pt:Standard
NOTFOUND:pt:Athletic Bilbao
NOTFOUND:pt:Sandy
291122	^Boomerang<np><al>$    --------->  ^@Boomerang<np><al>$    --------->  \@Boomerang\<np\>\<al\> ~.
<e>       <p><l>Boomerang (cha�ne de t�l�vision)<s n="np"/></l><r>Boomerang<s n="np"/></r></p></e>
291133	^Jason<np><ant>$    --------->  ^@Jason<np><ant>$    --------->  \@Jason\<np\>\<ant\> ~.
<e>       <p><l>Jason (homonymie)<s n="np"/></l>       <r>Jason<s n="np"/></r></p></e>
NOTFOUND:pt:Giuliana
NOTFOUND:pt:Recreativo de Huelva
NOTFOUND:pt:Cyrille
291342	^Montgomery<np><ant>$    --------->  ^@Montgomery<np><ant>$    --------->  \@Montgomery\<np\>\<ant\> ~.
<e>       <p><l>Montgomery (homonymie)<s n="np"/></l>  <r>Montgomery<s n="np"/></r></p></e>
NOTFOUND:pt:Celestino
NOTFOUND:pt:Valira
291438	^Ag�ero<np><ant>$    --------->  ^@Ag�ero<np><ant>$    --------->  \@Ag�ero\<np\>\<ant\> ~.
<e>       <p><l>Aguero<s n="np"/></l>                  <r>Ag�ero<s n="np"/></r></p></e>
NOTFOUND:pt:dala�-lama
NOTFOUND:pt:Reporting
NOTFOUND:pt:Casse-Noisette
NOTFOUND:pt:Rodolphe
NOTFOUND:pt:Kim Jong-il
NOTFOUND:pt:Accent
291501	^Bandeira<np><ant>$    --------->  ^@Bandeira<np><ant>$    --------->  \@Bandeira\<np\>\<ant\> ~.
<e>       <p><l>Drapeau<s n="np"/></l>                 <r>Bandeira<s n="np"/></r></p></e>
NOTFOUND:pt:Wiktionnaire
NOTFOUND:pt:Epsilon
NOTFOUND:pt:Newsletter
NOTFOUND:pt:Orph�e
291538	^Boss<np><ant>$    --------->  ^@Boss<np><ant>$    --------->  \@Boss\<np\>\<ant\> ~.
<e>       <p><l>The Boss<s n="np"/></l>                <r>Boss<s n="np"/></r></p></e>
291615	^Cooper<np><ant>$    --------->  ^@Cooper<np><ant>$    --------->  \@Cooper\<np\>\<ant\> ~.
<e>       <p><l>Jogging (sport)<s n="np"/></l>         <r>Cooper<s n="np"/></r></p></e>
NOTFOUND:pt:Hollande
NOTFOUND:pt:Danny
NOTFOUND:pt:Super Mardi
NOTFOUND:pt:Roms
NOTFOUND:pt:Ironman
NOTFOUND:pt:Zarate
NOTFOUND:pt:Jeux olympiques
NOTFOUND:pt:Caixa
NOTFOUND:pt:Journal
NOTFOUND:pt:Likoud
NOTFOUND:pt:Benyamin Netanyahou
NOTFOUND:pt:Chambre des d�put�s
291858	^Tour de France<np><al>$    --------->  ^@Tour de France<np><al>$    --------->  \@Tour de France\<np\>\<al\> ~.
<e>       <p><l>Tour de France (cyclisme)<s n="np"/></l><r>Tour de France<s n="np"/></r></p></e>
NOTFOUND:pt:Tour d'Espagne
NOTFOUND:pt:Belz�buth
NOTFOUND:pt:Bo�ce
NOTFOUND:pt:p�lerinage de Saint-Jacques-de-Compostelle
NOTFOUND:pt:Capricorne
NOTFOUND:pt:Cyb�le
NOTFOUND:pt:Cic�ron
NOTFOUND:pt:guerre de Cent Ans
NOTFOUND:pt:Cyrus
NOTFOUND:pt:Cyrus le Jeune
NOTFOUND:pt:Cl�op�tre
NOTFOUND:pt:Colis�e
NOTFOUND:pt:Christophe Colomb
NOTFOUND:pt:Confucius
NOTFOUND:pt:Contre-R�forme
NOTFOUND:pt:Nicolas Copernic
NOTFOUND:pt:Real Madrid
NOTFOUND:pt:Pierre de Cortone
NOTFOUND:pt:Crassus
NOTFOUND:pt:Cupidon
NOTFOUND:pt:D�dale
NOTFOUND:pt:D�mocrite
NOTFOUND:pt:D�mosth�ne
NOTFOUND:pt:Diocl�tien
NOTFOUND:pt:Dracula
NOTFOUND:pt:Alexandre Dumas
NOTFOUND:pt:Le Cuirass� Potemkine
NOTFOUND:pt:Ennius
NOTFOUND:pt:Henri le Navigateur
NOTFOUND:pt:Erik le Rouge
NOTFOUND:pt:Jean Scot �rig�ne
291952	^Spartacus<np><ant>$    --------->  ^@Spartacus<np><ant>$    --------->  \@Spartacus\<np\>\<ant\> ~.
<e>       <p><l>Spartacus (homonymie)<s n="np"/></l>   <r>Spartacus<s n="np"/></r></p></e>
NOTFOUND:pt:Eschyle
NOTFOUND:pt:Strabon
NOTFOUND:pt:Euclide
NOTFOUND:pt:Euripide
NOTFOUND:pt:Exode
NOTFOUND:pt:duc d'�dimbourg
NOTFOUND:pt:Ph�nix
NOTFOUND:pt:Marsile Ficin
NOTFOUND:pt:Phidias
NOTFOUND:pt:Phrynichos
NOTFOUND:pt:Mouammar Kadhafi
NOTFOUND:pt:Galat�e
291991	^Vasco da Gama<np><ant>$    --------->  ^@Vasco da Gama<np><ant>$    --------->  \@Vasco da Gama\<np\>\<ant\> ~.
<e>       <p><l>Vasco de Gama<s n="np"/></l>           <r>Vasco da Gama<s n="np"/></r></p></e>
NOTFOUND:pt:Ganym�de
NOTFOUND:pt:Guerre et Paix
NOTFOUND:pt:guerres balkaniques
NOTFOUND:pt:Guillaume Tell
NOTFOUND:pt:H�racl�s
NOTFOUND:pt:H�raclide du Pont
NOTFOUND:pt:H�raclite
NOTFOUND:pt:H�rode
NOTFOUND:pt:H�rodote
NOTFOUND:pt:Hippocrate
NOTFOUND:pt:Hom�re
NOTFOUND:pt:Icare
NOTFOUND:pt:Iphig�nie
NOTFOUND:pt:Iliade
NOTFOUND:pt:L�gion d'honneur
NOTFOUND:pt:Inquisition
NOTFOUND:pt:Isocrate
NOTFOUND:pt:X�nophane
NOTFOUND:pt:X�nophon
NOTFOUND:pt:Xerx�s
NOTFOUND:pt:Jupiter
NOTFOUND:pt:Kh�ops
NOTFOUND:pt:Laocoon
NOTFOUND:pt:Longue Marche
NOTFOUND:pt:Lion
NOTFOUND:pt:L�onard de Vinci
NOTFOUND:pt:L�pide
NOTFOUND:pt:Leucippe
NOTFOUND:pt:Lysandre
NOTFOUND:pt:Lysimaque
NOTFOUND:pt:Lothaire
NOTFOUND:pt:Lucain
292069	^Martin Luther<np><ant>$    --------->  ^@Martin Luther<np><ant>$    --------->  \@Martin Luther\<np\>\<ant\> ~.
<e>       <p><l>Martin Luther (homonymie)<s n="np"/></l><r>Martin Luther<s n="np"/></r></p></e>
292072	^Magellan<np><ant>$    --------->  ^@Magellan<np><ant>$    --------->  \@Magellan\<np\>\<ant\> ~.
<e>       <p><l>Magellan (sonde spatiale)<s n="np"/></l><r>Magellan<s n="np"/></r></p></e>
NOTFOUND:pt:Fernand de Magellan
NOTFOUND:pt:nuages de Magellan
NOTFOUND:pt:Mao Zedong
NOTFOUND:pt:Nicolas Machiavel
NOTFOUND:pt:Mathusalem
NOTFOUND:pt:M�d�e
NOTFOUND:pt:guerres m�diques
NOTFOUND:pt:M�duse
292089	^Mercure<np><ant>$    --------->  ^@Mercure<np><ant>$    --------->  \@Mercure\<np\>\<ant\> ~.
<e>       <p><l>Mercure (entreprise)<s n="np"/></l>    <r>Mercure<s n="np"/></r></p></e>
NOTFOUND:pt:Messie
NOTFOUND:pt:Bachar el-Assad
NOTFOUND:pt:Morph�e
NOTFOUND:pt:N�fertari
NOTFOUND:pt:N�fertiti
NOTFOUND:pt:Normandie
NOTFOUND:pt:Odyss�e
NOTFOUND:pt:Aristote Onassis
NOTFOUND:pt:palais des Tuileries
NOTFOUND:pt:P�ricl�s
NOTFOUND:pt:Pers�phone
NOTFOUND:pt:Pers�e
NOTFOUND:pt:Ponce Pilate
NOTFOUND:pt:P�pin le Bref
NOTFOUND:pt:Pythagore
NOTFOUND:pt:Plaute
NOTFOUND:pt:Pline
NOTFOUND:pt:Pline le Jeune
NOTFOUND:pt:Pline l'Ancien
NOTFOUND:pt:Plutarque
NOTFOUND:pt:Pomone
NOTFOUND:pt:Pomp�i
NOTFOUND:pt:Pomp�e
NOTFOUND:pt:Premi�re Guerre mondiale
NOTFOUND:pt:guerres puniques
NOTFOUND:pt:Raspoutine
NOTFOUND:pt:Anouar el-Sadate
NOTFOUND:pt:route de la soie
NOTFOUND:pt:Culture
NOTFOUND:pt:Seconde Guerre mondiale
NOTFOUND:pt:Sisyphe
NOTFOUND:pt:Sophocle
NOTFOUND:pt:Thal�s
NOTFOUND:pt:T�l�maque
NOTFOUND:pt:M�re Teresa
292200	^Th�s�e<np><ant>$    --------->  ^@Th�s�e<np><ant>$    --------->  \@Th�s�e\<np\>\<ant\> ~.
<e>       <p><l>Th�s�e (Loir-et-Cher)<s n="np"/></l>   <r>Th�s�e<s n="np"/></r></p></e>
NOTFOUND:pt:Titien
NOTFOUND:pt:Ptol�m�e
NOTFOUND:pt:Torah
NOTFOUND:pt:Trajan
NOTFOUND:pt:Vespasien
NOTFOUND:pt:Virgile
NOTFOUND:pt:Vulcain
NOTFOUND:pt:Jugurtha
NOTFOUND:pt:Kim Ki-duk
NOTFOUND:pt:Joseph Staline
NOTFOUND:pt:Adige
NOTFOUND:pt:Ainsi parlait Zarathoustra
NOTFOUND:pt:Alexa
NOTFOUND:pt:Almageste
292284	^Alpha<np><al>$    --------->  ^@Alpha<np><al>$    --------->  \@Alpha\<np\>\<al\> ~.
<e>       <p><l>Alpha (homonymie)<s n="np"/></l>       <r>Alpha<s n="np"/></r></p></e>
292285	^Alpine<np><al>$    --------->  ^@Alpine<np><al>$    --------->  \@Alpine\<np\>\<al\> ~.
<e>       <p><l>Alpine Renault<s n="np"/></l>          <r>Alpine<s n="np"/></r></p></e>
NOTFOUND:pt:Ancien R�gime
NOTFOUND:pt:Arlequin
NOTFOUND:pt:bataille d'Actium
NOTFOUND:pt:bataille d'Austerlitz
NOTFOUND:pt:Discovery
NOTFOUND:pt:Invincible Armada
NOTFOUND:pt:si�cle des Lumi�res
NOTFOUND:pt:tour de Babel
NOTFOUND:pt:Abd�lhamid II
NOTFOUND:pt:Abraham
NOTFOUND:pt:Absalom
292373	^Adriano<np><ant>$    --------->  ^@Adriano<np><ant>$    --------->  \@Adriano\<np\>\<ant\> ~.
<e>       <p><l>Hadrien<s n="np"/></l>                 <r>Adriano<s n="np"/></r></p></e>
NOTFOUND:pt:Ag�nor
NOTFOUND:pt:Agricola
292478	^Akira<np><ant>$    --------->  ^@Akira<np><ant>$    --------->  \@Akira\<np\>\<ant\> ~.
<e>       <p><l>Akira (manga)<s n="np"/></l>           <r>Akira<s n="np"/></r></p></e>
292479	^Akita<np><ant>$    --------->  ^@Akita<np><ant>$    --------->  \@Akita\<np\>\<ant\> ~.
<e>       <p><l>Pr�fecture d'Akita<s n="np"/></l>      <r>Akita<s n="np"/></r></p></e>
NOTFOUND:pt:Albert Ier de Monaco
NOTFOUND:pt:Alcam�ne
NOTFOUND:pt:Alc�e
NOTFOUND:pt:Alexandre le Grand
NOTFOUND:pt:Alive
NOTFOUND:pt:Allah
NOTFOUND:pt:Almer�a
NOTFOUND:pt:Almodovar
NOTFOUND:pt:Alphonse
292614	^Amadeus<np><ant>$    --------->  ^@Amadeus<np><ant>$    --------->  \@Amadeus\<np\>\<ant\> ~.
<e>       <p><l>Amadeus (film)<s n="np"/></l>          <r>Amadeus<s n="np"/></r></p></e>
NOTFOUND:pt:Amaro
NOTFOUND:pt:Anaclet
NOTFOUND:pt:Anacr�on
NOTFOUND:pt:Anatolie
292639	^Angel<np><ant>$    --------->  ^@Angel<np><ant>$    --------->  \@Angel\<np\>\<ant\> ~.
<e>       <p><l>Angel (s�rie t�l�vis�e)<s n="np"/></l> <r>Angel<s n="np"/></r></p></e>
NOTFOUND:pt:Anne Boleyn
NOTFOUND:pt:Anne d'Autriche
292648	^Aphrodite<np><ant>$    --------->  ^@Aphrodite<np><ant>$    --------->  \@Aphrodite\<np\>\<ant\> ~.
<e>       <p><l>Aphrodite (Kylie Minogue)<s n="np"/></l><r>Aphrodite<s n="np"/></r></p></e>
NOTFOUND:pt:Ast�rix
NOTFOUND:pt:Averro�s
NOTFOUND:pt:Avicenne
NOTFOUND:pt:Bacchus
NOTFOUND:pt:Diego de Almagro
NOTFOUND:pt:Gari
NOTFOUND:pt:Golfe d'Anadyr
NOTFOUND:pt:Ibn Khaldoun
NOTFOUND:pt:Ion
NOTFOUND:pt:Mikha�l Aleksandrovitch Bakounine
NOTFOUND:pt:Mustafa Kemal Atat�rk
292786	^Nicanor<np><ant>$    --------->  ^@Nicanor<np><ant>$    --------->  \@Nicanor\<np\>\<ant\> ~.
<e>       <p><l>Nicanor (g�n�ral de D�m�trios)<s n="np"/></l><r>Nicanor<s n="np"/></r></p></e>
NOTFOUND:pt:Pierre Ab�lard
NOTFOUND:pt:Tiago
NOTFOUND:pt:Sagem
NOTFOUND:pt:Seat
NOTFOUND:pt:Ikea
NOTFOUND:pt:Euskadi ta Askatasuna

