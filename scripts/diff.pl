#!/usr/releng/bin/perl


open DICT, "<$ARGV[0]" ;
open IN, "<$ARGV[1]" ;
%dict=() ;
$num=0 ;
$total = 0 ;
while(<DICT>) {
  chomp() ;
  @words = split /\t/ ;
  $words[0] =~ /^(.*\S) *$/ ;
  $words[0]=$1 ;
#  print "$words[0]\t$words[1]" ;
  if( ! defined  $dict{$words[0]}){
    $dict{$words[0]}= $words[$#words] ;
    $total += $words[$#words] ;
  }
  $num++ ;
}



$i=0 ;



$all=0 ;
while( <IN>) {
  chomp() ;
    @words = split /\t/ ;
  $words[0] =~ /^(.*\S) *$/ ;
  $words[0]=$1 ;
#  print "$_\n" ;
  if( ! defined $dict{$words[0]} ) {
    print "$_\n" ;
  }

}

