while(<>) {
  chomp() ;
  my @fields = split /\t/ ;
  my @query = split / /, $fields[2] ;
  my @label = split / /, $fields[3] ;
  if($#query == $#label ) {
     print "$_\n" ;
  }
}
