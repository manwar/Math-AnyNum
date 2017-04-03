#!perl -T

use strict;
use warnings;

use Test::More tests => 57;
use Math::AnyNum;

foreach my $pair (
                  qw/
                  123:123:123
                  123.4:123.4:123.4
                  1.4:1.4:1.4
                  0.1:0.1:0.1
                  -0.1:-0.1:-0.1
                  -1.1:-1.1:-1.1
                  -123.4:-123.4:-123.4
                  -123:-123:-123
                  3+4i:3+4i:3+4i
                  123e2:123e2:12300
                  123e-1:12.3:12.3
                  123e-4:0.0123:0.0123
                  123e-3:0.123:0.123
                  123.345e-1:12.3345:12.3345
                  123.456e+2:12345.6:12345.6
                  1234.567e+3:1234567:1234567
                  1234.567e+4:1234567E1:12345670
                  1234.567e+6:1234567E3:1234567000
                  1234.567e+6+123e-4i:1234567E3+123e-4i:1234567000+0.0123i
                  /
  ) {
    my ($x, $y, $z) = split(/:/, $pair);

    my $n = Math::AnyNum->new($x);
    my $m = Math::AnyNum->new($y);

    is($n,   $m, qq/new("$x") = $y/);
    is("$n", $z, qq/"$x" = $z/);
    is("$m", $z, qq/"$y" = $z/);
}
