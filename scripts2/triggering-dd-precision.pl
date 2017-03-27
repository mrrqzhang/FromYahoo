my $editorqry = $ARGV[0] ;

my $thrshd_itpt = $ARGV[1] ;

my $topn = $ARGV[2] ;
#my $PRODUCT_BASELINE=1772 ;
my $thrshd_diff=$ARGV[3] ;

open DICT, "<$ARGV[0]" ;
my %dict=() ;
my $total = 0 ;
while(<DICT>) {
  chomp() ;
  @words = split /\t/ ;
#  print "$words[0]\t$words[1]" ;

  $words[0] =~ /^(.*\S) *$/ ;
  $words[0]=$1 ;
  if( ! defined  $dict{$words[0]}){
    $dict{$words[0]}= $words[$#words] ;
  }
  $total++ ;
}




my $PRODUCT_BASELINE=207  ; #travel
my $num_intp=0 ;
my @array_intp=() ;
<STDIN>; #skip the first line \#    ^version

my $triggerednum=0 ;
my $totalnum=0 ;
my $correct=0 ;
while(<STDIN>) {
    chomp() ;
    if(/^\#.*\^/) {
	my $num=$topn<$#array_intp?$topn:$#array_intp;
	my $max_itpt=0 ;
        my $output=0 ;
        my $qrw="" ;
	for(my $ip=0; $ip<$#array_intp; $ip++) {
	    my @fields = split /\t/,$array_intp[$ip] ;
	    if($ip==0) {$max_itpt=$fields[$#fields] ;}
#            print "$max_itpt\t$num\t$fields[0]\n" ;
	    my $query = $fields[0] ;
            
	    my $jabbarule = $fields[$#fields-2] ;

#	   if($jabbarule=~ /jabba\:product/) {
	    if($jabbarule=~ /jabba\:travel/) {
#	    if($jabbarule=~ /jabba\:movie/) { 
#		print "$array_intp[$ip]\n" ;
		$totalnum++ ;
		my $itpt_score=$fields[$#fields] ;
		my $diff = $max_itpt - $itpt_score ;
		if($itpt_score>=$thrshd_itpt && $diff<$thrshd_diff && $output==0 && $ip<$num) {
	#	if($itpt_score>=$thrshd_itpt  && $output==0 && $ip<$num) {
		    my $ipnum=$ip+1 ;
		    print "$query\t$ipnum\t$itpt_score\t$diff\t$max_itpt" ;
 		    $output=1 ;
		    $qrw=$query ;
		    $triggerednum++ ;
                    print "\ttriggered" ;
		    if( defined $dict{$query} ) {
			$correct++ ;
			print "\tcorrect" ;
		    }
		    
		}
		    
	    }
	    if($output==1 && $query ne $qrw ) {print "\t$query" ;}
	    
	}
        if($output==1) {print "\n" ;}
	$num_intp=0 ;
	@array_intp=() ;
	next ;
    }
    $array_intp[$num_intp] = $_ ;
    $num_intp++ ;

}

#my $coverage=$triggerednum/$PRODUCT_BASELINE ;
my $precision=$correct/$triggerednum ;
my $recall = $correct/$total ;
my $fscore=2.0*($precision*$recall)/($precision+$recall) ;

# print "correct=$correct  total=$total\n" ;
#print "|topn|thrshd_itpt|triggerednum|totalnum|precision|recall|fscore|\n" ;

printf "|%f|%f|%f|%f|%f|%f|%f|%f|\n", $topn,$thrshd_itpt,$thrshd_diff,$triggerednum, $totalnum, $precision, $recall, $fscore ;
#printf "%f %f %f %f %f %f %f %f\n", $topn,$thrshd_itpt,$thrshd_diff,$triggerednum, $totalnum, $precision, $recall, $fscore ;	
