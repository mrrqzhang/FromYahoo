my $puid="" ;
my %pvid_matrix ;
while(<>) {
  chomp() ;
  my @fields = split /\t/ ;
  my $pvid = $fields[0] ;
  my $uid = $fields[1] ;
#  if("$uid" ne "$puid") { %pvid_matrix=();} 
  my $article = $fields[5] ;
  my $key="$uid\_$article" ;
  my $action= $fields[4] ;
  if($action eq "click") {$pvid_matrix{$key}=1;}
  if( defined $pvid_matrix{$key} && $action eq "skip") {
#    print "AAA $_\n" ;
    next ;
  }
  else {
    print "$_\n" ;
  }
  $puid = $uid ;
}
