#!/usr/releng/bin/perl

%tf = () ;
%df =() ;

while (<>) {
  chomp() ;
  @fields = split /\t/ ;
  if ($fields[0] eq "") { next ;}
  @words = split ' ', $fields[0] ;
  
  if( $fields[2] =~ /^\d*$/ ) {
#    print "$fields[0]\n" ;
    $tf{$fields[0]} += $fields[2] ;
  } 
  if( $#words>1 ) {
    $df{$fields[0]} += 1 ;
  }
  for($i=0;$i<=$#words; $i++) {
#    print "$words[$i]\n" ;
    $df{$words[$i]} += 1 ;
  }

}

foreach $key (keys %tf) {
  if( $df{$key}==1 ) [next;}
  if (defined $df{$key}) {
    $val = $tf{$key}/$df{$key} ;
    print "$key\t$val\n" 
  }

}
