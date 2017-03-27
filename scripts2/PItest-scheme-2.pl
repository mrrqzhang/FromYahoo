use strict ;

=begin
#(1) only title has "year". only url has "year". both url and title has "year"
#(2) const value boost (2.0 3.0 5.0)
#(3) boost value: (a) over the first (b) under the  first  (3) same as the first 

#step = 2.0

#boosting value calculation:
#(1) over the first:  ( current-first + (upfirst-first)/2)
#(2) under the first: ( current-first - (lowerfirst-first)/2)
#(3) same as the first: ( current-first)

#weighting: only url: a=0 ; only title: a=2.0; title+url: a=3.0
#weighting for year-span: span=1, b=-(step*0.5); span>1: b=0 ;
=cut


open IN, "<$ARGV[0]" ;

open URLF, "<$ARGV[2]" ;

my $engine = "" ;
if ( -e URLF ) {
	$engine = "plus" ;
}


my $scheme = "scheme$ARGV[1]" ;

my @urlbank=()  ;
my $maxyear ;
my $firstyear ;
my $firstyearrank;
my $maxyearrank ;
my $thisquery ;
my $firstyearrankscore ;
my $maxyearrankscore ; 
my $maxyearboost ;
my %dicturl = () ;
my $num=0 ;

my $tempfirstyear="" ;
my $tempmaxyear="" ;

while(<URLF>) {
  chomp() ;
  $dicturl{$_} = $num ;
  $num++ ;
}




while(<IN>) {
  if ( /Query\: ALLWORDS\((.*)\)/ ) {
    $thisquery = $1 ;
    
    last ;
  }
}

my $stop = 1 ;

my $diff = 0 ;

my $nextquery =  $thisquery;

my $queryid=0 ;
while ($stop==1) {
  @urlbank=() ;

  all_query_url( ) ; 


  first_year(\$firstyear, \$firstyearrank) ;
  $maxyear = $firstyear ;
  max_year(\$maxyear,\$maxyearrank) ;




#  print "$firstyear  $maxyear $firstyearrank $maxyearrank\n" ;  
  if ( $tempfirstyear>=$tempmaxyear || $firstyearrank>5) {
    $thisquery = $nextquery ;
    next;
  };
=begin
  if ($firstyear==$maxyear ) {
    print_askout() ;
    $thisquery = $nextquery ;
    next;
  };
=cut


  $maxyearboost = $urlbank[$maxyearrank-1][5] ;
  $maxyearrankscore = $urlbank[$maxyearrank-1][4] ;

#  print_askout() ;
  adjust_urlscore() ;

  my $pri=0 ;
  $pri = reordertop(5) ;

#  if($pri==1) { print_askout() ;}
  print_askout() ;
  
#  print "$thisquery\n" ;
  $thisquery = $nextquery ;
  
}

sub print_askout {
  my $i ;
=begin
  print "Query: $thisquery  firstyear:$firstyear  frank:$firstyearrank  maxyear:$maxyear mrank:$maxyearrank boost:$maxyearboost $maxyearrankscore\n" ;
  print "  Engine: idpproxy-jp-all-the-web-directory_on-production-2008-08-13\n" ;
  for($i=0;$i<5;$i++) {
    print "    Url: $urlbank[$i][0] $urlbank[$i][1] $urlbank[$i][4]\n" ;
  }
=cut
  print "Query: $thisquery\n" ;
  my $outscheme = $ARGV[1] ;
  if($engine eq "plus") {
	$outscheme = $ARGV[1]+18 ;
  }
  print "  Engine: idpproxy-jp-all-the-web-directory_on-production-scheme$outscheme-2008-08-13\n" ;
  for($i=0;$i<5;$i++) {
    print "    Url: $urlbank[$i][0]\n" ;
  }

}

sub reordertop {
  my $topn = shift @_ ;
  my @temp ; my $n ;
  $n = $maxyearrank-1; 
  my $k ; my $i ; my $start ;
  my $ret=0 ;
  $maxyearboost = $urlbank[$n][5] ;
  $maxyearrankscore = $urlbank[$n][4] ;
  while( defined $urlbank[$n] ) {
    if( $urlbank[$n][2] eq $maxyear ) {
      if($n<5) {
	$start=$n-1 ;
      } else { 
	if( $urlbank[$n][4] < $urlbank[$topn-1][4] ) {  last ;}
	$start=$topn-2 ; 
	for($k=0;$k<6;$k++) {$urlbank[$topn-1][$k] = $urlbank[$n][$k] ;}

	$ret=1 ;
#	print "return first: $ret\n" ;
      }

      for($i=$start; $i>=0 ; $i--) {
	if($urlbank[$i][4]<$urlbank[$i+1][4]) {
#	  print "$thisquery\tn=$n\t$urlbank[$i][4]\t$urlbank[$i+1][4]\n" ;
	  for($k=0;$k<6;$k++){$temp[$k] = $urlbank[$i+1][$k];}
	  for($k=0;$k<6;$k++){$urlbank[$i+1][$k] = $urlbank[$i][$k] ;}
	  for($k=0;$k<6;$k++){$urlbank[$i][$k]=$temp[$k] ;}
	  $ret=1 ;
#	  print "return second: $ret\n" ;
#	  print "$urlbank[$i][4]  $urlbank[$i+1][4]\n" ;
	  
	}
	else {
	  last ;
	}
      }
    }
    $n++ ;
  }
#  print "return $ret\n" ;
  return $ret ;
}





