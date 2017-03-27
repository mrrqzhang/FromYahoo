use strict ;


#usage perl query-output.pl ipdout-all.txt $yearalgo  $yearsum.ind
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



open IN, "$ARGV[0]" ;

#my $IN="STDIN" ;

my $scheme =  "scheme3" ;

my $yearalgo = "tau" ; 


my @urlbank=()  ;
my $maxyear ;
my $firstyear ;
my $firstyearrank;
my $maxyearrank ;
my $thisquery ;
my $firstyearrankscore ;
my $maxyearrankscore ; 
my $maxyearboost ;
my %yearmap = () ;

my $DICT ;


if( -e $ARGV[1] ){
  $yearalgo = $ARGV[1] ;
};

if( -e $ARGV[2] ){
  open DICT, "<$ARGV[2]" ;
};




while(<IN>) {
  if ( /query\:ALLWORDS\((.*)\)/ ) {
    $thisquery = $1 ;

    last ;
  }
}

my $stop = 1 ;

my $diff = 0 ;

my $nextquery =  $thisquery;

my $queryid=0 ;
#while ( eof IN$stop==1) {
while( ! (eof IN) ) {
  @urlbank=() ;

  all_query_url( ) ; 

  DE_cluster_adjust() ;
  
  first_year(\$firstyear, \$firstyearrank) ;
  $maxyear = $firstyear ;
  $maxyearrank = $firstyearrank ;
  max_year(\$maxyear,\$maxyearrank) ;



#  print "$firstyear  $maxyear $firstyearrank $maxyearrank\n" ;  
  if ($firstyear>=$maxyear || $firstyearrank>5) {
    $thisquery = $nextquery ;
    next;
  };

#  @sorted = sort { $b->[4] <=> $a->[4] } @urlbank ;

  $maxyearboost = $urlbank[$maxyearrank-1][5] ;
  $maxyearrankscore = $urlbank[$maxyearrank-1][4] ;

#  print_askout() ;
  adjust_urlscore() ;

  my $pri=0 ;
  $pri = reordertop(5) ;

#  if($pri==1) { print_askout() ;}

  if($pri==1) {print "$thisquery\t$maxyear\t$maxyearboost\n" ;}

  

  $thisquery = $nextquery ;
  
}

sub print_askout {
  my $i ;

  
  print "$thisquery\tfirstyear:$firstyear\tfrank:$firstyearrank\tmaxyear:$maxyear\tmrank:$maxyearrank\tboost:$maxyearboost\t$maxyearrankscore\n" ;
  print "  Engine: idpproxy-jp-all-the-web-directory_on-production-2008-08-13\n" ;
  for($i=0;$i<5;$i++) {
    print "    Url: $urlbank[$i][0] $urlbank[$i][1] $urlbank[$i][4]\n" ;
  }

#  print "Query:\t$thisquery\n" ;
#  print "  Engine: idpproxy-jp-all-the-web-directory_on-production-$scheme-2008-08-13\n" ;
#  for($i=0;$i<5;$i++) {
#    print "    Url: $urlbank[$i][0]\n" ;
#  }
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
 

  while (<IN>) {

    my $url ;
    while( 1 ){
      $url = <IN> ; chomp($url) ;
      if ( $url =~ /query\:ALLWORDS\((.*)\)/) {
	$nextquery=$1;
	
#	print "$nextquery\n" ;
	return ;
      }
#      print "$url\n" ;
      if( eof IN ) {return;}
      if( $url =~ /^http/ ) { $url =~ s/\t/ /g ; last;}
    }
    <IN> ;
    my $score = <IN> ; chomp($score) ;
    
    my $title = <IN> ; chomp ($title);  $title =~ s/\t/ /g ;

    my $dtime; # = <IN> ; chomp($dtime) ; $dtime =~ /(200[0-9]).*/ ; $dtime = $1 ;

    my $lastmod; # = <IN> ; chomp($lastmod) ;  $lastmod =~ /(200[0-9]).*/ ; $lastmod=$1 ;

    my $datemin;# = <IN> ; chomp($datemin) ; if($datemin!=0) {$datemin = int ($datemin/365) +1970 ;};

    my $datemax ; #= <IN> ; chomp($datemax) ;  if($datemax!=0) {$datemax = int ($datemax/365) + 1970 ;}
    

#    my $abstract = <IN> ; chomp ($abstract);

#    print "$rank $title\n" ;
    
    my $year = "" ;
       
    my $year1="" ;
    my $year2 = "" ;
    if ( $yearalgo eq "tau" ) {
=begin
	if ($url =~ /(19[0-9][0-9])/ ) {
	  $year1 = $1 ;
	}

      if ( $url =~ /(200[0-9])/  ) {
	$year1 = $1 ;
      }
=cut
	if ($url =~ /[[:punct:]](19[0-9][0-9])[[:punct:]]/ ) {
	  $year1 = $1 ;
	}

      if ( $url =~ /[[:punct:]](20[0-1][0-9])[[:punct:]]/  ) {
	$year1 = $1 ;
      }

      if ( $title =~/(19[0-9][0-9])/) {
	$year2 = $1 ;
      }
      if ( $title =~ /(20[0-1][0-9])/  ) {
	$year2 = $1 ;
      }


      if ( $year1 ge $year2 ) {
	$year = $year1 ;
      } else {
	$year = $year2 ;
      }
    } elsif ( $yearalgo eq "tau2" ) {
      if ( ($title =~ /(200[0-9])/ || $title =~/(19[0-9][0-9])/ || $url =~ /(19[0-9][0-9])/ || $url =~ /(200[0-9])/) ) {
	if ( $url =~ /(200[0-9])/ || $url =~ /(19[0-9][0-9])/) {
	  $year1 = $1 ;
	}
	if ( $title =~ /(200[0-9])/ || $title =~/(19[0-9][0-9])/) {
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
	my $line = <DICT> ;
	chomp($line) ;
	my @out = split '\t', $line ;
	my $mapkey = "$out[0]\t$out[1]" ;
	my $key = "$thisquery\t$url" ;
	if (  $mapkey eq $key ) {
	  $year = $out[2] ;
	  if($dtime<2008 && $lastmod>=2008) {$year="";}  # due to training svm bug 
	} else {
	  print "cannot match year index $key ||| $mapkey\n";
	}
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
    my $upstep = $firstyearrankscore-$maxyearrankscore+($firstuponescore-$firstyearrankscore+0.1)/10.0 ;
    my $downstep = $firstyearrankscore-$maxyearrankscore-($firstyearrankscore-$firstdownonescore+0.1)/10.0 ;
    my $equalstep =  $firstyearrankscore-$maxyearrankscore;
    my $year_span_weight=1.0 ;
    if( $maxyear-$firstyear==1) { $year_span_weight=0.8; }
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
#	if($boost>2.0) {$boost=2.0;}
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
#  print "$boost $maxyear\n" ;
  while ( defined $urlbank[$i]  ) {
    if ($urlbank[$i][2] eq $maxyear) {
#      print "$urlbank[$i][2]  and rank: $urlbank[$i][3] and before boost: $urlbank[$i][4]\n" ;
#      if($boost>2.0){$boost=2.0;}
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
      if ( $urlbank[$i][0] =~ /(20[0-1][0-9])/ ) { #url
	$afterboost += 0.1*$boost ;
      }
      if ( $urlbank[$i][1] =~ /(20[0-1][0-9])/ ) {  #title
	$afterboost += 0.2*$boost ;
      }
#      print "$i boost=$afterboost\n" ;
      if($afterboost>2.0) {$afterboost=2.0;}
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


