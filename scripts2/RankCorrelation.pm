# $Id: RankCorrelation.pm,v 1.22 2004/08/13 23:41:45 gene Exp $

package Statistics::RankCorrelation;
$VERSION = 0.0901;
use strict;
use warnings;
use Carp;

sub new {
    my $proto = shift;
    my $class = ref ($proto) || $proto;
    my $self  = {
        x_data => shift || [],
        y_data => shift || [],
    };
    bless $self, $class;
    $self->_init;
    return $self;
}

sub _init {
    my $self = shift;

    # Automatically compute the statistical ranks if given vectors.
    if( ( $self->{x_data} && $self->{y_data} ) &&
        ( @{ $self->{x_data} } && @{ $self->{y_data} } )
    ) {
        # "co-normalize" the vectors.
        ( $self->{x_data}, $self->{y_data} ) = pad_vectors(
            $self->{x_data}, $self->{y_data}
        );

        # Set the ranks of the vectors.
        $self->x_rank( rank( $self->{x_data} ) );
        $self->y_rank( rank( $self->{y_data} ) );

        # Set the size of the unit data vector.
        $self->{size} = @{ $self->{x_data} };
    }
}

sub x_data {
    my $self = shift;
    $self->{x_data} = shift if @_;
    return $self->{x_data};
}

sub y_data {
    my $self = shift;
    $self->{y_data} = shift if @_;
    return $self->{y_data};
}

sub x_rank {
    my $self = shift;
    $self->{x_rank} = shift if @_;
    return $self->{x_rank};
}

sub y_rank {
    my $self = shift;
    $self->{y_rank} = shift if @_;
    return $self->{y_rank};
}

# Return Spearman's rho correlation coefficient.
sub spearman {
    my $self = shift;

    # Initialize the squared rank difference sum.
    my $sq_sum = 0;

    # Compute the squared rank difference sum.
    for( 0 .. $self->{size} - 1 ) {
        $sq_sum += ( $self->{x_rank}[$_] - $self->{y_rank}[$_] ) ** 2;
#warn "$sq_sum\n += ( $self->{x_rank}[$_] - $self->{y_rank}[$_] ) ** 2";
    }

#warn "1 - ( (6 * $sq_sum) / ( $self->{size} * (( $self->{size} ** 2 ) - 1))\n";
    return 1 - ( (6 * $sq_sum) /
        ( $self->{size} * (( $self->{size} ** 2 ) - 1))
    );
}

sub cosine{
    my $self = shift;

    # Initialize the squared rank difference sum.
    my $sq_sum = 0;
    my $sq_sum_x = 0;
    my $sq_sum_y = 0;

    # Compute the squared rank difference sum.
    for( 0 .. $self->{size} - 1 ) {
	$sq_sum +=  $self->{x_data}[$_] * $self->{y_data}[$_];
	$sq_sum_x += $self->{x_data}[$_] **2;
	$sq_sum_y += $self->{y_data}[$_] **2;

#	print "..".$self->{x_data}[$_],"\t",$self->{y_data}[$_],"\n";

       #$sq_sum +=  $self->{x_rank}[$_] * $self->{y_rank}[$_];
       #$sq_sum_x += $self->{x_rank}[$_] **2;
       #$sq_sum_y += $self->{y_rank}[$_] **2;
 
       #print "..".$self->{x_rank}[$_],"\t",$self->{y_rank}[$_],"\n";

    }

    my $product_x_y = $sq_sum_x * $sq_sum_y;
    $product_x_y = sqrt($product_x_y);

    if($product_x_y == 0){
#	warn "cosine simlarity denomiter is zero\n";
	return 0;
    }

#    print "cosine: $sq_sum\t$sq_sum_x\t$sq_sum_y\n";	
    return $sq_sum/$product_x_y;

}

# Sort the given vectors as measurement pairs by the x data.

sub rank {
    my $u = shift;

    # Make a list of ranks for each datum.
    my %rank;
    push @{ $rank{ $u->[$_] } }, $_ for 0 .. @$u - 1;

    my ($old, $cur) = (0, 0);

    # Set the averaged ranks.
    my @ranks;
    for my $x (sort { $a <=> $b } keys %rank) {
        # Get the number of ties.
        my $ties = @{ $rank{$x} };
        $cur += $ties;

        if ($ties > 1) {
            # Average the tied data.
            my $average = $old + ($ties + 1) / 2;
            $ranks[$_] = $average for @{ $rank{$x} };
        }
        else {
            # Add the single rank to the list of ranks.
            $ranks[ $rank{$x}[0] ] = $cur;
        }

        $old = $cur;
    }

    return \@ranks;
}

sub csim {
    my $self = shift;

    # Get the pitch matrices for each vector.
    my $m1 = correlation_matrix($self->{x_data});
#warn map { "@$_\n" } @$m1;
    my $m2 = correlation_matrix($self->{y_data});
#warn map { "@$_\n" } @$m2;

    # Compute the rank correlation.
    my $k = 0;
    for my $i (0 .. @$m1 - 1) {
        for my $j (0 .. @$m1 - 1) {
            $k++ if $m1->[$i][$j] == $m2->[$i][$j];
        }
    }

    # Return the rank correlation normalized by the number of rows in
    # the pitch matrices.
    return $k / (@$m1 * @$m1);
}