sub max_year {
  my ($maxy,$rank) = @_ ;

  my $i=0 ;
  while ( defined $urlbank[$i] ) {
    if (  $urlbank[$i][2] ne "" ) {
      my $yr = $urlbank[$i][2] ;
      my $rk = $urlbank[$i][3] ;

      if ($$maxy<$yr) {
	$$maxy=$yr ;
	$$rank = $rk ;
      }
#      print "$yr $$maxy $$rank\n" ;
    }
    $i++ ;
  }
}

sub first_year {
  my ($firsty,$rank) = @_ ;
  my $i=0 ;
  while ( defined $urlbank[$i] ) {
    if (  $urlbank[$i][2] ne "" ) {
      $$firsty = $urlbank[$i][2] ;
      $$rank = $urlbank[$i][3] ;
#      print "$$firsty $$rank\n" ;
      last ;
    }
    $i++ ;
  }
}





sub all_query_url {

  my $rank=1 ;
  $stop = 1 ;
 
    $tempfirstyear = "" ;

    $tempmaxyear = "" ;

  while (<IN>) {
    if ( /Query\: ALLWORDS\((.*)\)/) {
      $nextquery=$1;  
      last ;
    }

    my $url = <IN> ; chomp($url) ;

    my $title = <IN> ; chomp ($title);

    my $abstract = <IN> ; chomp ($abstract);
    my $score = <IN> ; chomp($score) ;
    
       
    my $year1="" ;
    my $year2 = "" ;
    my $year = "" ;

    if ( $url =~ /(200[0-9])/ ) {
      $year1 = $1 ;
    }
    if ( $title =~ /(200[0-9])/ ) {
      $year2 = $1 ;
    }
    if ( $year1 ge $year2 ) {
      $year = $year1 ;
    } else {
      $year = $year2 ;
    }
    $year = "" ;
    if (defined $dicturl{$url}) {
      $year = 2008 ;
    }

    $year1="" ; $year2="" ;
    if ( $url =~ /(200[0-9])/ ) {
      $year1 = $1 ;
      if ($year < $year1 ) {
	$year = $year1;
      }
    }
    if ( $title =~ /(200[0-9])/ ) {
      $year2 = $1 ;
      if ($year <$year2) {
	$year=$year2;
      }
    }

    if ( $tempfirstyear eq "") {
      $tempfirstyear = $year;
    }
    if ( $tempmaxyear < $year ) {
      $tempmaxyear = $year;
    }   

    $urlbank[$rank-1][0] = $url ;
    $urlbank[$rank-1][1] = $title ;
    $urlbank[$rank-1][2] = $year ;
    $urlbank[$rank-1][3] = $rank ;
    $urlbank[$rank-1][4] = $score ;
    $urlbank[$rank-1][5] = 0 ;
    $urlbank[$rank-1][6] = $abstract ;
    $rank++ ;



  }
  if ( eof IN ) { 
    $stop=0 ;
    #    print "stop=$$stop\n" ;
  }
  return  ;
}



