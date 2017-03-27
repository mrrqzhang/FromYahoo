
sub main() {
    while(<>) {
      my $line = chomp() ;
      my @fields = split /\t/, $line ;
      my @qualifiedOutlinks = ();
      $$links{$outlink}{boost} = getWhiteListWeight($normalized_anchortext);

      if ($new_domain) {
           sort { sort_by_all_info_v2($$links{$a}, $$links{$b}) } @qualifiedOutlinks;
      }

}





sub comp_influx ($$$$) {

    my ($a_influx, $b_influx, $a_urlhasquery, $b_urlhasquery) = @_;
    my $diff_influx = abs($a_influx - $b_influx);
    my $diff_influx_threshold = 6;

    if ($a_influx > $b_influx) {
        return -1;
    } else {
        return 1;
    }

    if ($a_influx > $b_influx) {
        if ($diff_influx > $diff_influx_threshold) {
            return -1;
        } else {
            if ($a_urlhasquery > $b_urlhasquery) {
                return 1;
            } else {
                return -1;
            }
        }
    } else {
        if ($diff_influx > $diff_influx_threshold) {
            return 1;
        } else {
            if ($a_urlhasquery < $b_urlhasquery) {
                return -1;
            } else {
                return 1;
            }
        }
    }
}

sub comp_ctr_etal ($$) {

    my ($a, $b) = @_;

    my $a_ctr = $$a{ctr} ? $$a{ctr} : 0;
    my $a_influx = $$a{linkflux} ? $$a{linkflux} : 0;

    my $a_level = $$a{urldepth} ? $$a{urldepth} : 0;
    my $a_urlhasquery = $$a{urlhasquery} ? $$a{urlhasquery} : 0;

    my $b_ctr = $$b{ctr} ? $$b{ctr} : 0;
    my $b_influx = $$b{linkflux} ? $$b{linkflux} : 0;

    my $b_level = $$b{urldepth} ? $$b{urldepth} : 0;
    my $b_urlhasquery = $$b{urlhasquery} ? $$b{urlhasquery} : 0;

    my $diff_ctr = abs($a_ctr - $b_ctr) * 2 / ($a_ctr + $b_ctr + 1) ;
    my $diff_threshold_ctr = 0.3;

    if ($a_ctr > $b_ctr) {
        if ($diff_ctr > $diff_threshold_ctr) {
            return -1;
        } else {
            if ($a_level < $b_level) {
                return -1;
            } elsif ($a_level > $b_level) {
                return 1;
            } else {
                return comp_influx($a_influx, $b_influx, $a_urlhasquery, $b_urlhasquery);
              }
        }
    } elsif ($a_ctr == $b_ctr) {
        return comp_influx($a_influx, $b_influx, $a_urlhasquery, $b_urlhasquery);
    } else { # $a_ctr < $b_ctr
        if ($diff_ctr > $diff_threshold_ctr) {
            return 1;
        } else {
            if ($a_level < $b_level) {
                return -1;
            } elsif ($a_level > $b_level) {
                return 1;
            } else {
                return comp_influx($a_influx, $b_influx, $a_urlhasquery, $b_urlhasquery);
            }
        }
    }
}


sub sort_by_all_info_v2 ($$) { # Sorting predicate

  my ($a, $b) = @_;

  my $a_ctr = $$a{ctr} ? $$a{ctr} : 0;
  my $a_toolbar = $$a{toolbar} ? $$a{toolbar} : 0;
  my $a_boost = $$a{boost} ? $$a{boost} : 0;

  my $b_ctr = $$b{ctr} ? $$b{ctr} : 0;
  my $b_toolbar = $$b{toolbar} ? $$b{toolbar} : 0;
  my $b_boost = $$b{boost} ? $$b{boost} : 0;

  my $diff_ctr = abs($a_ctr - $b_ctr) * 2 / ($a_ctr + $b_ctr + 1) ;
  my $diff_toolbar = abs($a_toolbar - $b_toolbar) * 2 / ($a_toolbar + $b_toolbar + 1) ;
  my $diff_threshold_toolbar = 0.9;
  my $diff_threshold_boost = 1.5;
  my $sum_toolbar = $a_toolbar + $b_toolbar;
  my $sum_ctr = $a_ctr + $b_ctr;

        if ($a_boost > $b_boost) {
                  return -1;
         } elsif ($a_boost < $b_boost) {
                  return 1;
        }
  
       if (($diff_toolbar > $diff_threshold_toolbar) && ($sum_toolbar > 10)) {
               if ($a_toolbar > $b_toolbar) {
                   return -1;
               } else {
                   return 1;
               }
       } else {
              return comp_ctr_etal ($a, $b);
       }
}




