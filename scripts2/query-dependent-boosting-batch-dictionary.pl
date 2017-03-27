#input: dictionary ipdout yearalgo diff-step threshold const==1

use strict ;

if ($#ARGV<1) { 
  print "INPUT parameters: dictionary ipdout yearalgo(default=tau) diff-step(default=0) threshold(default=1000) lazy-boost(default=0)\n" ;
  exit ;
}

my $DICT ;
my $IPDOUT ;
my $step=0 ;
my $threshold=1000 ;
my $constboost=0 ;
my $yearalgo="tau" ;
my %qdict=() ;

my $QueryList ;
my %ql=() ;


my @urlbank=()  ;
my $thisquery ;

open DICT, "<$ARGV[0]" or die "first argv[0] error file not exist\n" ;
open IPDOUT,, "<$ARGV[1]" or die "second argv[1] error file not exist\n" ;


if( defined $ARGV[2] ){
  $yearalgo = $ARGV[2] ;
}

if( defined $ARGV[3] ){
  $step = $ARGV[3] ;
}

if( defined $ARGV[4] ){
  $threshold = $ARGV[4]; 
}

if( defined $ARGV[5] ) {
  $constboost = $ARGV[5] ;
}

if( defined $ARGV[6] ) {
  $QueryList = $ARGV[6] ;
}

my $QL ;


open QL, "<$QueryList" ;

while(<QL>){
  chomp ;
  $ql{$_}=1 ;
}


my $scheme="$yearalgo-$step-$threshold-$constboost" ;
while(<DICT>) {
  chomp ;
  my @fields = split "\t" ;
  my $key = $fields[0] ;
  my $val = "$fields[1]\t$fields[2]" ;
  $qdict{$key}=$val ;
}


while(<IPDOUT>) {
  if ( /Query\: ALLWORDS\((.*)\)/ ||  /query\:ALLWORDS\((.*)\)/) {
    $thisquery = $1 ;

    last ;
  }
}

my $nextquery =  $thisquery;

while( ! (eof IPDOUT) ) {
  @urlbank=() ;

  all_query_url( ) ; 

=begin
  if( ! defined $qdict{$thisquery} ) {
    $thisquery = $nextquery ;
    next ;
  }

=cut

  if( ! defined $ql{$thisquery} ) {
    $thisquery = $nextquery ;
    next ;
  }



  DE_cluster_adjust() ;

#  print_askout() ;
  adjust_urlscore() ;

  my $pri=0 ;
  $pri = reordertop(5) ;

#  if($pri==1) { print_askout() ;}
  print_askout() ;
  $thisquery = $nextquery ;
}


sub print_askout {
  my $i ;

=begin
  print "$thisquery\n" ;
  print "  Engine: idpproxy-jp-all-the-web-directory_on-production-2008-08-13\n" ;
  for($i=0;$i<5;$i++) {
    print "    Url: $urlbank[$i][0] $urlbank[$i][1] $urlbank[$i][2] $urlbank[$i][3] $urlbank[$i][4]\n" ;
  }
=cut
  print "Query: $thisquery\n" ;
  print "  Engine: idpproxy-jp-all-the-web-directory_on-production-$scheme-2008-09-28\n" ;
  for($i=0;$i<5;$i++) {
    print "    Url: $urlbank[$i][0]\n" ;
  }

}

sub reordertop {
  my $topn = shift @_ ;
  my $ret=0 ;
  my $n=0 ;
  my @temp=() ;
  while($n<$topn) {
    my $maxscore = $urlbank[$n][4] ;
    my $maxn = $n ;
    my $nn=$n+1 ;
    while ( defined $urlbank[$nn] ) {
      if ( $urlbank[$nn][4]>$maxscore) {
	$maxscore = $urlbank[$nn][4]; 
	$maxn = $nn ;
      }
#      print "$maxn $nn $maxscore\n" ;
      $nn++ ;
    }
    if ($maxn!=$n) {
      my $k ;
      for ($k=0;$k<6;$k++) {
	$temp[$k] = $urlbank[$maxn][$k];
      }
      for ($k=0;$k<6;$k++) {
	$urlbank[$maxn][$k] = $urlbank[$n][$k] ;
      }
      for ($k=0;$k<6;$k++) {
	$urlbank[$n][$k]=$temp[$k] ;
      }
      $ret=1 ;
    }
    $n++ ;
  }
  return $ret ;
}



sub DE_cluster_adjust{
  my @lowde = () ;
  my $i=0 ;
  while ( defined $urlbank[$i] ) {
    my $j=$i+1  ;
    $lowde[$i]=0 ;
    while ( defined $urlbank[$j] ) {
      if( $urlbank[$i][4] < $urlbank[$j][4] ) {
#	print "$i $urlbank[$i][4] and  $urlbank[$j][4]\n" ;
	$lowde[$i]=1 ;
	last ;
      }
      $j++ ;
    }
    $i++ ;
  }
  for ($i=0; defined $lowde[$i]; $i++) {
    if ( $lowde[$i]==1 ) {
      if ($i==0) {
	my $k = get_next($i+1,\@lowde) ;
	$urlbank[0][4]=$urlbank[$k][4]+1.0 ;
	$lowde[0]=0 ;
      } else {
	my $next = get_next($i+1,\@lowde) ; #if next one no defined, return current
#	print "$i $next $urlbank[$i-1][4] $urlbank[$i][4] $urlbank[$next][4] \n";
	$urlbank[$i][4]=$urlbank[$i-1][4]-($urlbank[$i-1][4]-$urlbank[$next][4])/2 ;
	$lowde[$i]=0 ;
      }
    }
  }
}