sub adjust_urlscore {
  if ($scheme eq "scheme0") {
    update_urlscore_constant(2.0) ;
  } elsif ($scheme eq "scheme1") {
    update_urlscore_constant(3.0) ;
  } elsif ($scheme eq "scheme2") {
    update_urlscore_constant(5.0) ;
  } else {
    my ($firstyearrankscore, $maxyearrankscore, $firstuponescore, $firstdownonescore) = get_score() ;
    #    print "$firstyearrankscore, $maxyearrankscore, $firstuponescore, $firstdownonescore\n" ;
    my $upstep = $firstyearrankscore-$maxyearrankscore+($firstuponescore-$firstyearrankscore)/10.0 ;
    my $downstep = $firstyearrankscore-$maxyearrankscore-($firstyearrankscore-$firstdownonescore)/10.0 ;
    my $equalstep =  $firstyearrankscore-$maxyearrankscore;
    my $year_span_weight=1.0 ;
    if ( $maxyear-$firstyear==1) {
      $year_span_weight=0.8;
    }
    #    print "$upstep $downstep $equalstep $year_span_weight\n" ;

    if ($scheme eq "scheme3") {
      update_urlscore_constant($upstep) ;
    } elsif ($scheme eq "scheme4") {
      update_urlscore_constant($downstep) ;
    } elsif ($scheme eq "scheme5") {
      update_urlscore_constant($equalstep) ;
    } elsif ($scheme eq "scheme6") {
      update_urlscore_constant($upstep*$year_span_weight) ;
    } elsif ($scheme eq "scheme7") {
      update_urlscore_constant($downstep*$year_span_weight) ;
    } elsif ($scheme eq "scheme8") {
      update_urlscore_constant($equalstep*$year_span_weight) ;
    } elsif ($scheme eq "scheme9") {
      update_urlscore_tau($upstep) ;
    } elsif ($scheme eq "scheme10") {
      update_urlscore_tau($downstep) ;
    } elsif ($scheme eq "scheme11") {
      update_urlscore_tau($equalstep) ; 
    } elsif ($scheme eq "scheme12" ) {
      update_urlscore_tau($upstep*$year_span_weight) ;
    } elsif ($scheme eq "scheme13") {
      update_urlscore_tau($downstep*$year_span_weight) ;
    } elsif ($scheme eq "scheme14") {
      update_urlscore_tau($equalstep*$year_span_weight) ;
    } elsif ($scheme eq "scheme15") {
      update_urlscore_strong($upstep) ;
    } elsif ($scheme eq "scheme16" ) {
      update_urlscore_strong($downstep) ;
    } elsif ($scheme eq "scheme17") {
      update_urlscore_strong($equalstep) ;
    }
    
  }
}      


sub update_urlscore_strong {
  my $boost = shift @_ ;
  my $i=0 ; my $yes; 
#  print "before $boost\n" ;
  while ( defined $urlbank[$i] ) {
    if ($urlbank[$i][2] eq $maxyear) {
      $yes = test_strong($thisquery, $urlbank[$i][0],$urlbank[$i][1], $urlbank[$i][6]) ; 
      if ($yes==1) {
#	if($i<=4) {print "rank=$i $thisquery boost:$boost\n" ;}
	$urlbank[$i][4] += $boost ;	    
	$urlbank[$i][5] = $boost ;
	last ;
      }
    }
    $i++ ;
  }

}



sub test_strong {
  my ($query,$url, $title, $abstract) = @_ ;
  my @temp = split ' ', $query;
  my $yes=1 ;
  my $no=0 ;
  my $i=0 ;

  for($i=0;$i<=$#temp; $i++) {
    if ($title =~ /$temp[$i]/) {
      return $yes ;
    }
    if( $url =~ /$temp[$i]/ ){
      return $yes ;
    }
  }

  for($i=0;$i<=$#temp; $i++) {
    if( !($abstract =~ /$temp[$i]/) ){
      return $no ;
    }
  }

  return $yes ;
}
    
    


  



sub update_urlscore_constant {
  my $boost=shift @_ ;
  my $i=0;
  print "$boost $maxyear\n" ;
  while ( defined $urlbank[$i]  ) {
    if ($urlbank[$i][2] eq $maxyear) {
#      print "$urlbank[$i][2]  and rank: $urlbank[$i][3] and before boost: $urlbank[$i][4]\n" ;
      $urlbank[$i][4] += $boost ;
      $urlbank[$i][5] = $boost ;
#      print "after boost $i: $urlbank[$i][4]\n" ;
    }
    $i++ ;
  }
}

sub update_urlscore_tau {
  my $boost = shift @_ ;
  my $i=0 ; my $afterboost ; 
#  print "before $boost\n" ;
  while ( defined $urlbank[$i] ) {
    if ($urlbank[$i][2] eq $maxyear) {
      $afterboost = $boost ;
      if ( $urlbank[$i][0] =~ /(200[0-9])/ ) { #url
	$afterboost += 0.1*$boost ;
      }
      if ( $urlbank[$i][1] =~ /(200[0-9])/ ) {  #title
	$afterboost += 0.2*$boost ;
      }
#      print "$i boost=$afterboost\n" ;
      $urlbank[$i][4] += $afterboost ;
      $urlbank[$i][5] = $afterboost ;
    }
    $i++ ;
  }
}



  
  


sub get_score {
  my $firstyearscore;

  $firstyearscore = $urlbank[$firstyearrank-1][4] ;
  my $maxyearscore = $urlbank[$maxyearrank-1][4] ; 
  my $firstuponescore = $firstyearscore ;

  if($firstyearrank!=1){
    $firstuponescore = $urlbank[$firstyearrank-2][4] ;
  }
  my $firstdownonescore = $firstyearscore ;
  if( defined $urlbank[$firstyearrank]) {
    $firstdownonescore = $urlbank[$firstyearrank][4] ;
  }
  return ($firstyearscore,$maxyearscore,$firstuponescore,$firstdownonescore) ;


}


