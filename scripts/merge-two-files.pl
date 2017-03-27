use strict ;

my $IN1 ;
my $IN2 ;

open IN1, "<$ARGV[0]" ;
open IN2, "<$ARGV[1]" ;

while(<IN1>) {
  chomp() ;
  my $first = $_ ;
  $first =~ /^(.*\S) *$/ ;
  $first = $1 ;


  my $next=<IN2> ;
  chomp($next) ;
  $next =~ /^(.*\S) *$/ ;
  $next = $1 ; 
  if("$next" eq "$first") {next;}
  print "$first\t$next\n" ;
}

