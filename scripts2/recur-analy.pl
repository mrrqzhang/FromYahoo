
my $year1="" ;
my $year2 = "" ;
my $query ="" ;
my $maxyear="" ;
my $firstyear="" ;
my $num=0 ;
my $total=0 ;
    $firstyear="" ; $firstyearrank=0; $firstyearurl="" ; $firstyearscore="" ;
    $maxyear="" ;  $maxyearrank=0; $maxyearurl="" ; $maxyearscore="" ;
while(<>) {
  chomp ;
  if(/^Query\:/) {
    if($total!=0 && $firstyear!=$maxyear)  { 
      $diff= $firstyearscore-$maxyearscore ;
#      output($query,$firstyearurl,$maxyearurl,$firstyear,$maxyear,$firstyearrank,$maxyearrank,$firstyearscore,$maxyearscore) ;
      print "$query\t$firstyearurl\t$maxyearurl\t$firstyear\t$maxyear\t$firstyearrank\t$maxyearrank\t$firstyearscore\t$maxyearscore\t$diff\n" ;
    }
#    if( $_ =~ /^Query\: ALLWORD(.*)/ ) {
#
    if ( /Query\: ALLWORDS\((.*)\)/ ) {
      $query = $1 ;

    }
    $rank = 0 ;

    if($firstyear ne "") {
      if($maxyear gt $firstyear) {
	$num++ ;
      }
    }
    $firstyear="" ; $firstyearrank=0; $firstyearurl="" ; $firstyearscore="" ;
    $maxyear="" ;  $maxyearrank=0; $maxyearurl="" ; $maxyearscore="" ;

    $total ++ ;
    next ;
  }
  $rank ++ ;
  $url = <> ; chomp($url) ;
  $title = <> ; chomp ($title);
  $abstract = <> ; chomp ($abstract);
  $score = <> ; chomp($score) ;
  
  $year1="" ;
  $year2 = "" ;
  
  if( $url =~ /(200[0-9])/ ) {
    $year1 = $1 ;
  }
  if( $title =~ /(200[0-9])/ ) {
    $year2 = $1 ; 
  }

  my $year = "" ;
  if( $year1 ge $year2 ) {
    $year = $year1 ;
  }
  else {
    $year = $year2 ;
  }
  
  if ( $year ne "" ) {
    if($firstyear eq "") {
      $firstyear=$year ;
      $firstyearrank=$rank ;
      $firstyearscore=$score ;
      $firstyearurl=$url ;
    }

    if($maxyear lt $year) {
      $maxyear=$year ;
      $maxyearrank=$rank ;
      $maxyearscore=$score ;
      $maxyearurl=$url ;
    }

#    print "$query\t$url\t$year\t$score\n" ;
  }
}
print "$total $num" ;
