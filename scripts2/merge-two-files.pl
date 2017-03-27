use strict ;

my $IN1 ;
my $IN2 ;

open IN1, "<$ARGV[0]" ;
open IN2, "<$ARGV[1]" ;

while(<IN1>) {
  chomp() ;
  my $next=<IN2> ;
  chomp($next) ;
  print "$_\t$next\n" ;
}
