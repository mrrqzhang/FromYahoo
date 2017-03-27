
#$ 1 000 000 duck        media_title     ^taxonomy:media_category="/movie"
#10      0       2008 easter date holiday        token B-event_name(^taxonomy:event_category=/holiday) token B-occasion

my $num=300000 ;

while(<>) {
  chomp();
  my @fields = split /\t/ ;
  my $q = $fields[0] ;
  my $class = $fields[1] ;
  my $fineclass=$class ;
  if($fields[3] =~ /\^taxonomy(.*)\"(.*)\"/) {
    $fineclass = "$class(^taxonomy$1$2)" ;
  }
  
  my @words = split / /,$q ;
  print "$num\t0\t$q\t" ;
  print "B-$fineclass" ;
  for(my $i=1; $i<=$#words ; $i++) {
     print " I-$fineclass" ;
  }
  print "\n" ;
  $num++ ;
}
  
