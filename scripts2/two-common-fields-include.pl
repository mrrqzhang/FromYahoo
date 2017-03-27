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
#  print "$words[0]\t$words[1]\n" ;
  $words[0] =~ /^(.*\S) *$/ ;
  $words[0]=$1 ;
    $words[1] =~ /^(.*\S) *$/ ;
  $words[1]=$1 ;


  my $key  = "$words[0]\t$words[1]" ;
 
  if( !defined  $dict{$key}){
    $dict{$key}= 1 ;
#    print "$dict{$key}\n" ;
  }
  $num++ ;
}






while( <IN>) {
  chomp ;
  my  @words = split /\t/ ;
  $words[0] =~ /^(.*\S) *$/ ;
  $words[0]=$1 ;
    $words[1] =~ /^(.*\S) *$/ ;
  $words[1]=$1 ;

   my  $key  = "$words[0]\t$words[1]" ; 
#  print "$key\t$dict{$key}\n" ; 
  if( defined $dict{$key} ) {
    print "$_\n" ;
  }

}

