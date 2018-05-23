#!perl -T

use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 32;

use Math::AnyNum qw(:overload sum binomial bernoulli euler faulhaber_sum irand);

# Bernoulli numbers
{
    my %results = qw(
      0   1
      1   1/2
      2   1/6
      3   0
      4   -1/30
      5   0
      6   1/42
      10  5/66
      12  -691/2730
      20  -174611/330
      22  854513/138
      );

    #
    ## bernfrac()
    #
    foreach my $i (keys %results) {
        is(Math::AnyNum->new($i)->bernfrac->stringify, $results{$i});
    }

    is((-2)->bernfrac, NaN);    # make sure we check for even correctly

#<<<
    is(bernoulli(52), '-801165718135489957347924991853/1590');
    is(bernoulli(106), '36373903172617414408151820151593427169231298640581690038930816378281879873386202346572901/642');
#>>>

    #
    ## bernreal()
    #
    is((-2)->bernreal, NaN);    # check for negative values

    is((1)->bernreal,              0.5);
    is((0)->bernreal,              1);
    is((3)->bernreal,              0);
    is((2)->bernreal->round(-10),  '0.1666666667');
    is((14)->bernreal->round(-25), '1.1666666666666666666666667');
    is((52)->bernreal->round(-10), '-503877810148106891413789303.0522012579');
}

{
    my $n = irand(2, 100);
    my $x = irand(2, 100);

    is(sum(map { my $k = $_; binomial($n, $k) * euler($k) / 2**$k * ($x - 1 / 2)**($n - $k) } 0 .. $n), euler($n, $x));
    is(sum(map { my $k = $_; binomial($n, $k) * (-1)**($n - $k) * bernoulli($n - $k) * $x**$k } 0 .. $n), bernoulli($n, $x));
    is(2**$n * (2**($n + 1) / ($n + 1)) * (bernoulli($n + 1, 3 / 4) - bernoulli($n + 1, 1 / 4)), euler($n));
    is((bernoulli($x + 1, $n + 1) - bernoulli($x + 1)) / ($x + 1), faulhaber_sum($n, $x));
    is(euler($n, $x) + (1 / 2 * sum(map { my $k = $_; binomial($n, $k) * euler($k, $x) } 0 .. $n - 1)), $x**$n);
    is(sum(map { my $k = $_; binomial($n + 1, $k) * bernoulli($k, $x) } 0 .. $n) / ($n + 1), $x**$n);
    is(2**($n + 1) / ($n + 1) * (bernoulli($n + 1, ($x + 1) / 2) - bernoulli($n + 1, $x / 2)), euler($n, $x));
    is(2**$n * euler($n, 1 / 2), euler($n));
}

is(euler(-2), NaN);

#<<<
is(join(', ', map { my $n = $_; euler($n) } 0 .. 10), "1, 0, -1, 0, 5, 0, -61, 0, 1385, 0, -50521");
is(join(', ', map { my $n = $_; 2 * $n * euler(2 * $n - 1, 0) } 1 .. 10), "-1, 1, -3, 17, -155, 2073, -38227, 929569, -28820619, 1109652905");
#>>>
