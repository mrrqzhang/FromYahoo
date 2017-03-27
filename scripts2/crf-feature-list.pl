
open KB, "<kbDictsIndexer.txt" or die "no KB" ;

my $n=0;
my @kbarray ;
while(<KB>) {
  chomp() ;
  $kbarray[$n]=$_ ;
  $n++ ;
}



while(<>) {
  my @fields = split /\t/ ;
  # 1-23 spelling feature and context feature
  # fields[24-47] dictionary feature
  # fields[48-51] clustering features
  # fields[52-KBsize]  -- from KB
  # fields[kbsize- kbsize+4] -- all zeros. the next 4 features all zeros
  $n=0 ;
  for(my $i=1; $i<=23; $i++) {
    print "$fields[$i]\tcontextual\n" ;
  }
  # top gun 000000000000000111100000  -- total 24 features
  for(my $i=24; $i<=47; $i++) {
    print "$fields[$i]\tproductdictionary\n" ;
  }
  # product/clusters.fsa fsadump -t 
  for(my $i=48; $i<=51; $i++) {
    print "$fields[$i]\tclustering\n" ;
  }


  for(my $i=52; $i<=$#fields; $i++) {
    print "$fields[$i]\t$kbarray[$n]\n" ;
    $n++;
   }
}

 
