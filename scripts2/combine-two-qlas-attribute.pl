
use strict ;

open IN1, "<$ARGV[0]" ;

open IN2, "$ARGV[1]" ;

my %attributes = () ;

while (<IN1>) {
    chomp() ;
    s/\"//g ;
    my @fields = split /\t/ ;
    for(my $i=0; $i<=$#fields; $i++) {
	if($fields[$i] ne "") {  $attributes{$fields[$i]}="other" ;} 
    }
}


while(<IN2>) {
    chomp() ;
    my @fields = split /@/ ;
    if( $fields[1] =~ /crf_local/ && $fields[1] =~/crf_product/ ) { $attributes{$fields[0]}="crf_local_product" ;}
    elsif( $fields[1] =~ /crf_local/ ) { $attributes{$fields[0]}="crf_local" ;}
    elsif( $fields[1] =~ /crf_product/ ) { $attributes{$fields[0]}="crf_product" ;}
    else  { $attributes{$fields[0]}="other" ;}
}
my $key ;

foreach $key ( sort keys %attributes ) {
    if($attributes{$key} eq "crf_local_product" ) { print "$key\@crf_local,crf_product,knowledgebase-daily,qi:main\n" ;}
    elsif($attributes{$key} eq "crf_local" ) { print "$key\@crf_local,knowledgebase-daily,qi:main\n" ;}
    elsif($attributes{$key} eq "crf_product" ) { print "$key\@crf_product,knowledgebase-daily,qi:main\n" ;}
    else {print "$key\@knowledgebase-daily,qi:main\n" ;}
}
