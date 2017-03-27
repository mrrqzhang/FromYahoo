use strict ;

#epoch=01/01/1970

my $http ;
my %map=() ;
my $year ;
my $url;
my $rawscore ;
my $dtime ;
my $lastmod ;
my $contentmod ;
my $recentlink ;
my $hosttrust ;
my $title ;
my $datemin ;
my $datemax ;
my $recentlink ;


print "output\tquery\turl\ttitle\tdtime\tlastmod\tdatemin\tdatemax\trecentlink\n" ;

my $thisquery ;
while(<>) {
  chomp() ;
#  print "$_\n" ;
  if(  /QUERY_NUMBER\:\d*\t(.*)/) {
    $thisquery = $1 ;
  }
  if( $_ =~ /^http/ ) {
    $url = $_ ; chomp($url) ;
    <> ;
    <> ;

    $title = <> ; chomp($title) ;
    if ( !($title =~ /(200[0-9])/ || $url =~ /(200[0-9])/) ) {
      next ;
    }

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

    $dtime = <> ; chomp($dtime) ; $dtime =~ /(200[0-9]).*/ ; $dtime = $1 ;
    
    $lastmod = <> ; chomp($lastmod) ; $lastmod =~ /(200[0-9]).*/ ; $lastmod=$1 ;

    $datemin = <> ; chomp($datemin) ; if($datemin!=0) {$datemin = int $datemin/365 +1970 ;}
    $datemax = <> ; chomp($datemax) ; if($datemax!=0) {$datemax = int $datemax/365 + 1970 ;}

    $recentlink = <> ; chomp($recentlink) ;
    <> ;


    print "$year\t$thisquery\t$url\t$title\t$dtime\t$lastmod\t$datemin\t$datemax\t$recentlink\n"
  }
}
