
while(<>) {
  chomp() ;
  my @fields = split /@/ ;
  my @fields2 = split /,/, $fields[1] ;
  for(my $i=0; $i<=$#fields2; $i++) {
    print "source-$fields2[$i]-$fields[0]\n" ;
  }
}
