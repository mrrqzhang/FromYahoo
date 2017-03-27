
my $line=<> ;
chomp() ;
my @fields_out = split /\t/, $line ;
my $psession = $fields_out[1] ;
my $puid = $fields_out[0] ;
my $ppvid = "$puid\_$psession" ;

#  print "$puid $ppvid $psession \t$_\n";
while(<>) {
  chomp() ;
  my @fields = split /\t/ ;
  my $contenttype = $fields[5] ;
  my $bpos = $fields[6] ;
  my $cpos = $fields[7] ;
  my $pkgt = $fields[8] ;
  my $session = $fields[1] ;
  my $uid = $fields[0] ;
  my $pvid = "$uid\_$session" ;
  my $timediff = $session-$psession ;
#  print "$temp $uid $puid $ppvid\t$_\n" ;
  my $session_change=0 ;
  if("$uid" ne "$puid") {$session_change=1 ;}
  if( ("$uid" eq "$puid") && ($session-$psession>=30) ) {$session_change=1;} 

#  print "session change=$session_change  $bpos $ppvid\n" ;
  if(  ($contenttype eq "story") && $pkgt==3 && ($session_change==0) && ( "$uid" eq "$puid") ) { 
     print "$ppvid\t$_\n" ;
     $psession=$session ;
  }   
  else {
     if(($session_change==1)  ) { # new session start from bpos=1  
#       if($timediff>=30 && bpos==1 &&   "$uid" eq "$puid") { print "NOTUSED $timediff\t$_\n" ;}
       if(($contenttype eq "story") && $bpos==1 && $pkgt==3 && $timediff>=7200 ) {print "$pvid\t$_\n" ;}
#       if($timediff>=7200 &&  "$uid" eq "$puid") { print "tooooooooo $timediff\n" ;}
       if(("$uid" ne "$puid") || ($timediff>=7200) ) {$psession = $session ;}        
       $puid=$uid ;
       $ppvid=$pvid ;
     }
  }    
}  
  
