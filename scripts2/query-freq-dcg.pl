#!/usr/releng/bin/perl


open DICT, "</net/irdev17/export/crawlspace/ruiqiang/recencyv2/queryselection/dict-index.txt" ;
open IN, "<$ARGV[0]" ;


%dict=() ;
$num=0 ;
while(<DICT>) {
  chomp() ;
  @words = split /\t/ ;
#  print "$words[0]\t$words[1]" ;
  $dict{$words[0]}= $words[$#words] ;
  $num++ ;
}
$total = $num ;


$i=0 ;



$all=0 ;
my %querydcg = () ;

while( <IN>) {
  chomp() ;
  my @fields = split /\t/ ;

  push( @{$querydcg{$fields[5]}}, "$fields[6]\t" ) ;

}

foreach $query ( sort keys %querydcg ) {
  if ( defined $dict{$query} ) {
    print "$query\t$dict{$query}\t@{$querydcg{$query}}\n" ;
  }
}