sub get_next {
  my ($n, $lowde) = @_ ;
  while( defined ${$lowde}[$n] ){
    if(${$lowde}[$n]==0) {return $n;}
    $n++;
  }
  return $n-1 ;
}
	



sub all_query_url {

  my $rank=1 ;
  my $stop = 1 ;
 

  while (<IPDOUT>) {

    my $url ;
    while( 1 ){
      $url = <IPDOUT> ; chomp($url) ;
      if ( $url =~ /query\:ALLWORDS\((.*)\)/ || $url =~ /Query\: ALLWORDS\((.*)\)/) {
	$nextquery=$1;
	
#	print "$nextquery\n" ;
	return ;
      }
#      print "$url\n" ;
      if( eof IPDOUT ) {return;}
      if( $url =~ /^http/ ) { $url =~ s/\t/ /g ; last;}
    }

    
    my $title = <IPDOUT> ; chomp ($title);  $title =~ s/\t/ /g ;

    for(my $i=0;$i<=15; $i++) { <IPDOUT> ;} ;

    my $score = <IPDOUT> ; chomp($score) ;

=begin
    my $dtime = <IPDOUT> ; chomp($dtime) ; $dtime =~ /(200[0-9]).*/ ; $dtime = $1 ;

    my $lastmod = <IPDOUT> ; chomp($lastmod) ;  $lastmod =~ /(200[0-9]).*/ ; $lastmod=$1 ;

    my $datemin = <IPDOUT> ; chomp($datemin) ; if($datemin!=0) {$datemin = int ($datemin/365) +1970 ;};

    my $datemax = <IPDOUT> ; chomp($datemax) ;  if($datemax!=0) {$datemax = int ($datemax/365) + 1970 ;}
=cut
  
    my $dtime ;

    my $lastmod; 

    my $datemin ; 

    my $datemax ; 

#    print "$score $title\n" ;
    
    my $year = "" ;
       
    my $year1="" ;
    my $year2 = "" ;

    if ( $yearalgo eq "tau" ) {
      if ($url =~ /[[:punct:]](19[0-9][0-9])[[:punct:]]/ ) {
	$year1 = $1 ;
      }

      if ( $url =~ /[[:punct:]](200[0-9])[[:punct:]]/  ) {
        $year1 = $1 ;
      }

=begin
      if ($url =~ /(19[0-9][0-9])/ ) {
	$year1 = $1 ;
      }

      if ( $url =~ /(200[0-9])/  ) {
	$year1 = $1 ;
      }

=cut
      if ( $title =~/(19[0-9][0-9])/) {
	$year2 = $1 ;
      }
      if ( $title =~ /(200[0-9])/  ) {
	$year2 = $1 ;
      }


      if ( $year1 ge $year2 ) {
	$year = $year1 ;
      } else {
	$year = $year2 ;
      }
    } elsif ( $yearalgo eq "tau2" ) {
      if ( ($title =~ /(200[0-9])/ || $title =~/(19[0-9][0-9])/ || $url =~ /(19[0-9][0-9])/ || $url =~ /(200[0-9])/) ) {

	if ($url =~ /(19[0-9][0-9])/ ) {
	  $year1 = $1 ;
	}

	if ( $url =~ /(200[0-9])/  ) {
	  $year1 = $1 ;
	}
	if ( $title =~/(19[0-9][0-9])/) {
	  $year2 = $1 ;
	}
	if ( $title =~ /(200[0-9])/  ) {
	  $year2 = $1 ;
	}

	if ( $year1 ge $year2 ) {
	 $year = $year1 ;
	} else {
	  $year = $year2 ;
	}


      } elsif ( $lastmod < 2008 ) {
	$year = $lastmod ; 
      } elsif ($datemax==2008 || $datemax==2009) {
	$year = $datemax ;
      } elsif ($dtime >= 2008) {
	$year = $dtime ;
      } 
    }elsif ($yearalgo eq "svm"){

    }


    $urlbank[$rank-1][0] = $url ;
    $urlbank[$rank-1][1] = $title ;
    $urlbank[$rank-1][2] = $year ;
    $urlbank[$rank-1][3] = $rank ;
    $urlbank[$rank-1][4] = $score ;
    $urlbank[$rank-1][5] = 0 ;
    $urlbank[$rank-1][6] = 0 ;
    $rank++ ;



  }
  if ( eof IPDOUT ) { 
    $stop=0 ;
#    print "stop=$$stop\n" ;
  }
  return  ;
}



sub adjust_urlscore {
  my $val = $qdict{$thisquery} ;
  my @fields = split "\t", $val ;
#  print "$fields[0] $fields[1] $fields[2]\n" ;
  if ($constboost !=0 ) {
    update_urlscore_constant($fields[0],$constboost) ;
  } else {    
    my $boost = $fields[1]+$step ;
    if( $boost>$threshold) {
      $boost = $threshold ;
    }
    update_urlscore_constant($fields[0], $boost) ;
  }
}      
  



sub update_urlscore_constant {
  my ($year,$boost) = @_ ;
  my $i=0;
#  print "$boost $year\n" ;
  while ( defined $urlbank[$i]  ) {
    if ($urlbank[$i][2] eq $year) {
#      print "$urlbank[$i][2]  and rank: $urlbank[$i][3] and before boost: $urlbank[$i][4]\n" ;
      $urlbank[$i][4] += $boost ;
      $urlbank[$i][5] = $boost ;
#      print "after boost $i: $urlbank[$i][4]\n" ;
    }
    $i++ ;
  }
}


  
  