# Append zeros to either vector for all values in the other that do
# not have a corresponding value.
sub pad_vectors {
    my ($u, $v) = @_;

    if (@$u > @$v) {
        $v = [ @$v, (0) x (@$u - @$v) ];
    }
    elsif (@$u < @$v) {
        $u = [ @$u, (0) x (@$v - @$u) ];
    }

    return $u, $v;
}

# Build a square, binary matrix that represents "higher or lower"
# value within the given vector.
sub correlation_matrix {
    my $u = shift;
    my $c;

    # Is a row value (i) lower than a column value (j)?
    for my $i (0 .. @$u - 1) {
        for my $j (0 .. @$u - 1) {
            $c->[$i][$j] = $u->[$i] < $u->[$j] ? 1 : 0;
        }
    }

    return $c;
}

1;

__END__

=head1 NAME

Statistics::RankCorrelation - Compute the rank correlation between two vectors 

=head1 SYNOPSIS

  use Statistics::RankCorrelation;

  $x = [ 8, 7, 6, 5, 4, 3, 2, 1 ];
  $y = [ 2, 1, 5, 3, 4, 7, 8, 6 ];

  $c = Statistics::RankCorrelation->new( $x, $y );

  $n = $c->spearman;
  $m = $c->csim;

=head1 DESCRIPTION

This module computes rank correlation coefficient measures between two 
sample vectors.

Working examples may be found in the distribution C<eg/> directory and 
the module test file.

Also the C<HANDY FUNCTIONS> section below has some ..handy functions 
to use when computing sorted rank coefficients by hand.

=head1 PUBLIC METHODS

=head2 new

  $c = Statistics::RankCorrelation->new( \@u, \@v );

This method constructs a new C<Statistics::RankCorrelation> object.

If given two numeric vectors (in the form of flat array references) as 
arguments the object is initialized by computing the statistical ranks 
of the vectors.  If they are of different cardinality the shorter 
vector is first padded with trailing zeros.

=head2 x_data, y_data

  $x = $c->x_data;
  $c->y_data( $y );

Return (and optionally set) the data samples that were provided to 
the constructor as array references.

=head2 x_rank, y_rank

  $rx = $c->x_rank;
  $c->y_rank( $ry );

Return (and optionally set) the statistically ranked data samples as 
array references.

=head2 spearman

  $n = $c->spearman;

Spearman's rho rank-order correlation is a nonparametric measure of 
association based on the rank of the data values and is a special 
case of the Pearson product-moment correlation.

The formula is:

      6 * sum( ( Xi - Yi ) ^ 2 )
  1 - --------------------------
          N * ( N ^ 2 - 1 )

Where C<X> and C<Y> are the two rank vectors and C<i> is an index 
from one to the C<N> number of samples.

=head2 csim

  $n = $c->csim;

Return the contour similarity index measure.  This is a single 
dimensional measure of the similarity between two vectors.

This returns a measure in the (inclusive) range C<[-1..1]> and is 
computed using matrices of binary data representing "higher or lower" 
values in the original vectors.

This measure has been studied in musical contour analysis.

=head1 HANDY FUNCTIONS

=head2 rank

  $ranks = rank( [ 1.0, 3.2, 2.1, 3.2, 3.2, 4.3 ] );
  # [1, 4, 2, 4, 4, 6]

Return an array reference of the ordinal ranks of the given data.

Note that the data must be sorted as measurement pairs prior to 
computing the statistical rank.  This is done automatically by the
object initialization method.

In the case of a tie in the data (identical values) the rank numbers
are averaged.  An example will elucidate:

  sorted data:    [ 1.0, 2.1, 3.2, 3.2, 3.2, 4.3 ]
  ranks:          [ 1,   2,   3,   4,   5,   6   ]
  tied ranks:     3, 4, and 5
  tied average:   (3 + 4 + 5) / 3 == 4
  averaged ranks: [ 1,   2,   4,   4,   4,   6   ]

=head2 pad_vectors

  ( $u, $v ) = pad_vectors( [ 1, 2, 3, 4 ], [ 9, 8 ] );
  # [1, 2, 3, 4], [9, 8, 0, 0]

Append zeros to either input vector for all values in the other that 
do not have a corresponding value.  That is, "pad" the tail of the 
shorter vector with zero values.

=head2 correlation_matrix

  $matrix = correlation_matrix( $u );

Return the correlation matrix for a single vector.

This function builds a square, binary matrix that represents "higher 
or lower" value within the vector itself.

=head1 TO DO

Implement other rank correlation measures that are out there.

=head1 SEE ALSO

For the C<csim> method:

C<http://www2.mdanderson.org/app/ilya/Publications/JNMRcontour.pdf>

For the C<spearman> method:

C<http://mathworld.wolfram.com/SpearmanRankCorrelationCoefficient.html>

C<http://faculty.vassar.edu/lowry/ch3b.html>

C<http://www.pinkmonkey.com/studyguides/subjects/stats/chap6/s0606801.asp>

C<http://fonsg3.let.uva.nl/Service/Statistics/RankCorrelation_coefficient.html>

C<http://www.statsoftinc.com/textbook/stnonpar.html#correlations>

C<http://www.analytics.washington.edu/~rossini/courses/intro-nonpar/text/Tied_Data.html>

C<http://www.analytics.washington.edu/~rossini/courses/intro-nonpar/text/Spearman_s_tex2html_image_mark_tex2html_wrap_inline4049_.html>

=head1 THANK YOU

Thomas Breslin E<lt>thomas@thep.lu.seE<gt> for unsorted C<rank> code.

=head1 AUTHOR

Gene Boggs E<lt>gene@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2003, Gene Boggs

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
