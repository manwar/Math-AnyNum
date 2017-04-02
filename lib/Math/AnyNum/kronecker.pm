use 5.014;
use warnings;

our ($ROUND, $PREC);

sub __kronecker__ {    # takes two Math::GMPz objects
    my ($x, $y) = @_;
    Math::GMPz::Rmpz_kronecker($x, $x, $y);
    $x;
}

1;
