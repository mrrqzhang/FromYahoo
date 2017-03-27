
my @arr = () ;

my $n=0 ;
while(<>) {
  chomp() ;
  $arr[$n]=$_ ;
  $n++ ;
}

my $av = average(\@arr) ;
my $med = median(\@arr) ;

print "$av $med\n" ;


sub average {
@_ == 1 or die ('Sub usage: $average = average(\@array);');
my ($array_ref) = @_;
my $sum;
my $count = scalar @$array_ref;
foreach (@$array_ref) { $sum += $_; }
return $sum / $count;
}

sub median {
@_ == 1 or die ('Sub usage: $median = median(\@array);');
my ($array_ref) = @_;
my $count = scalar @$array_ref;
# Sort a COPY of the array, leaving the original untouched
my @array = sort { $a <=> $b } @$array_ref;
if ($count % 2) {
return $array[int($count/2)];
} else {
return ($array[$count/2] + $array[$count/2 - 1]) / 2;
}
}
