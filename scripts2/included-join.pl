#!/usr/releng/bin/perl

use strict ;
open DICT, "<$ARGV[0]" ;
open IN, "<$ARGV[1]" ;
my %dict=() ;
my $num=0 ;
my $total = 0 ;
while(<DICT>) {
  chomp() ;
  my @words = split /\t/ ;
#  print "$words[0]\t$words[1]" ;

  $words[0] =~ /^(.*\S) *$/ ;
  $words[0]=$1 ;
 # print "$words[0]****$words[1]\n" ;
  if( ! defined  $dict{$words[0]}){
    $dict{$words[0]}= $_ ;
    $total += $words[$#words] ;
  }
  $num++ ;
}






while( <IN>) {
  chomp ;
  my  @words = split /\t/ ;
   if($#words<0) {next;}
    $words[0] =~ /^(.*\S) *$/ ;
  $words[0]=$1 ;

#  print "$_ $words[0]\n" ;
  if( defined $dict{$words[0]} ) {
#  if( defined $dict{$_} ) {
    print "$dict{$words[0]}\t$_\n" ;
  }

}

