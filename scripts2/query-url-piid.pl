#input piid query-url and feature.csv judgedset.txt.trimmed
#output new query-url and feature.csv without piid judgedset.txt.trimmed

use strict ;

$#ARGV>4 or die "command: csv query-url judgment out-csv out-query-url out-jdg\n" ;
 
open CSV1, "<$ARGV[0]" ;
open QRY1, "<$ARGV[1]" ;
open JDG1, "<$ARGV[2]" ;

open CSV2, ">$ARGV[3]" ;
open QRY2, ">$ARGV[4]" ;
open JDG2, ">$ARGV[5]" ;


my %mpid=() ;
my %mapcsv=() ;
my %mapjdg=() ;

my $key ;
my $csvhead = <CSV1> ; chomp($csvhead) ;

my $jdghead = <JDG1>; chomp($jdghead) ;

my %mpid=() ;
my %mapcsv=() ;
my %mapjdg=() ;


while(<QRY1>) {
  chomp($_) ;

  my @segment = split '\t' ;
  $segment[0] =~ /(.*?)--(.*?)--(.*)/ ;

  my $piid = "$1--$2" ;
  my $qrl = "$3\t$segment[1]" ;
#  print "$piid $qrl\n" ;


  my $cs = <CSV1> ; chomp($cs) ;
  if(defined $mpid{$qrl} && bigger($piid,$mpid{$qrl})) {
    $mpid{$qrl}=$piid ;
    $mapcsv{$qrl} = $cs ;
  }
  elsif( ! defined $mpid{$qrl} ) {
    $mpid{$qrl}=$piid ;
    $mapcsv{$qrl} = $cs ;
  }
}


foreach $key (sort keys %mpid) {
  print QRY2 "$key\n" ;
} ;

print CSV2 "$csvhead\n" ;


foreach $key (sort keys %mapcsv) {
  print CSV2 "$mapcsv{$key}\n" ;

} ;

%mpid=() ;
%mapcsv=() ;



while(<JDG1>) {
  chomp($_) ;
  my @segment = split '\t' ;
  $segment[0] =~ /(.*?)--(.*?)--(.*)/ ;
  my $piid = "$1--$2" ;
  my $qrl = "$3\t$segment[1]" ;
#  print "$qrl\n" ;
  if(defined $mpid{$qrl} && bigger($piid,$mpid{$qrl})) {
    $mpid{$qrl}=$piid ;
    $mapjdg{$qrl} = $segment[2] ;
  }
  elsif( ! defined $mpid{$qrl} ) {
    $mpid{$qrl}=$piid ;
    $mapjdg{$qrl} = $segment[2] ;
  }
}


print JDG2 "$jdghead\n" ;

foreach $key (sort keys %mapjdg) {
  print JDG2 "$key\t$mapjdg{$key}\n" ;
}
    


sub bigger {
  my $yes = 1 ;
  my $no =0 ;
  my ($first, $second)=@_ ;
  $first =~ /(\d+)--(\d+)/ ;
  my $f1 = $1 ;
  my $f2 = $2 ;
  $second =~  /(\d+)--(\d+)/ ;
  my $s1 = $1 ;
  my $s2 = $2 ;

#  print "$first $second $f1 $f2 $s1 $s2\n" ;

  if( $f1>$s1) {return $yes ;}


  elsif ($f2>$s2) {
    return $yes ;
  }
  return $no ;
}
