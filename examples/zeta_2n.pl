#!/usr/bin/perl

# Calculate zeta(2n) using a closed-form formula.

# See also:
#   https://en.wikipedia.org/wiki/Riemann_zeta_function

use 5.010;
use strict;
use warnings;

use lib qw(../lib);
use Memoize qw(memoize);
use Math::AnyNum qw(:overload pi);

sub bernoulli_number {
    my ($n) = @_;

    return 0 if $n > 1 && $n % 2;    # Bn = 0 for all odd n > 1

    my @A;
    for my $m (0 .. $n) {
        $A[$m] = 1 / ($m + 1);

        for (my $j = $m ; $j > 0 ; $j--) {
            $A[$j - 1] = $j * ($A[$j - 1] - $A[$j]);
        }
    }

    return $A[0];                    # which is Bn
}

sub factorial {
    $_[0] < 2 ? 1 : factorial($_[0] - 1) * $_[0];
}

memoize('factorial');

sub zeta_2n {
    my ($n2) = 2 * $_[0];
    ((-1)**($_[0] + 1) * 2**($n2 - 1) * pi**$n2 * bernoulli_number($n2)) / factorial($n2);
}

for my $i (1 .. 10) {
    say "zeta(", 2 * $i, ") = ", zeta_2n($i);
}
