
while(<>) {
  chomp() ;
  my @fields = split /\t/ ;
  my $query = $fields[2] ;
  my $interp = $fields[3] ;
  my @queryarr = split / /,$query ; 
  my @interparr = split / /, $interp ;
#  print "$interp\n" ;
  print "gilad\t$query\tdummy\tautoscore: 4\t" ;
  for(my $i=0; $i<$#queryarr; $i++) {
	if($interparr[$i]=~/token/) {
	   print "$queryarr[$i]\ttoken\t" ;
        }
	if($interparr[$i]=~/B-/ || $interparr[$i]=~/I-/) {
		if($interparr[$i+1]!~/I-/){
			my $tmp = substr($interparr[$i],2) ;
			print "$queryarr[$i]\t$tmp\t" ;
		}
		else {print "$queryarr[$i] ";}
	}
  }	
  my $last = $queryarr[$#queryarr] ;
  my $tmp = $interparr[$#interparr] ;
  if($tmp=~/B-/ || $tmp=~/I-/) { $tmp = substr($interparr[$#interparr],2) ;}
  print "$last\t$tmp\n" ;
}
	
	
