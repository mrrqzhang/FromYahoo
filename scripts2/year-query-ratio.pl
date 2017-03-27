#!/usr/releng/bin/perl
use strict ;

#$#ARGV>=1 or die "command:  \n" ;

#input:  sortseg.v2 scheme

#my $IN ;
#open IN, "<$ARGV[0]" ;



my %year=() ;

my $pre = "" ;

my $cf=0 ;

my $maincount ;
while (<>) {

  
  chomp() ;
  my   @fields = split /\t/ ;


  if ( $fields[0] eq "") {
    next ;
  }

#  print "$pre ###############  $fields[0]\n" ;
  if ($pre eq $fields[0] || $pre eq "") {
    my @wy = split ' ', $fields[1] ;
    for (my $i=0;$i<=$#wy; $i++) {
      $wy[$i] =~ s/年//g ; 
      $year{$wy[$i]} += $fields[2] ;
    }
    $pre = $fields[0] ;
  } else {			# for a new query
    my $hashsize = scalar keys %year ;
    my ($latestyear, $latestcount, $maxyear, $maxcount, $yearsum) = yearcount(\%year) ;
    $maincount += $yearsum ;
    if ($maincount!=0) {
      my $cf=$yearsum/$maincount ;
      print "$pre\t$latestyear\t$hashsize\t$cf\t$maincount\n" ;
    }
  
    $pre = $fields[0] ;		# new query update "pre" 
    $maincount=0 ;
    %year = () ;
    if ( $fields[1] eq "" ) {
      $maincount += $fields[2] ;
      next ;
    }
    my @wy = split ' ', $fields[1] ;
    for (my $i=0;$i<=$#wy; $i++) {
      $wy[$i] =~ s/年//g ; 
      $year{$wy[$i]} += $fields[2] ;
    }
  }
}


 

sub yearcount {
  my $heseiyear ="平成";
  my $heseicount=0 ;
  my  $latestyear="1999" ;
  my  $latestcount=0 ;
  my  $ysum=0 ;
  my (%yr) = %{$_[0]} ;		# %$yr
  my  @ret ;
  my $key ;
  my $maxcount = 0 ;
  my $maxyear ;
  foreach $key ( keys %yr ) {
#    print "here $key $yr{$key}\n" ;
    $ysum += $yr{$key} ;
    if ( $maxcount <$yr{$key} ) {
      $maxcount = $yr{$key} ;
      $maxyear = $key ;
    }
    if ( $key =~ /平成/) {
      if ("$heseiyear" ge "$key" ) {
	next ;
      }
      $heseiyear = $key ;
      $heseicount = $yr{$key} ;
    }
    if ( $key =~ /200[0-9]/ ) {
      if ( "$latestyear" ge "$key" ) {
	next ;
      } 
      $latestyear = $key ;
      $latestcount = $yr{$key} ;
    }
  }
  $key = $heseiyear ;
  $key =~ s/平成//g ;
  $key = 1988+$key ;
  if ( $key-$latestyear >=0 ) {
    $latestyear = $heseiyear ;
    $latestcount = $heseicount ;
  }
#  print "$latestyear, $latestcount, $maxyear, $maxcount, $ysum\n" ;
  return ($latestyear, $latestcount, $maxyear, $maxcount, $ysum) ;
}
     
        
