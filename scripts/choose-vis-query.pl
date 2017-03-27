
my %querycount=() ;
my @queryall=() ;

my $num=0 ;
while(<>) {
	chomp() ;
	my @fields = split '\t' ;
	$queryall[$num] = $_ ;
	my $key = "$fields[0]\t$fields[1]" ;
	$querycount{$key} += $fields[3] ;
	$num++ ;
}

for(my $i=0; $i<$num; $i++) {
	my $line = $queryall[$i] ;
	my @fields = split '\t', $line ;
	my $key = "$fields[0]\t$fields[1]" ;
	if(defined $querycount{$key} && $querycount{$key}>=30) {
		print "$line\n" ;
	}
}
	

