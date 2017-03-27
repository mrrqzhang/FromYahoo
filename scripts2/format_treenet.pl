#! /home/y/bin/perl

use strict;
use warnings;

use Getopt::Long;

my $FEAT = "";
my $DTREE = "";
my $DTREE_MODEL = "";
my $DTREE_VESPA = "";

GetOptions (    'dtree=s'             =>      \$DTREE,
		'feature=s'           =>      \$FEAT      );

$DTREE_MODEL = $DTREE;
$DTREE_MODEL =~ s/\.[^\.]*$/\.model/;

$DTREE_VESPA = $DTREE;
$DTREE_VESPA =~ s/\.[^\.]*$/\.vespa/;


my %features = ();

open( FEAT, "<", $FEAT ) or die( "Cannot open file: " . $FEAT . "t" . $! . " - " . $? . "\n" );

while( my $feat = <FEAT> )
{
    chomp( $feat );

    my $norm = $feat;
    $norm =~ s/,/\cB/g;
    $norm =~ tr/[a-z]/[A-Z]/;

    $features{ $norm } = $feat;
}
close( FEAT );




my $model = 0;

open( DTREE, "<", $DTREE ) or die( "Cannot open file: " . $DTREE . "\t" . $! . " - " . $? . "\n" );
open( DTREE_MODEL, ">", $DTREE_MODEL ) or die( "Cannot open file: " . $DTREE_MODEL . "\t" . $! . " - " . $? . "\n" );

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

    if( $line =~ m/^TN0/ ){ print( DTREE_MODEL "\ntnscore = 0.0;\n" ); }
}
close( DTREE );
close( DTREE_MODEL );

system( "echo '100.0 +' > $DTREE_VESPA" );
system( "/home/y/bin/treenetconverter $DTREE_MODEL >> $DTREE_VESPA" );
