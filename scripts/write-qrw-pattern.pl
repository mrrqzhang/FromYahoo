while(<>) {
  chomp() ;
  my @fields = split /\t/ ;
  my @term1 = split / /, $fields[0] ;
  my @term2 = split / /, $fields[1] ;


#### split join ####
  my $merge1 = join "",@term1 ;
  my $merge2 = join "", @term2 ;
#  if("$merge1" eq "$merge2") {print "$_\n" ;}

  
#### abbr ####
  if($#term1==0) { 
        my $abbr="" ;
	for(my$i=0;$i<=$#term2;$i++) {
		my $a = substr($term2[$i],0,1) ;
		$abbr="$abbr$a" ;
        }
  #      print "$_ ### $abbr\n" ;
        if($term1[0] eq $abbr) {print "$_\n" ;}
   }
   if($#term2==0) {
        my $abbr="" ;

        for(my$i=0;$i<=$#term1;$i++) {
                my $a = substr($term1[$i],0,1) ;
                $abbr="$abbr$a" ;
        }
 
        if($term2[0] eq $abbr) {print "$_\n" ;}
   }




}
