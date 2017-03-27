#!/usr/releng/bin/perl

use strict;
my @fields = () ;
my @words ;
my @word1 ;
my @word2 ;

while(<>) {
  chomp() ;
  @words = split /\t/ ;
  replace_year($words[0]) ;
  if($word1[0] eq ""){ next;}
  print "@word1\t" ;
  separate_year($words[1]) ;
  print "@word1\t@word2\t$words[2]\n" ;


}


sub replace_year {
  my $input = shift @_ ;
  my $year = "" ;
  my @fields = split /\t/ ;
  my $query = $fields[0] ;
  while ( $query =~ /(平成 *[12][0-9] *年)/) {
    my $temp = $1 ;
    $temp =~ s/ //g ;
    $year = "$year $temp" ;
    
    $query =~ s/平成 *[12][0-9] *年/ /i ;
  }

  while ( $query =~ /(平成 *[12][0-9])/) {
    my $temp = $1 ;
    $temp =~ s/ //g ;
    $year = "$year $temp" ;
    $query =~ s/平成 *[12][0-9]/ /i ;
  }

  while ( $query =~ /(20[0-1][0-9] *年)/ ) {
    my $temp = $1 ;
    $temp =~ s/ //g ;
    $year = "$year $temp" ;
    $query =~ s/20[0-1][0-9] *年/ /i ;
  }  

  while ( $query =~ /(20[0-1][0-9])/ ) {
    my $temp = $1 ;
    $temp =~ s/ //g ;
    $year = "$year $temp" ;
    $query =~ s/20[0-1][0-9]/ /i ;
  }
  my $out = "$query" ;
  @word1 = split ' ', $out ;
  $out = "$year" ;
  @word2 = split ' ', $out ;
}


sub separate_year {
  my $input = shift @_ ;
  my $year = "" ;
  my @fields = split /\t/, $input ;
  my $query = $fields[0] ;
  while ( $query =~ /(平成 [12][0-9] 年)/) {
    my $temp = $1 ;
    $temp =~ s/ //g ;
    $year = "$year $temp" ;
    
    $query =~ s/平成 [12][0-9] 年/ /i ;
  }

  while ( $query =~ /(平成 [12][0-9])/) {
    my $temp = $1 ;
    $temp =~ s/ //g ;
    $year = "$year $temp" ;
    $query =~ s/平成 [12][0-9]/ /i ;
  }

  while ( $query =~ /(20[0-1][0-9] 年)/ ) {
    my $temp = $1 ;
    $temp =~ s/ //g ;
    $year = "$year $temp" ;
    $query =~ s/20[0-1][0-9] 年/ /i ;
  }  

  while ( $query =~ /(20[0-1][0-9])/ ) {
    my $temp = $1 ;
    $temp =~ s/ //g ;
    $year = "$year $temp" ;
    $query =~ s/20[0-1][0-9]/ /i ;
  }
  my $out = "$query" ;
  @word1 = split ' ', $out ;
  $out = "$year" ;
  @word2 = split ' ', $out ;
#  print "@word1\t@word2\t$fields[1]\n" ;


}
