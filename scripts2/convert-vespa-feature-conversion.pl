
$#ARGV==2 or die "You need 3 parameters:  feature-mapper-file  original-model(dtree.c)  vespa-model\n" ;

open FEAT, "<$ARGV[0]" ;

open DTREE, "<$ARGV[1]" ;

my $DTREE_MODEL = $ARGV[2] ;
open( DTREE_MODEL, ">", $DTREE_MODEL ) ;

my %features = ();

while(<FEAT>) {
	chomp() ;
	my @fields = split /\t/ ;
	$features{$fields[1]}= $fields[0] ;
}        


my $model = 0;
while( my $line = <DTREE> )
{
    chomp( $line );

    if( $line =~ m/MODELBEGIN/ ){ $model = 1; }
    if( $line =~ m/\/\*{25,}/ && $model == 1 ){ $model = 0; }

    if( $model != 1 ){ next; }
    if( $line =~ m/^tnscore = 0.0/ ){ next; }

    my $norm = ( ( $line =~ m/if ([^ ]+) / ) ? $1 : "" );
    my $feat = (  exists( $features{ $norm } ) ? $features{ $norm } : "" );

    if( $norm ne "" && $feat eq "" ){ die( "Problem with feature mapping: No feature available for $norm\n" ); }

    $norm =~ s/\(/\\\(/g;
    $norm =~ s/\)/\\\)/g;

    if( $norm ne "" && $feat ne "" ){ $line =~ s/${norm}/${feat}/; }

    print( DTREE_MODEL $line . "\n" );

#    print "$line . \n";

    if( $line =~ m/^TN0/ ){ print( DTREE_MODEL "\ntnscore = 0.0;\n" ); }

#    if( $line =~ m/^TN0/ ){ print(  "\ntnscore = 0.0;\n" ); }


}

