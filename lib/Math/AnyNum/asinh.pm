use 5.014;
use warnings;

our ($ROUND, $PREC);

Class::Multimethods::multimethod __asinh__ => qw(Math::MPFR) => sub {
    my ($x) = @_;
    Math::MPFR::Rmpfr_asinh($x, $x, $ROUND);
    $x;
};

Class::Multimethods::multimethod __asinh__ => qw(Math::MPC) => sub {
    my ($x) = @_;
    Math::MPC::Rmpc_asinh($x, $x, $ROUND);
    $x;
};

Class::Multimethods::multimethod __asinh__ => qw(Math::GMPq) => sub {
    my ($x) = _mpq2mpfr($_[0]);
    Math::MPFR::Rmpfr_asinh($x, $x, $ROUND);
    $x;
};

Class::Multimethods::multimethod __asinh__ => qw(Math::GMPz) => sub {
    my ($x) = _mpz2mpfr($_[0]);
    Math::MPFR::Rmpfr_asinh($x, $x, $ROUND);
    $x;
};

1;
