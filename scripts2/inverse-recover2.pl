#!/usr/releng/bin/perl

use strict ;

my  $IN ;
my @argv ;
open IN, "<$argv[0]" ;


my %dict=() ;
my %numdict=() ;

while(<>) {
  chomp(); 
  my @words = split /\t/ ;

  if ( $words[0] =~ /^\s*$/ ) {
    next;
  }
  if ( $words[1] =~ /^\s*$/ ) {
    next;
  }
  if( ! defined $numdict{$words[0]} ){
    $dict{$words[0]} = $words[1] ;
    $numdict{$words[0]}=$words[2] ;
  }elsif ( $numdict{$words[0]}<$words[2] ) {
    $dict{$words[0]} = $words[1] ;
    $numdict{$words[0]}=$words[2] ;
  }    
}




while (<>) {
  chomp() ;
  my @input = split /\t/ ;
  if ( ! defined $dict{$input[0]} ) {
    die "$_ not defined" ;
  }
  print "$input[0]\t$dict{$input[0]}\t$input[2]\n" ;



}

