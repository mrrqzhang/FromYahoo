#!/usr/releng/bin/perl


open DICT, "<$ARGV[0]" ;
open IN, "<$ARGV[1]" ;
my $COL=$ARGV[2] ;
%dict=() ;
$num=0 ;
$total = 0 ;
while(<DICT>) {
  chomp() ;
  @words = split /\t/ ;
#  print "$words[0]\t$words[1]" ;

  $words[0] =~ /^(.*\S) *$/ ;
  $words[0]=$1 ;
  if( ! defined  $dict{$words[0]}){
    $dict{$words[0]}= $words[$#words] ;
#    $total += $words[$#words] ;
  }
  $num++ ;
}



$i=0 ;



$all=0 ;
while( <IN>) {
  chomp ;
  my  @words = split /\t/ ;
    $words[$COL-1] =~ /^(.*\S) *$/ ;
  $words[$COL-1]=$1 ;
 
#  print "$_ $words[0]\n" ;
  if( defined $dict{$words[$COL-1]} ) {
#  if( defined $dict{$_} ) {
    print "$_\n" ;
  }

}

