#!/usr/releng/bin/perl


open DICT, "</homes/ruiqiang/scripts/adult_en.txt" ;
@dict=() ;
$num=0 ;
$total = 0 ;
while(<DICT>) {
  chomp() ;
  if($_  =~ /^ *$/) {next;}
  $dict[$num] = $_ ;
  $num++ ;
}



$i=0 ;



$all=0 ;
while( <>) {
  chomp() ;
  my $yes=0 ;
  for(my $i=0; $i<$num; $i++) {
	if( $_ =~ /\W$dict[$i]\W/ ) { $yes=1 ;last ;}
	if( $_ =~ /\W$dict[$i]$/) { $yes=1 ;last ;}
        if( $_ =~ /^$dict[$i]\W/) {$yes=1 ;last ;}
  }
  if($yes==0) {print "$_\n" ;}

}

