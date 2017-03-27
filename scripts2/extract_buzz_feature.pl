use strict ;

my %usedfeature=()  ;

my $UF ;
my $CSV ;
my @csv ;

open UF, "<used_features.txt" ;

while (<UF>) {
  chomp() ;
  my @fields = split "," ;
  for (my $i=0;$i<=$#fields; $i++) {
    #    print "$fields[$i]\n" ;
    $usedfeature{$fields[$i]} = 1 ;
  }
}

open CSV, "<$ARGV[0]" or die ;

my $line = <CSV> ;
my $first=0 ;
chomp($line) ;

my @fields = split "," , $line ;
for (my $i=0;$i<=$#fields;$i++) {
  $csv[$i]=0 ;
  if ( defined $usedfeature{$fields[$i]} ) {
    $csv[$i]=1 ;
    if ($first==0) {
      printf "$fields[$i]" ;$first=1 ;
    } else {
      printf ",$fields[$i]" ;
    }
  
  }

}

printf "\n" ;



while (<CSV>) {
  chomp() ;
  $first=0 ;
  my @fields = split "," ;
  for (my $i=0;$i<=$#fields;$i++) {
    if ( $csv[$i]==1 ) {
      if ($first==0) {
	printf "$fields[$i]" ;$first=1 ;
      } else {
	printf ",$fields[$i]" ;
      }
    }      

  }
  printf "\n" ;
}
