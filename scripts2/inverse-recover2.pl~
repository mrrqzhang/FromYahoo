#!/usr/releng/bin/perl

open IN, "<$argv[0]" ;


%dict=() ;

while(<>) {
  chomp(); 
  @words = split /\t/ ;
  $query = $words[0] ;
  $query =~ s/[[:punct:]]/ /g ;
#  if($query =~ /^[[:punct:]\s]*$/ ) {next;} 
  if ( $words[0] =~ /^\s*$/ ) {
    next;
  }
  @out = split ' ', $query ;
  for ($i=0; $i<=$#out; $i++) {
    $dict{$out[$i]} += $words[1] ;
  }	
}




while (<>) {
  chomp() ;
  @input = split /\t/ ;
  $year = $input[1] ;
  @words = split ' ', $input[0]  ;
  $len = $#words ;
  $start=0;
  $end=$len+1 ;

  while ($start!=$end && $start<=$len) {
    $query = get_words($start, $end, \@words) ;

    if ( defined $dict{$query} ) {
      print "$query " ;
      $start=$end  ;
      $end = $len+1 ;
    } else {

      $end -- ;
      if ($start==$end) {
	print "$query " ;
	$start++ ;
	$end=$len+1 ;
      }

    }
  }
  print "\t$year\n" ;
}


sub get_words {
  my ($s, $e,$wd) = @_ ;
  @wds = @$wd ;

  my $out = $wds[$s] ;
  if( $s == $e-1) { return $out;}
  for($i=$s+1; $i<$e; $i++) {
    if($wds[$i] =~ /^[[:alnum:]]*$/) { $out = "$out $wds[$i]" ;}
    else {    $out = "$out$wds[$i]" ;}
  }
  return $out ;
}
