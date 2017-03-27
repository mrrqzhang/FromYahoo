use strict ;
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

print "query\turl\trawscore\tdtime\tlastmod\tcontentmod\trecentlink\tweightrecentlink\thosttrust\n" ;

my $thisquery ;
while(<>) {
  chomp() ;
#  print "$_\n" ;
  if(  /QUERY_NUMBER\:\d*\t(.*)/) {
    $thisquery = $1 ;
  }
  if( $_ =~ /^http/ ) {
    $url = $_ ; chomp($url) ;
    <> ; chomp() ;
    $rawscore = <> ; chomp($rawscore) ;
    $dtime = <> ; chomp($dtime) ;
    <> ;
    $lastmod = <> ; chomp($lastmod) ;
    $contentmod = <> ; chomp($contentmod) ;
    $recentlink = <> ; chomp($recentlink) ;
    <> ;
    $hosttrust = <>; chomp($hosttrust) ;

    print "$thisquery\t$url\t$rawscore\t$dtime\t$lastmod\t$contentmod\t$recentlink\t$hosttrust\n"
  }
}
