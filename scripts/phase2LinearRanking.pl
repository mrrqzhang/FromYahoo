
while(<>) {
  chomp() ;
  my @fields = split /\t/ ;
  my $gmp = ($fields[10] eq "")?0:$fields[10];
  my $fb = ($fields[13] eq "")?0:$fields[13];
  my $infd = ($fields[37] eq "")?0:$fields[37] ;
  my $pos_dec = ($fields[15] eq "")?0:$fields[15] ;
  my $neg_dec = ($fields[17] eq "")?0:$fields[17] ;
  my $runtime = $fields[3]*1000 ;
  my $pubtime = $fields[21] ;
  my $agedecay = computeAgeDecay($pubtime, $runtime) ;
  my $negdecay = computeNegativeDecay($neg_dec) ;

#  print "$gmp\t$fb\t$infd\t$pos_dec\t$neg_dec\t$runtime\t$pubtime\t$agedecay\t$negdecay\n" ;
  my $p2lrs = $agedecay*$negdecay*($gmp + ($fb**4 + $infd**4 + $pos_dec**4)**0.25) ;
#  print "$gmp\t$fb\t$infd\t$pos_dec\t$neg_dec\t$runtime\t$pubtime\t$agedecay\t$negdecay\t$p2lrs\n" ;
  print "$p2lrs\n" ;
} 
 
sub computeNegativeDecay {
   my $score = shift @_ ;
   my $negativeDeclaredScale = 0.36 ;
   $score = exp($score / $negativeDeclaredScale);
   return $score ;
}

sub  computeAgeDecay {

        my  ($pubTime,$runtime) = @_ ; 
        if ($pubTime <= 0) {
            return 0;
        }

        if (($runtime == 0) || ($runtime < $pubTime)) {
            $runtime = $pubTime ;     #System.currentTimeMillis();
        }
        my $ONE_HOUR_IN_MS = 3600000 ;
        my $delta = ($runtime - $pubTime) / ($ONE_HOUR_IN_MS);
        # Items with future pubTime
        if ($delta < 0) {
            return 0;
        }
        my $DECAY_SIX_HOURS = -0.03333 ;
        my $DECAY_TWO_DAYS = -0.371 ;
        if ($delta <= 6) {
            return ($DECAY_SIX_HOURS * $delta + 1);
        }

        if ($delta <= 48) {
            return ($DECAY_TWO_DAYS * log($delta) + 1.465);
        }

        # Items with 2 day or more delta
        return 0;
}
