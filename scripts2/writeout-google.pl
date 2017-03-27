




my $QL ;


open QL, "<total_uniq_query.txt" ;

while(<QL>){
  chomp ;
  $ql{$_}=1 ;
}

$yes = 0 ;
my $count=0 ;
while(<>) {
  chomp() ;

  if($_ =~ /Query: (.*)/) {

    $thisquery=$1 ;
    if( defined ($ql{$1}) ) {
      $yes=1 ;
      print "$_\n" ;
      $count=0 ;
    }
  }
  if($_ =~ /    Url\:/ && $yes==1) {
    $count++ ;
    print "$_\n" ;
    if($count==5) {$yes=0;} ;
  }
  if($_ =~ /  Engine\:/ && $yes==1) {
    print "$_\n" ;
  }
}
