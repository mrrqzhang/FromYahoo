
use strict ;

local $| = 1;

my $NUM=50 ;
my $ALPHA=0.1 ;

my $file=$ARGV[0] ;
my $outfile=$ARGV[1] ;


my @oldnode=() ;

my @fathernode=() ;

my $totaln=0 ;
open FILE, "<$file" ;
my $max =0 ;

my @node2index=() ;
my @index2node=() ;

my $line=0 ;
while (<FILE>) {
  chomp ;
  my @fields = split /\t/ ;

  for (my $i=0; $i<=$#fields; $i++) {
    if(! defined $node2index[$fields[$i]]) {
      $node2index[$fields[$i]] = $totaln ;
      $index2node[$totaln]=$fields[$i] ;
      $totaln++ ;
    }
    if($i!=0) {
      my $nd = $node2index[$fields[$i]] ;
      $fathernode[$nd] ++ ;
    }

  }
  $line++ ;
  if($line%1000==0) {print "$line $totaln\n" ;}
  
}

print "$totaln\n" ;

for( my $i=0; $i<$totaln; $i++ ) {
    $oldnode[$i]=1/$totaln; 
}


close FILE ;

my $stopcount=0 ;
my $oldsum=0 ;

for (my $loop=0; $loop<$NUM; $loop++) {
  open FILE, "<$file" ;
  print "Loop $loop\n" ;
  my @newnode = ();
  $line=0 ;
  my $definednodevalue=0 ;
  while (<FILE>) {
    chomp ;
    my @fields = split /\t/ ;
    my $val=0 ;
    my $residue=1 ;
    for (my $i=1; $i<=$#fields; $i++) {
      my $nd = $node2index[$fields[$i]];
#      print "$fields[$i] and $nd\n" ;
      my $son = (1-$ALPHA)/$fathernode[$nd]+$ALPHA/$totaln ;
      $val += $son*$oldnode[$nd] ;
      $residue -= $oldnode[$nd] ;
    }
    if($residue<0) {print "residue $residue\n"; $residue=0;}
    $val += $ALPHA/$totaln*$residue ;
    my $nd = $node2index[$fields[0]];
    $newnode[$nd]=$val ;
    $definednodevalue += $oldnode[$nd] ;
#    if($line%10==0) {print "$line\n" ;}
    $line++ ;
  }
  my $val2=$definednodevalue*$ALPHA/$totaln+(1-$definednodevalue)/$totaln ;
 
  for(my $n=0; $n<$totaln; $n++){
    if( !defined $newnode[$n] ) {  # this node has no child
      $newnode[$n]=$val2 ;
    }
  }

  my $sum=0 ;
  for (my $i=0; $i<$totaln; $i++) {
      $sum+= $newnode[$i];
  }
  if($sum==0) {print "Error: $sum=0\n" ; exit; } ;
  for (my $i=0; $i<$totaln; $i++) {
      $newnode[$i]/=$sum ;
  }
  my $sum2=0 ;
  for (my $i=0; $i<$totaln; $i++) {
      $sum2+= ($oldnode[$i]-$newnode[$i])*($oldnode[$i]-$newnode[$i] ) ;
	$oldnode[$i] = $newnode[$i] ;
  }
  if($sum2<=0) {print "Error: $sum2<=0\n" ; exit; } ;
  $sum2 = log($sum2) ;  
  if($sum2<$oldsum) {$stopcount++; }
  else {$stopcount=0 ;}
  $oldsum = $sum2 ;
  print "logerr=$sum2\n" ;

  close FILE ;

  open OUT, ">$outfile" ;
  for(my $i=0; $i<$totaln; $i++ ){
   print OUT "$index2node[$i]\t$oldnode[$i]\n" ;
  }
  close OUT ;


#  if($stopcount==10) {last;}



}





open OUT, ">$outfile" ;
for(my $i=0; $i<$totaln; $i++ ){
  print OUT "$index2node[$i]\t$oldnode[$i]\n" ;
}

close OUT ;
