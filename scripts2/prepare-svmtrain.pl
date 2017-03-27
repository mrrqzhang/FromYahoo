#>2008:0 =2007:1 <2007:2

#dtime   (3)
#lastmod (3)
#dmin    (3)
#dmax    (3)
#dtime+lastmod (9)
#dtime+dmin    (9)
#dmin+dmax     (9)
#lastmod+dmax  (27)
#dtime+dmin+dmax (27)


#scheme1: only dtime 
#scheme2: first above four
#scheme3: first above 8
#scheme4: first above 9

my $scheme = $ARGV[1] ;
open IN,"<$ARGV[0]" ;


my %map=() ;
my %ftype=() ; #feature type
my $ftnum=1 ;

my $num=0 ;
my $first, $second, $third ;

my $gindex=1 ;

my $tag="dtime:" ;
$ftype{$tag} = $ftnum ; $ftnum++ ;

get_index($tag, 1) ;

$tag = "lastmod:" ;
$ftype{$tag} = $ftnum; $ftnum++ ;

get_index($tag, 1) ;

$tag = "dmin:" ;
get_index($tag, 1) ;
$ftype{$tag}=$ftnum ; $ftnum++ ;


$tag = "dmax:" ;
get_index($tag, 1) ;
$ftype{$tag}=$ftnum ; $ftnum++ ;


$tag = "dtime+lastmod:" ;
get_index($tag, 2) ;
$ftype{$tag}=$ftnum ; $ftnum++ ;


$tag = "dtime+dmin:" ;
get_index($tag, 2) ;
$ftype{$tag}=$ftnum ; $ftnum++ ;


$tag = "dmin+dmax:" ;
get_index($tag, 2) ;
$ftype{$tag}=$ftnum ; $ftnum++ ;


$tag = "lastmod+dmax:" ;
get_index($tag, 2) ;
$ftype{$tag}=$ftnum ; $ftnum++ ;



$tag = "dtime+dmin+dmax:" ;
get_index($tag, 3) ;
$ftype{$tag}=$ftnum ; $ftnum++ ;



