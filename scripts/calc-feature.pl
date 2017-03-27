

open QUERY, "<$ARGV[0]" ;

open NBEST, "<$ARGV[1]" ;
my $lastbest=<NBEST> ;
my @nbest=() ;
my @features = () ;
my $srcquery ;
while($srcquery = <QUERY>) {
 chomp($srcquery) ;
 get_next_nbest() ;
 my %qryfeatureset = () ;
 
 my $firstquery ;
 for(my $i=0; $i<=$#nbest; $i++) {
   my @fields = split / \|\|\| /, $nbest[$i] ;
   my $query = $fields[1] ;
   if($i==0) {$firstquery = $query ; }
   my @temp = split / /, $query ;
 
  my $wl = $#temp+1 ;
   if($i==0) {  
      my $tmp = normalize_features($fields[2],$wl) ; 
      @features = @$tmp ; 
   } ;
   my $sumfeat = normalize($fields[3])/$wl ;
#   print "sumf $sumfeat\n" ;
   if(!defined $qryfeatureset{$query}) { $qryfeatureset{$query} = $sumfeat ;}
 }
 my $sum=0 ;
 my $key ;
 foreach $key ( keys %qryfeatureset ) { $sum += exp($qryfeatureset{$key}) ;}
 my $conf = exp($qryfeatureset{$firstquery})/$sum ; 
 my $tmpstr = join("\t", @features) ;
 print "$srcquery\t|||\t$firstquery\t$tmpstr\t$qryfeatureset{$firstquery}\t$conf\n" ;
}


sub get_next_nbest 
{
  my $n=0 ;
  @nbest = () ;
# print "$lastbest\n" ; 
 $nbest[0] = $lastbest ;
  my @temp = split /\t/, $lastbest;
  $n=1 ;
  while(<NBEST>) {
    chomp() ;
#    print "$_\n" ;
    my @fields = split /\t/ ;
    if($temp[0]==$fields[0]) {
        $nbest[$n]=$_ ;
        $n++ ;
    }
    else {
       $lastbest=$_ ;
       return ;
    }
  }
  return ;
}

sub normalize_features 
{
  my ($feat,$wl) = @_ ;
  
  my @fields = split / /, $feat ;
  my @array = ( $fields[1],$fields[2],$fields[3],$fields[4],$fields[5],$fields[6],$fields[7],$fields[9],$fields[11],$fields[12],$fields[13],$fields[14],$fields[15],$fields[17] ) ;
  for(my $i=7;$i<$#array; $i++) {
    $array[$i] = normalize($array[$i]) ;
  }
  for(my $i=0; $i<=$#array; $i++) { 
    if($array[$i]!=0) {$array[$i]/=$wl ;}
  };
  return \@array ;
}

sub normalize  # unknown score -100 
{ 
  my $feat = shift @_ ;
  if($feat > -100) {return $feat;}
  while($feat < -100) {$feat+=100 ;}
  return $feat ;
}





