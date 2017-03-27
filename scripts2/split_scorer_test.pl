

open INDEX, "<$ARGV[0]" ;
open CSVIN, "<$ARGV[1]" ;
open DEBUGIN, "<$ARGV[2]" ;
open LABELIN, "<$ARGV[3]" ;

open CSVOUT, ">$ARGV[4]" ;
open DEBUGOUT, ">$ARGV[5]" ;
open LABELOUT, ">$ARGV[6]" ;

my %index=() ;
while(<INDEX>) {
  chomp() ;
  $index{$_}=1 ;
}

my $debug = <DEBUGIN> ;
print DEBUGOUT "$debug" ;

my $csv = <CSVIN> ;
print CSVOUT "$csv" ;

my $label = <LABELIN> ;
print LABELOUT "$label" ;


while(<DEBUGIN>) {
 $debug=$_ ;
 chomp() ;
 $csv = <CSVIN> ;
 $label = <LABELIN> ;
 if($index{$_}==1) {
   $index{$_}=2 ; # uniq
   print DEBUGOUT "$debug" ;
   print CSVOUT "$csv" ;
   print LABELOUT "$label" ;
 }
}
  
