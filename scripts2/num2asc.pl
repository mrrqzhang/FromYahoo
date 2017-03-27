#!/usr/releng/bin/perl


while(<>) {
	chomp() ;
	my $key = $_ ;
	$key =~ s/１/1/g ;
	$key =~ s/２/2/g ;
	$key =~ s/３/3/g ;
	$key =~ s/４/4/g ;
	$key =~ s/５/5/g ;
	$key =~ s/６/6/g ;
	$key =~ s/７/7/g ;
	$key =~ s/８/8/g ;
	$key =~ s/９/9/g ;
	$key =~ s/０/0/g ;
	print "$key\n" ;
}
