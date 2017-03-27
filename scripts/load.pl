
my $session=0 ;
while(<>) {
    chomp() ;
    my @fields = split /\t/ ;
    my $N=$#fields ;
    my %qdict=() ;
    $session++ ;
    my $this_q="" ;
    my $this_u="" ;
    my $qpos=0 ;
    my $printout=0 ;
    for(my $i=2; $i<=$N; $i++) {
        if($fields[$i] =~ /^Q\:\:/) {
            $qpos++ ;
            my @fields2 = split /:/, $fields[$i] ;
            $this_q = $fields2[2] ;
            $qdict{$this_q} = "$session\t$qpos\t$this_q\t0\t0" ;
        }
        if($fields[$i]=~/^C\:/) {
            my @fields2 = split /:/, $fields[$i] ;
            $fields2[1] =~ /p=(.*)/ ;
            my $clkpos=$1 ;
            shift @fields2 ;
            shift @fields2 ;
            $this_u= join (':',@fields2) ;
            $qdict{$this_q} =
            "$session\t$qpos\t$this_q\t$this_u\t$clkpos" ;
            $printout=1 ;
        }
    }
    if($printout==0) {next;}
    foreach $key (keys %qdict) {
        print "$qdict{$key}\n" ;
    }
}

