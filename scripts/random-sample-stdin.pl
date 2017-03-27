#!/usr/releng/bin/perl

$#ARGV>=0 or die "random-sample.pl inputfile #sample" ;

#open IN, "<$ARGV[0]" ;
$samples = $ARGV[0] ;

#srand(4) ;

@dict=() ;
$num=0 ;
while(<STDIN>) {
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

