#!/usr/releng/bin/perl


open DICT, "<$ARGV[0]" ;
open IN, "<$ARGV[1]" ;
%dict=() ;
$num=0 ;
$total = 0 ;
while(<DICT>) {
  chomp() ;
  @words = split /\t/ ;
  my $key = "$words[0]\t$words[1]" ;
  if( ! defined  $dict{$key}){
    $dict{$key}= "$_" ;
  }
  $num++ ;
}



$i=0 ;



$all=0 ;
while( <IN>) {
  chomp() ;
  my  @words = split /\t/ ;
  my $key = "$words[0]\t$words[1]" ;
#  print "$_\n" ;
  if( defined $dict{$key} ) {
    print "$dict{$key}\t$_\n" ;
  }

}

