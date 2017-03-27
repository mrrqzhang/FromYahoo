#!/usr/releng/bin/perl


open DICT, "<$ARGV[0]" ;
open IN, "<$ARGV[1]" ;
%dict=() ;
$num=0 ;
$total = 0 ;
while(<DICT>) {
  chomp() ;
  my  @words = split /\t/ ;
  $words[0] =~ /^(.*\S) *$/ ;
  $words[0]=$1 ;
  $words[1] =~ /^(.*\S) *$/ ;
  $words[1] = $1 ;
  my $key = "$words[0]\t$words[1]" ;
#  print "$key\n" ;
  if( ! defined  $dict{$key}){
    $dict{$key}= "$_" ;
#    print "$dict{$key}\n" ;
  }
  $num++ ;
}



$i=0 ;



$all=0 ;
while( <IN>) {
  chomp() ;
  my  @words = split /\t/ ;
  $words[0] =~ /^(.*\S) *$/ ;
  $words[0]=$1 ;
  $words[1] =~ /^(.*\S) *$/ ;
  $words[1] = $1 ;
  
  my $key = "$words[0]\t$words[1]" ;
#  print "$key\n" ;
  if( defined $dict{$key} ) {
    print "$_\t$dict{$key}\n" ;
  }

}

