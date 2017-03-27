#!/usr/bin/perl

open INTERP, "<$ARGV[0]" ;
open QRY, "<$ARGV[1]" ;
open IN_FEAT, "<$ARGV[2]" ;
open IN_LBL, "<$ARGV[3]" ;
open IN_WTS, "<$ARGV[4]" ;
open IN_FOLD, "<$ARGV[5]" ;
open OUT_TRAIN_FEAT, ">$ARGV[6]" ;
open OUT_TRAIN_LBL, ">$ARGV[7]" ;
open OUT_TRAIN_WTS, ">$ARGV[8]" ;
open OUT_TRAIN_INTERP, ">$ARGV[9]" ;
open OUT_TEST_FEAT, ">$ARGV[10]" ;
open OUT_TEST_LBL, ">$ARGV[11]" ;
open OUT_TEST_WTS, ">$ARGV[12]" ;
open OUT_TEST_INTERP, ">$ARGV[13]" ;
open OUT_TEST_FOLD, ">$ARGV[14]" ;


my %querylist=() ;
while(<QRY>) {
  chomp() ;
  $querylist{$_}=1 ;
}

my $tmp=<IN_FEAT> ;
print OUT_TRAIN_FEAT "$tmp" ;
print OUT_TEST_FEAT "$tmp" ;
$tmp=<IN_LBL> ;
print OUT_TRAIN_LBL "$tmp" ;
print OUT_TEST_LBL "$tmp" ;
$tmp=<IN_WTS> ;
print OUT_TRAIN_WTS "$tmp" ;
print OUT_TEST_WTS "$tmp" ;

$tmp=<IN_FOLD> ;
print OUT_TEST_FOLD "$tmp" ;



$tmp=<INTERP> ;
print OUT_TRAIN_INTERP "$tmp" ;
print OUT_TEST_INTERP "$tmp" ;

my $line0 ;
while($line0=<INTERP>) {
  my $line1 = <IN_LBL>  ;
  my $line2 = <IN_FEAT> ;
  my $line3 = <IN_WTS> ;
  my $line4 = <IN_FOLD> ;
  my @fields = split /\t/, $line0 ;
#  print "aa:$line0\nbb:$fields[0]\ncc:$querylist{$fields[0]}\n" ;
  if(defined $querylist{$fields[0]}) {
      print OUT_TEST_LBL "$line1" ;
      print OUT_TEST_FEAT "$line2" ;  	
      print OUT_TEST_WTS "$line3" ;
      print OUT_TEST_INTERP "$line0" ;
      print OUT_TEST_FOLD "$line4" ;
  }
  else {
      print OUT_TRAIN_LBL "$line1" ;
      print OUT_TRAIN_FEAT "$line2" ;
      print OUT_TRAIN_WTS "$line3" ;
      print OUT_TRAIN_INTERP "$line0" ;

  }
}

