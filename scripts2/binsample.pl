#!/usr/local/bin/perl

$#ARGV>=2 or die "binsample.pl inputfile #bin #sample" ;


use strict ;

my $DICT ;
my $binnum = $ARGV[1] ;
my $samplenum = $ARGV[2] ;

open DICT, "<$ARGV[0]" ;
my %dictind=() ;

my $max = 0 ;
while(<DICT>) {
  chomp() ;
  my @fields = split '\t' ;
  $dictind{$_} = $fields[$#fields] ;

  if ( $max < $fields[$#fields] ) {$max = $fields[$#fields] ; } ;


}




my $totalnum=0 ;
my $samp = int($samplenum/$binnum)  ;
if($samplenum>$samp*$binnum) {$binnum++ ;} ; 
my $step = ($max/$binnum) ;

#print "$step $max\n" ;
#exit ;

my $loopnum=0 ;
my $zerobm=0 ;
my %saved=() ;

while ($totalnum<$samplenum) {
  $loopnum=0 ;
  $zerobm=0 ;
  for (my $bn=$binnum+1; $bn>= 1; $bn--) {

    $loopnum++ ;

    my @array=() ;
    my $bs = $step*($bn-1) ;
    my $es = $step*($bn) ;
    my $an=0 ;
    my $key ;
    foreach $key ( keys %dictind ) {
      if (defined $saved{$key}) {
	next;
      }
      my $val = $dictind{$key} ; 
      if ( $val>=$bs && $val<$es ) {
	$array[$an]=$key ;
	$an++ ;
      }
    }


    if ($an==0) {
      $zerobm++ ;
      if($zerobm==$loopnum && $bn==1) {exit;} # all bins are empty
      next;
    }
    srand(1) ;
    my $i=0 ;


    my $remains = ($loopnum*$samp)- $totalnum;
    #  print "#### nbin $bn binstart $bs binend $es remains $remains  totalnum $totalnum  samp $samp loopnum $loopnum dictsize-thisbin  $an\n" ;

    while ( $i != $remains ) {
      my $r =int( $an*rand ) ;
      if ( $array[$r] ne "") {
	print "$array[$r]\n" ;
	$saved{$array[$r]}=1 ;
	$array[$r]="" ;
	$i++ ;
	$totalnum++ ;
	if ($totalnum==$samplenum) {
	  exit;
	}
	if ($i==$an) {
	  last;
	}
	;
      }
    }

  }

}

#if($totalnum<$samplenum) { 
#  print "\n\n\n#### Warning: some bin's sample is less than average samples. reduce sample number or reduce bin number. #########\n" ;
#}
  
