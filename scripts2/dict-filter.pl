#!/usr/releng/bin/perl

$#ARGV==1 or die "dict-filter.pl dict input" ;

open DICT, "<$ARGV[0]" ;


%dict = {} ;

$num=0 ;
while(<DICT>) {
  chomp() ;
  $dict{$_}=$num ;
  $num++ ;
}


open INPUT, "<$ARGV[1]" ;

$num=0 ;

while(<INPUT>) {
  chomp () ;
  $rep = $_ ;
  @words = split '\t' ;

  $words[0] =~ s/200[0-9]//g ;
  $words[0] =~ s/[0-9]//g ;
#  print "$rep  ****   $words[0]\n" ;
  if ( defined $dict{$words[0]} ) {
    print "$rep\n" ;
  }
}
