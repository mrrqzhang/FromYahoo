$next=0 ;
$count=1 ;
while (<>) {
  chomp() ;
  if ( $_ =~ /^Query\: ALLWORDS\((.*)\)/ ) {
    printf "Query: $1\n" ;
    printf "  Engine: idpproxy-yahoojp1-all-the-web-production-2008-10-01\n" ;
    $count=1 ;
    $next=0 ;
  }
  if ($_ =~ /^http\:/ && $next==0 ) {
    if ($count<=30) {
      printf "     Url: $_\n" ;
      $next=1 ;
      $count++ ;
    }
    $next=1 ;
  } elsif ($_ =~ /^http\:/) {
    $next=0;
  }
  ;

}
    
