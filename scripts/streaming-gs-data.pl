
my $line=<> ;
chomp() ;
my @fields_out = split /\t/, $line ;
my $psession = $fields_out[1] ;
my $puid = $fields_out[0] ;
my $ppvid = "$puid\_$psession" ;

my $new_session=0 ;
while(<>) {
  chomp() ;
  my @fields = split /\t/ ;
  my $contenttype = $fields[5] ;
  my $action = $fields[3] ;
  my $bpos = $fields[6] ;
  my $cpos = $fields[7] ;
  my $pkgt = $fields[8] ;
  my $session = $fields[1] ;
  my $uid = $fields[0] ;
  my $pvid = "$uid\_$session" ;
#  print "$new_session $uid $puid $ppvid\t$_\n" ;
 
  if( ( ($new_session==1) && ( $click_session < $session)) || ("$uid" ne "$puid") ) {
#     print "AAAA $new_session $uid $puid $ppvid\t$_\n" ;
     $ppvid = $pvid ;
     $new_session=0 ;
     $click_session=$session ;
     $puid = $uid ;
  }
  if($action eq "click") {
      if( ($contenttype eq "story") ) {
         print "$ppvid\t$_\n" ;
       }
       $click_session = $session ;
       $new_session=1 ;
   }
   if($action eq "skip" &&  ($contenttype eq "story") ) {
#     if("$ppvid" ne "$pvid" && ($click_session == $session )) {print "BBBB $new_session $uid $puid $ppvid\t$_\n" ;}
      print "$ppvid\t$_\n" ;
    }


}  
  