<IN> ;
if($scheme==1) {
  
  while(<IN>) {
    chomp() ;
    @out = split '\t' ;

    if($out[0] >= 2008) { $outtag = 0;}
    else {$outtag=1 ;}
    $tag = "dtime:" ;
    $year = transfer($out[4]) ;
    if( !defined $map{$tag.$year} ) { next ;}
    printf "%d\t%d:%d\n",$outtag, $ftype{$tag}, $map{$tag.$year} ;
  }
}
elsif($scheme==2) {
  while(<IN>) {
    chomp() ;
    @out = split '\t' ;

    if($out[0] >= 2008) { $outtag = 0;}
    else {$outtag=1 ;}

    $year1 = "dtime:".transfer($out[4]) ;
    $year2 = "lastmod:".transfer($out[5]) ;
    $year3 = "dmin:".transfer($out[6]) ;
    $year4 = "dmax:".transfer($out[7]) ;

    if( ! (defined $map{$year1} || defined $map{$year2} || defined $map{$year3} || defined $map{$year4}) ) { next ;}
    

    printf "%d\t", $outtag ;
    if(defined $map{$year1}){ printf "%d:%d\t", $ftype{"dtime:"},$map{$year1} ;}
    if(defined $map{$year2}){ printf "%d:%d\t", $ftype{"lastmod:"},$map{$year2} ;}
    if(defined $map{$year3}) {printf "%d:%d\t", $ftype{"dmin:"},$map{$year3} ;}
    if(defined $map{$year4}) {printf "%d:%d\t", $ftype{"dmax:"},$map{$year4} ;}
    printf "\n" ;

  }
}
elsif ($scheme==3) {
  while (<IN>) {


    chomp() ;
    @out = split '\t' ;

    if ($out[0] >= 2008) {
      $outtag = 0;
    } else {
      $outtag=1 ;
    }

    $year1 = "dtime:".transfer($out[4]) ;
    $year2 = "lastmod:".transfer($out[5]) ;
    $year3 = "dmin:".transfer($out[6]) ;
    $year4 = "dmax:".transfer($out[7]) ;
    $year5 = "dtime+lastmod:".transfer($out[4]).transfer($out[5]) ;
    
    $year6 = "dtime+dmin:".transfer($out[4]).transfer($out[6]);
    $year7 = "dmin+dmax:".transfer($out[6]).transfer($out[7]) ;
    $year8 = "lastmod+dmax:".transfer($out[5]).transfer($out[7]) ;

    if ( ! (defined $map{$year1} || defined $map{$year2} || defined $map{$year3} || defined $map{$year4} || defined $map{$year5} || defined $map{$year6} || defined $map{$year7} ||  defined $map{$year8}      ) ) {
      next ;
    }

    printf "%d\t", $outtag ;
    if (defined $map{$year1}) {
      printf "%d:%d\t", $ftype{"dtime:"},$map{$year1} ;
    }
    if (defined $map{$year2}) {
      printf "%d:%d\t", $ftype{"lastmod:"},$map{$year2} ;
    }
    if (defined $map{$year3}) {
      printf "%d:%d\t", $ftype{"dmin:"},$map{$year3} ;
    }
    if (defined $map{$year4}) {
      printf "%d:%d\t", $ftype{"dmax:"},$map{$year4} ;
    }
    if (defined $map{$year5}) {
      printf "%d:%d\t", $ftype{"dtime+lastmod:"},$map{$year5} ;
    }
    if (defined $map{$year6}) {
      printf "%d:%d\t", $ftype{"dtime+dmin:"},$map{$year6} ;
    }
    if (defined $map{$year7}) {
      printf "%d:%d\t", $ftype{"dmin+dmax:"},$map{$year7} ;
    }
    if (defined $map{$year8}) {
      printf "%d:%d", $ftype{"lastmod+dmax:"},$map{$year8} ;
    }
    printf "\n" ;
  }
}
elsif($scheme==4) {

  while (<IN>) {

    chomp() ;
    @out = split '\t' ;

    if ($out[0] >= 2008) {
      $outtag = 0;
    } else {
      $outtag=1 ;
    }

    $year1 = "dtime:".transfer($out[4]) ;
    $year2 = "lastmod:".transfer($out[5]) ;
    $year3 = "dmin:".transfer($out[6]) ;
    $year4 = "dmax:".transfer($out[7]) ;
    $year5 = "dtime+lastmod:".transfer($out[4]).transfer($out[5]) ;
    
    $year6 = "dtime+dmin:".transfer($out[4]).transfer($out[6]);
    $year7 = "dmin+dmax:".transfer($out[6]).transfer($out[7]) ;
    $year8 = "lastmod+dmax:".transfer($out[5]).transfer($out[7]) ;
    $year9 = "dtime+dmin+dmax:".transfer($out[4]).transfer($out[6]).transfer($out[7]) ;
    if ( ! (defined $map{$year1} || defined $map{$year2} || defined $map{$year3} || defined $map{$year4} || defined $map{$year5} || defined $map{$year6} || defined $map{$year7} ||  defined $map{$year8}   || defined $map{$year9}   ) ) {
      next ;
    }

    printf "%d\t", $outtag ;
    if (defined $map{$year1}) {
      printf "%d:%d\t", $ftype{"dtime:"},$map{$year1} ;
    }
    if (defined $map{$year2}) {
      printf "%d:%d\t", $ftype{"lastmod:"},$map{$year2} ;
    }
    if (defined $map{$year3}) {
      printf "%d:%d\t", $ftype{"dmin:"},$map{$year3} ;
    }
    if (defined $map{$year4}) {
      printf "%d:%d\t", $ftype{"dmax:"},$map{$year4} ;
    }
    if (defined $map{$year5}) {
      printf "%d:%d\t", $ftype{"dtime+lastmod:"},$map{$year5} ;
    }
    if (defined $map{$year6}) {
      printf "%d:%d\t", $ftype{"dtime+dmin:"},$map{$year6} ;
    }
    if (defined $map{$year7}) {
      printf "%d:%d\t", $ftype{"dmin+dmax:"},$map{$year7} ;
    }
    if (defined $map{$year8}) {
      printf "%d:%d", $ftype{"lastmod+dmax:"},$map{$year8} ;
    }
    if (defined $map{$year9}) {
      printf "%d:%d", $ftype{"dtime+dmin+dmax:"},$map{$year9} ;
    }
    printf "\n" ;
  }
};




sub transfer {
  my $y = shift @_ ;
  if($y != 0 ){
    if($y>=2008) {$y=2008;}
    elsif ($y<2007) {$y=2006;}
  }
  return $y ;
}


sub get_index {
  my ($head, $num) = @_ ;
  if ($num==3) {
    for ($first=2006; $first<=2008; $first++) {
      for ($second=2006;$second<=2008;$second++) {
	for ($third=2006; $third<=2008;$third++) {
	  $key="$head$first$second$third" ;
	  $map{$key}=$gindex ;
	  $gindex++ ;
	}
      }
    }
  }
  if ($num==2) {
    for ($first=2006; $first<=2008; $first++) {
      for ($second=2006;$second<=2008;$second++) {
	$key="$head$first$second" ;
	$map{$key}=$gindex ;
	$gindex++ ;
      }
    }
  }
  if ( $num==1) {
    for ($first=2006; $first<=2008; $first++) {
      $key="$head$first" ;
      $map{$key}=$gindex ;
      $gindex++ ;
    }
  }
}


