
#from format ALL.tsv.train to B- I- crf format 

use strict ;
my $qid=0 ;
my %dict=() ;
while(<>) {
  chomp() ;
  my $tag="" ;
  my @fields = split /\t/ ;
  if($#fields<0) {next ;}
  my $query = $fields[1] ;
  if($query eq "") {next;}
  my $words="" ;
  my $scores = $fields[3] ;
  if($fields[3] =~ /autoscore: (.*)/) {$scores=$1;}
  for(my $i=4; $i<=$#fields; $i+=2) {
    my $term=$fields[$i] ;
    $words .= "$term " ;
    my $interp= $fields[$i+1] ;
    my @termfields = split /\s+/,$term ;
    if($interp ne "token") {
       for(my $j=0;$j<=$#termfields; $j++) {
	 if($j==0) {$tag .="B-$interp " ;}
	 else {$tag .="I-$interp " ;}
      }
    }
    else {
      for(my $j=0;$j<=$#termfields; $j++) {
          $tag .= "$interp " ;
      }
    }
  }
  my $tag1 = substr($tag,0,length($tag)-1) ;
  my $words1 = substr($words,0,length($words)-1) ;
  my $key = "$words1\t$tag1" ;
  if($tag ne "" && !defined $dict{$key}) {
#	print "$qid\t0\t$words\t$tag\t\t$scores\n" ;$qid++ ;
	print "$qid\t0\t$words1\t$tag1\n" ;$qid++ ;
	$dict{$key}=1 ;
  }
}
	


#cat ALL.tsv.train | perl ~/scripts/scorer2crf.pl | sort | uniq | awk '{print NR"\t"$0}' >& ALL.tsv.crf	
