use 5.014;
use warnings;

our ($ROUND, $PREC);

#  $x is a Math::GMPz object
#  $y is a signed integer

sub __is_power__ {
    my ($x, $y) = @_;

    Math::GMPz::Rmpz_cmp_ui($x, 1) == 0 and return 1;

    # Everything is a first power
    $y == 1 and return 1;

    # Return a true value when $x=-1 and $y is odd
    $y % 2 and (Math::GMPz::Rmpz_cmp_si($x, -1) == 0) and return 1;

    # Don't accept a non-positive power
    # Also, when $x is negative and $y is even, return faster
    if ($y <= 0 or ($y % 2 == 0 and Math::GMPq::Rmpq_sgn($x) < 0)) {
        return !1;
    }

    # Optimization for perfect squares
    $y == 2 and return Math::GMPz::Rmpz_perfect_square_p($x);

    Math::GMPz::Rmpz_perfect_power_p($x) || return !1;
    my $z = Math::GMPz::Rmpz_init_set($x);
    Math::GMPz::Rmpz_root($z, $z, $y);
}

1
