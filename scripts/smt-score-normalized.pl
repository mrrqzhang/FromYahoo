#!/usr/local/bin/perl -w

use strict ;


my %querypair = () ;

while(<>) {
   chomp() ;
   my @fields = split / \|\|\| / ;

   my @scores = split / /, $fields[4] ;
   my @align1 = split / /, $fields[2] ;
   my @align2 = split / /, $fields[3] ;
   $scores[1] = exp(log($scores[1])/($#align1+1)) ;
   $scores[3] = exp(log($scores[3])/($#align2+1)) ;
#   print "$_\n" ;
   print "$fields[0] ||| $fields[1] ||| $fields[2] ||| $fields[3] ||| $scores[0] $scores[1] $scores[2] $scores[3] $scores[4]\n" ;
}

sub max_align {
  my @array = @_ ;
  my $num=0 ;
  for(my $i=0; $i<=$#array; $i++) {
    my @f = split /\,/, $array[$i] ;
    if($#f>$num) {$num=$#f ;}
  }
  return $num ;
}
