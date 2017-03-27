use strict ;


if($#ARGV<1){
  print "INPUT: wordseg-map-file oringinal-dict\n" ;
  exit ;
}

my $WORDSEG ;
my $INPUT ;
my $OUTPUT ;
my %wsmap=() ;
my @val = ();


open WORDSEG, "<$ARGV[0]" ;
while(<WORDSEG>){
  chomp ;
  my @fields = split "\t" ;
  $wsmap{$fields[0]} = $fields[1] ;
}


open INPUT, "<$ARGV[1]" ;

while(<INPUT>) {
  chomp ;
  my @fields = split "\t" ;
  my $query ;
  if(defined $wsmap{$fields[0]}) {
    $query = $wsmap{$fields[0]} ;
  }
  else { next ;}
  my $temp = $fields[1]+1 ;
  my $year = "$fields[1],$temp" ;
  $val[0]=0.5 ;
  $val[1]=1.0 ;
  $val[2]=2.0 ;
  $val[3]=3.0 ;
  $val[4]=$fields[2] ;
  $val[5]=$fields[2]; if($val[5]>5){$val[5]=5;} ;
  $val[6]=$fields[2]; if($val[6]>6){$val[6]=6;} ;
  $val[7]=$fields[2]+0.5; if($val[7]>5){$val[7]=5;} ;
  $val[8]=$fields[2]+0.5; if($val[8]>6){$val[8]=6;} ;
  $val[9]=$fields[2]+1.0; if($val[9]>5){$val[9]=5;} ;
  $val[10]=$fields[2]+1.0; if($val[10]>6){$val[10]=6;} ;
  $val[11]=$fields[2]+1.5; if($val[11]>5){$val[11]=5;} ;
  $val[12]=$fields[2]+1.5; if($val[12]>6){$val[12]=6;} ;
  $val[13]=$fields[2]+2.0; if($val[13]>5){$val[13]=5;} ;
  $val[14]=$fields[2]+2.0; if($val[14]>6){$val[14]=6;} ;
  print "$query\t$year\t$val[0]\t$val[1]\t$val[2]\t$val[3]\t$val[4]\t$val[5]\t$val[6]\t$val[7]\t$val[8]\t$val[9]\t$val[10]\t$val[11]\t$val[12]\t$val[13]\t$val[14]\n" ;
}

