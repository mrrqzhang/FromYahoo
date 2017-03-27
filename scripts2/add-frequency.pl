#!/usr/releng/bin/perl

# transfer "yearnum/confidence/maincount" from maindict to sampled queries

$#ARGV==1 or die "add-frequency.pl dict input" ;

open DICT, "<$ARGV[0]" ;


%dict = {} ;

$num=0 ;
while(<DICT>) {
  chomp() ;
  my @words = split '\t' ;
  $dict{$words[0]}= "$words[2]\t$words[3]\t$words[4]" ;
  $num++ ;
}


open INPUT, "<$ARGV[1]" ;

$num=0 ;

while(<INPUT>) {
  chomp () ;
  $rep = $_ ;
  @words = split '\t' ;

  if ( defined $dict{$words[0]} ) {
    print "$_\t$dict{$words[0]}\n" ;
  }
}
