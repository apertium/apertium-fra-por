use strict;
use utf8;
use MediaWiki::API;

# for testing
@ARGV = qw(fr Chien pt Cão);

my %wiki;

@ARGV and $#ARGV % 2 or die <<USAGE;
getsample.pl LANG PAGE [LANG PAGE [LANG PAGE ...]]
USAGE

for (my $i = 0; $i<@ARGV; $i+=2) {
	my $lang = $ARGV[$i];
	my $page = $ARGV[$i+1];
warn "Getting sample $page for $lang\n";
	get_sample($lang, $page);
}

sub get_sample {
	my ($lang, $page) = @_;
	my $wiki = get_wiki($lang);
	
	my $query = {
		action => 'parse',
		page   => $page,
		prop   => 'text',
	};
	my $result = $wiki->api($query, { skip_encoding => 1 })
			or warn $wiki->{error}->{code} . ': ' . $wiki->{error}->{details}
			and return;

	my $text = $result->{parse}{text}{'*'};
	$text=~s:<img.+?>:[IMG]:gs;
	$text=~s:<.+?>::gs;
	$text=~s:&#160;: :g;	# non-breaking space
	$text=~s:&#(\d+);:chr($1):ge;
	$text=~s/&lt;/</g;
	$text=~s/&gt;/>/g;
	$text=~s/&amp;/&/g;
	$text=~s/(\r?\n)+/$1/g;
	
	open OUT, ">sample.$page.$lang" or die "Unable to create sample $page for $lang: $!";
	binmode(OUT,':utf8');
	print OUT $text;
	close OUT;
}

sub get_wiki {
	my ($lang) = @_;
	unless ($wiki{$lang}) {
warn "Creating wiki for $lang\n";
		$wiki{$lang} = MediaWiki::API->new({
			api_url => "http://$lang.wikipedia.org/w/api.php"
		});
	}
	return $wiki{$lang};
}
