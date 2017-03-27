#!/usr/releng/bin/perl

$#ARGV>=1 or die "random-sample.pl inputfile #sample" ;

open IN, "<$ARGV[0]" ;
$samples = $ARGV[1] ;
$start=$ARGV[2] ;

#srand($start) ; # old use

srand ; # random seed (machine time)
@dict=() ;
$num=0 ;
while(<IN>) {
  chomp() ;
  @words = split /\t/ ;
  $dict[$num]=$_ ;
  $num++ ;
}
$total = $num ;
if($samples>$total) {$samples=$total;}
$i=0 ;




while( $i != $samples ) {
  $r =int( $total*rand ) ;
  if( $dict[$r] ne "") {
    print "$dict[$r]\n" ;
    $dict[$r]="" ;
    $i++ ;
  }
}

