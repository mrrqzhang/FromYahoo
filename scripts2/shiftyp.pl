#!/usr/releng/bin/perl


while(<>) {
  chomp() ;
  $year = "" ;
  @fields = split /\t/ ;
  $query = $fields[0] ;
  while ( $query =~ /(平成 [12][0-9] 年)/) {
    $temp = $1 ;
    $temp =~ s/ //g ;
    $year = "$year $temp" ;
    
    $query =~ s/平成 [12][0-9] 年/ /i ;
  }

  while ( $query =~ /(平成 [12][0-9])/) {
    $temp = $1 ;
    $temp =~ s/ //g ;
    $year = "$year $temp" ;
    $query =~ s/平成 [12][0-9]/ /i ;
  }

  while ( $query =~ /(200[0-9] 年)/ ) {
    $temp = $1 ;
    $temp =~ s/ //g ;
    $year = "$year $temp" ;
    $query =~ s/200[0-9] 年/ /i ;
  }  

  while ( $query =~ /(200[0-9])/ ) {
    $temp = $1 ;
    $temp =~ s/ //g ;
    $year = "$year $temp" ;
    $query =~ s/200[0-9]/ /i ;
  }
  $out = "$query" ;
  @word1 = split ' ', $out ;
  $out = "$year" ;
  @word2 = split ' ', $out ;
  print "@word1\t@word2\t$fields[1]\n" ;


}
