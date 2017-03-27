#!/usr/releng/bin/perl


open DICT, "<$ARGV[0]" ;
open IN, "<$ARGV[1]" ;
%dict=() ;
$num=0 ;
$total = 0 ;
while(<DICT>) {
  chomp() ;
  @words = split /\t/ ;
#  print "$words[0]\t$words[1]" ;
  if( ! defined  $dict{$words[0]}){
    $dict{$words[0]}= $words[$#words] ;
    $total += $words[$#words] ;
  }
  $num++ ;
}



$i=0 ;



$all=0 ;
while( <IN>) {
  chomp() ;
    @words = split /\t/ ;
#  print "$_\n" ;
  if( defined $dict{$words[0]} ) {
    $all += $dict{$words[0]} ;
  }

}
my $percent = $all/$total ;
print "sub=$all  totaldict=$total  percent=$percent\n" ;

