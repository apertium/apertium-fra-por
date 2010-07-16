open IN, '../apertium-fr-pt.pt.dix' or die $!;
while (<IN>) {
	next if ($. < 152858 or $. > 153124);
	chomp;
	if (not /\S/) {
		print "\n";
		next;
	}
	my ($root, $type_start, $type_end) = m:<e><i>(.+?)</i><par n="(.+?)/(.+?)__vblex"/></e>:;
	print qq(    <e lm="$root$type_end"><i>$root</i><par n="$type_start/${type_end}__vblex"/></e>\n);

}