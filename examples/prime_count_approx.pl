#!/usr/bin/perl

#
## Some simple approximations to the prime counting function.
#

use 5.010;
use strict;
use warnings;

use lib qw(../lib);
use Math::AnyNum qw(:overload sqr idiv Li lngamma floor);

foreach my $n (1 .. 10) {
    my $x = 10**$n;

    my $f1 = idiv(sqr($x), lngamma($x + 2));
    my $f2 = floor(Li($x));

    say "PI($x) =~ ", $f1, ' =~ ', $f2;
}
