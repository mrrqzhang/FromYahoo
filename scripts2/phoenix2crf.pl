
#Phoenix format to B- I- crf format 


#local $/ = "\r\n";  # use this if file from windows

use strict ;

my %v2taxo=() ;


if($ARGV[0] eq ""){print "must have a start line id number" ; exit;}
my $startid=$ARGV[0] ;

open TAXOV2, "</net/mlrnfs/vol/ss01/ruiqiang/dev-qlas/qlas/misc/scorer/data/mapping_from_editorial_to_eng.v2.txt" or die "taxonomy.v2 not found" ;

while(<TAXOV2>) {
    chomp() ;
    my @fields = split /\t/ ;
    my $key = "$fields[1]" ;
    if($fields[2] =~ /taxonomy/) {$key="$fields[1]($fields[2])" ;}
    $v2taxo{$key}=1 ;
    
}
$v2taxo{"dish"}=1 ;  #this one not defined 

#local $/ = "\r\n";  # for unix change to "\n"

sub separate_interp {
  my ($interp, $wordinterp) = @_ ; 
  my @fields = split / /, $interp ;
  my $qry="" ;
  my $interp="" ;
  my $n=0 ;
  $interp = "$fields[0]" ;
  for(my $i=1; $i<=$#fields ; $i++) {
     if($fields[$i]=~/\[/) {
	${$wordinterp}[$n]=$interp ;
	$n++ ;
	${$wordinterp}[$n]=$fields[$i] ;
	$n++ ;
	$interp="$fields[$i+1]" ;$i++ ;
     }
     else {
	$interp = "$interp $fields[$i]" ;
     }
  }
#  print "$fields[0] @{$wordinterp}\n" ;
}

my $bad_format=0 ;
my %keysort=() ;
while(<STDIN>) {
  $bad_format=0 ;

  if($_=~/#/){next;}
  chomp() ;
  my @fields = split /\t/ ;
  if($#fields != 2){next ;}
#  print "$_\n" ;
  my $query = $fields[1] ;
  if($query eq "") {next;}
  my $interp2 = $fields[2] ;
  $interp2 =~ s/, industry/,industry/g ;
  my @words = () ;
  my @crfvec=() ;
  $crfvec[0]="" ;
  separate_interp($interp2,\@words) ;
  my @crfvec2=() ;
    my $query2="" ;
  for(my $d=0; $d<=$#words ;$d+=2) {
      if($d==0) {$query2="$words[$d]" ;}
      else {$query2 .= " $words[$d]" ;}
    my $term=$words[$d] ;
    my $taxo=$words[$d+1] ;
#    print "$term $taxo\n" ;
    my @tokens = split / /, $term ;
    my $tn = $#tokens+1 ;
    my @taxovec = split /,/, $taxo ;
    if($#taxovec>1) {print "ERROR: format not supported. more than two attributes for a single entity. $_" ; exit ;}    
    my $oldsize=$#crfvec+1 ;
    if($#taxovec==1) {
        if($taxovec[0] =~ m/(.*):(.*)/) {
                $taxovec[1]="$1:$taxovec[1]" ;
        }
    }
    my $n=0 ;
    for(my $k=0 ;$k<=$#taxovec;$k++) {
       my $str2=$taxovec[$k] ;
#       print "$str2\n" ;
       $str2 =~ s/\[//g ;
       $str2 =~ s/\]//g ;
       $str2 =~ s/\"//g ;  #[brand_name:brand_type=/model,industry=/home_garden]  I-place_name(^taxonomy:place_category=/city)
       $str2 =~ s/\:/\(\^taxonomy\:/g ;
       if($str2 =~/taxonomy/)  { $str2 = "$str2)" ;}
#        print "$str2\n" ;
       if(!defined ($v2taxo{$str2})) {$bad_format=1; last;}
        my $str="" ;
        
       for(my $j=0; $j<$tn; $j++) {
	     if($j==0) {$str="B-$str2" ;}
	     else {$str="$str I-$str2" ;}
       }
        if($taxovec[$k] =~ m/token/) {$str="token";}
        
       
       for(my $i=0; $i<=$#crfvec; $i++) {
            $crfvec2[$n] = $crfvec[$i] ;
            if($crfvec2[$n] eq "") {$crfvec2[$n] = "$str" ;}
            else { $crfvec2[$n] .= " $str" ;}
 	         $n++ ;
       }
    }
      if($bad_format==1) {last;}
    @crfvec = @crfvec2 ;
  }
    if($bad_format==1) {next;}
  for(my $i=0; $i<=$#crfvec; $i++) {
      my $key = "$query2\t$crfvec[$i]" ;
      if(!defined $keysort{$key}) {$keysort{$key}=1 ;}
  }

}
my $key="" ;

foreach $key ( sort keys %keysort ) {
    print "$startid\t0\t$key\n" ;
    $startid++ ;
}


