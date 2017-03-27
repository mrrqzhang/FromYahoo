
use strict;

die "Usage: $0 <old-mapping-file> <new-mapping-file>" unless $ARGV[1];


my $non_mappable_single_word = 'token';
my $non_mappable_multi_word = 'compound';

my $old_mapping_file=$ARGV[0] ;
my $new_mapping_file=$ARGV[1] ;

my %old_mapping ;
my %new_mapping ;

for (split "\n", `cat $old_mapping_file`) {
    next if (/^\s*\#/); # comments
    my @ar = split /\s+/, $_;
    next unless ($#ar>0);
    my $from = shift @ar;
    my $to = shift @ar;
    my $dec;
    foreach my $d (@ar) {
        $d .= "=1" unless $d =~ /=/;
        $dec .= "$d ";
    }
    if ($dec) {
        $dec =~ s/ +$//;
        $to = "$to($dec)";
    }
    $old_mapping{$to} = $from;
}



for (split "\n", `cat $new_mapping_file`) {
    next if (/^\s*\#/); # comments
    my @ar = split /\s+/, $_;
    next unless ($#ar>0);
    my $from = shift @ar;
    my $to = shift @ar;
    my $dec;
    foreach my $d (@ar) {
        $d .= "=1" unless $d =~ /=/;
        $dec .= "$d ";
    }
    if ($dec) {
        $dec =~ s/ +$//;
        $to = "$to($dec)";
    }
    $new_mapping{$from} = $to;
}

while(<STDIN>) {
    chomp() ;
    next unless /\S/;
    my @words = split "\t", $_;
    my @ar = split /\s+/, $words[3] ;
    for(my $i=0; $i<=$#ar; $i++) {
	next unless ($ar[$i] ne $non_mappable_single_word)&&($ar[$i] ne $non_mappable_multi_word) ;
	my $tag=$ar[$i] ;
	my $head="" ;
	if($tag =~ s/^B-//) {$head="B-" ;}
	elsif($tag =~ s/^I-//) {$head="I-" ;}
	if($old_mapping{$tag}) {
	    my $temp=$old_mapping{$tag} ;
	    $tag = $new_mapping{$temp} ;
        }
        $ar[$i]="$head$tag" ;
    }
    $words[3]=join " ", @ar ;
    print "" . (join "\t", @words) . "\n";
}
	
  



