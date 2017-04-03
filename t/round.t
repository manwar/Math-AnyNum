#!perl -T

use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 132;

use Math::AnyNum;

{
    is(Math::AnyNum->new_c(1.234567,  7.65432)->round(-3), '1.235+7.654i');
    is(Math::AnyNum->new_c(-1.234567, 0.00001)->round(-3), '-1.235');
}

{
    use Math::AnyNum qw(:overload);

    #[+0.5,      0,         0],
    #[-0.5,      0,         0],
    #[3.045,     3.04,      -2],
    #[-2.5,      -2,        0],
    #[+2.5,      2,         0],

    my @tests = (
                 [+1.6,      +2,        0],
                 [+1.5,      +2,        0],
                 [+1.4,      +1,        0],
                 [+0.6,      +1,        0],
                 [+0.4,      0,         0],
                 [-0.4,      0,         0],
                 [-0.6,      -1,        0],
                 [-1.4,      -1,        0],
                 [-1.5,      -2,        0],
                 [-1.6,      -2,        0],
                 [3.016,     3.02,      -2],
                 [3.013,     3.01,      -2],
                 [3.015,     3.02,      -2],
                 [3.04501,   3.05,      -2],
                 [3.03701,   3.04,      -2],
                 [-1234.555, -1000,     3],
                 [-1234.555, -1200,     2],
                 [-1234.555, -1230,     1],
                 [-1234.555, -1235,     0],
                 [-1234.555, -1234.6,   -1],
                 [-1234.555, -1234.55,  -2],
                 [-1234.555, -1234.555, -3],
                 [-2.7,      -3,        0],
                 [-2.3,      -2,        0],
                 [-2.0,      -2,        0],
                 [-1.7,      -2,        0],
                 [-1.5,      -2,        0],
                 [-1.3,      -1,        0],
                 [-1.0,      -1,        0],
                 [-0.7,      -1,        0],
                 [-0.3,      0,         0],
                 [+0.0,      0,         0],
                 [+0.3,      0,         0],
                 [+0.7,      1,         0],
                 [+1.0,      1,         0],
                 [+1.3,      1,         0],
                 [+1.5,      2,         0],
                 [+1.7,      2,         0],
                 [+2.0,      2,         0],
                 [+2.3,      2,         0],
                 [+2.7,      3,         0],
                );

    foreach my $group (@tests) {
        my ($orig, $expected, $places) = @{$group};
        my $rounded = $orig->round($places);
        is("$rounded", "$expected", "($orig, $expected, $places)");
        ok($rounded == $expected);
    }
}

# Round half-to-even, using rationals.
{
    use Math::AnyNum qw(:overload rat);

    sub round_nth {
        my ($orig, $nth) = @_;

        my $n = abs($orig);
        my $p = 10**$nth;

        $n *= $p;
        $n += 1 / 2;

        if ($n == int($n) and $n % 2 != 0) {
            $n -= 1 / 2;
        }

        $n = int($n);
        $n /= $p;
        $n = -$n if ($orig < 0);

        return $n;
    }

    my @tests = (

        # original | rounded | places
        [+1.6,            +2,            0],
        [+1.5,            +2,            0],
        [+1.4,            +1,            0],
        [+0.6,            +1,            0],
        [+0.5,            0,             0],
        [+0.4,            0,             0],
        [-0.4,            0,             0],
        [-0.5,            0,             0],
        [-0.6,            -1,            0],
        [-1.4,            -1,            0],
        [-1.5,            -2,            0],
        [-1.6,            -2,            0],
        [377 / 125,       151 / 50,      2],
        [3013 / 1000,     301 / 100,     2],
        [603 / 200,       151 / 50,      2],
        [609 / 200,       76 / 25,       2],
        [304501 / 100000, 61 / 20,       2],
        [-246911 / 200,   -1000,         -3],
        [-246911 / 200,   -1200,         -2],
        [-246911 / 200,   -1230,         -1],
        [-246911 / 200,   -1235,         0],
        [-246911 / 200,   -6173 / 5,     1],
        [-246911 / 200,   -30864 / 25,   2],
        [-246911 / 200,   -246911 / 200, 3],
    );

    foreach my $pair (@tests) {
        my ($n, $expected, $places) = @$pair;
        my $rounded = round_nth($n, $places);

        is(ref($rounded), 'Math::AnyNum');
        ok($rounded == $expected);
    }
}
