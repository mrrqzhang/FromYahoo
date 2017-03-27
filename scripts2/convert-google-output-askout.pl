
$#ARGV==1 or die "program: engine_name googleformatfile\n" ;



my @urlbank=() ;

my $stop = 0 ;

my $engine_name = $ARGV[0]  ;

my $thisquery="" ;

my $nextquery = "" ;

my $start=1 ;

my $firsturl = "" ;

my $IN ;
open IN, "<$ARGV[1]" ;

$firsturl=<IN> ;
chomp($firsturl) ;

while( ! (eof IN) ) {
  @urlbank=() ;

  all_query_url( ) ;

  print_askout() ;

  $thisquery = $nextquery ;

}






sub print_askout {
  my $i ;


  print "Query: $thisquery\n" ;
  print "  Engine: $engine_name\n" ;
  for($i=0;$i<5;$i++) {
    print "    Url: $urlbank[$i]\n" ;
  }

}



sub all_query_url {

  my $rank=1 ;
  $stop = 1 ;


  while (1) {

      my $url ;
      if( $start ==1 ) {$url = $firsturl ;}
      else {  
        $url = <IN> ; chomp($url) ;
      }
      my @fields = split /\t/, $url ;
      if($start == 1 ) {
	$thisquery = $fields[1] ;
        $start = 0 ;
      }
      if( $fields[1] ne $thisquery ) {
        $nextquery=$fields[1];
        $firsturl = $url ;
        $start = 1 ;
        return ;
      }
      $url = $fields[2] ;
      $urlbank[$rank-1] = $fields[2] ;
      $rank++ ;
      if( eof IN ) {return;}
 

  }
  if ( eof IN ) {
    $stop=0 ;
  }
  return  ;
}

