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
  $words[0] =~ /^(.*\S) *$/ ;
  $words[0]=$1 ;

  if( ! defined  $dict{$words[0]}){
    my $d = "$words[1]" ;
    for(my $i=2;$i<=$#words;$i++) {$d = "$d\t$words[$i]";}
    $dict{$words[0]}= $d ;
  }
}



$i=0 ;



$all=0 ;
while( <IN>) {
  chomp() ;
    @words = split /\t/ ;
#  print "$_\n" ;
  $words[0] =~ /^(.*\S) *$/ ;
  $words[0]=$1 ;

  if( defined $dict{$words[0]} ) {
    my $d="$words[1]" ;
    for(my $i=2;$i<=$#words;$i++) {$d = "$d\t$words[$i]";}
    print "$words[0]\t$dict{$words[0]}\t$d\n" ;
  }

}

