#!/usr/releng/bin/perl


open DICT, "<$ARGV[0]" ;
open IN, "<$ARGV[1]" ;
%dict=() ;
$num=0 ;
$total = 0 ;
while(<DICT>) {
  chomp() ;
  @words = split /\t/ ;
#  print "$words[0]\t$words[1]" ;
  my $qry = $words[0] ;
  
  if( ! defined  $dict{$qry}){
    my $d = "$words[13]" ;
    for(my $i=14;$i<=$#words;$i++) {$d = "$d\t$words[$i]";}
    $dict{$words[0]}= $d ;
  }
}



$i=0 ;



$all=0 ;
while( <IN>) {
  chomp() ;
    @words = split /\t/ ;
#  print "$_\n" ;
  if( defined $dict{$words[0]} ) {
    my $d="$words[13]" ;
    for(my $i=14;$i<=$#words;$i++) {$d = "$d\t$words[$i]";}
    if( $dict{$words[0]} ne $d ) {
    	print "$words[0]\t$dict{$words[0]}\n" ;
	print "$words[0]\t$d\n" ;
    }
  }

}

