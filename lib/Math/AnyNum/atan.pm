use 5.014;
use warnings;

our ($ROUND);

Class::Multimethods::multimethod __atan__ => qw(Math::MPFR) => sub {
    my ($x) = @_;
    Math::MPFR::Rmpfr_atan($x, $x, $ROUND);
    $x;
};

Class::Multimethods::multimethod __atan__ => qw(Math::MPC) => sub {
    my ($x) = @_;
    Math::MPC::Rmpc_atan($x, $x, $ROUND);
    $x;
};

1;
