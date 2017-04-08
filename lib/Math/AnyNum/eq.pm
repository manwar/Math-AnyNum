use 5.014;
use warnings;

our ($PREC, $ROUND);

#
## MPFR
#
Class::Multimethods::multimethod __eq__ => qw(Math::MPFR Math::MPFR) => sub {
    Math::MPFR::Rmpfr_equal_p($_[0], $_[1]);
};

Class::Multimethods::multimethod __eq__ => qw(Math::MPFR Math::GMPz) => sub {
    Math::MPFR::Rmpfr_integer_p($_[0])
      and Math::MPFR::Rmpfr_cmp_z($_[0], $_[1]) == 0;
};

Class::Multimethods::multimethod __eq__ => qw(Math::MPFR Math::GMPq) => sub {
    Math::MPFR::Rmpfr_number_p($_[0])
      and Math::MPFR::Rmpfr_cmp_q($_[0], $_[1]) == 0;
};

Class::Multimethods::multimethod __eq__ => qw(Math::MPFR Math::MPC) => sub {
    (@_) = (_mpfr2mpc($_[0]), $_[1]);
    goto &__eq__;
};

Class::Multimethods::multimethod __eq__ => qw(Math::MPFR $) => sub {
    Math::MPFR::Rmpfr_integer_p($_[0])
      and (
           $_[1] < 0
           ? Math::MPFR::Rmpfr_cmp_si($_[0], $_[1])
           : Math::MPFR::Rmpfr_cmp_ui($_[0], $_[1])
          ) == 0;
};

#
## GMPq
#
Class::Multimethods::multimethod __eq__ => qw(Math::GMPq Math::GMPq) => sub {
    Math::GMPq::Rmpq_equal($_[0], $_[1]);
};

Class::Multimethods::multimethod __eq__ => qw(Math::GMPq Math::GMPz) => sub {
    Math::GMPq::Rmpq_integer_p($_[0])
      and Math::GMPq::Rmpq_cmp_z($_[0], $_[1]) == 0;
};

Class::Multimethods::multimethod __eq__ => qw(Math::GMPq Math::MPFR) => sub {
    Math::MPFR::Rmpfr_number_p($_[1])
      and Math::MPFR::Rmpfr_cmp_q($_[1], $_[0]) == 0;
};

Class::Multimethods::multimethod __eq__ => qw(Math::GMPq Math::MPC) => sub {
    (@_) = (_mpq2mpc($_[0]), $_[1]);
    goto &__eq__;
};

Class::Multimethods::multimethod __eq__ => qw(Math::GMPq $) => sub {
    my ($x, $y) = @_;
    (
     $y < 0
     ? Math::GMPq::Rmpq_cmp_si($x, $y, 1)
     : Math::GMPq::Rmpq_cmp_ui($x, $y, 1)
    ) == 0;
};

#
## GMPz
#
Class::Multimethods::multimethod __eq__ => qw(Math::GMPz Math::GMPz) => sub {
    Math::GMPz::Rmpz_cmp($_[0], $_[1]) == 0;
};

Class::Multimethods::multimethod __eq__ => qw(Math::GMPz Math::GMPq) => sub {
    Math::GMPq::Rmpq_integer_p($_[1])
      and Math::GMPq::Rmpq_cmp_z($_[1], $_[0]) == 0;
};

Class::Multimethods::multimethod __eq__ => qw(Math::GMPz Math::MPFR) => sub {
    Math::MPFR::Rmpfr_integer_p($_[1])
      and Math::MPFR::Rmpfr_cmp_z($_[1], $_[0]) == 0;
};

Class::Multimethods::multimethod __eq__ => qw(Math::GMPz Math::MPC) => sub {
    (@_) = (_mpz2mpc($_[0]), $_[1]);
    goto &__eq__;
};

Class::Multimethods::multimethod __eq__ => qw(Math::GMPz $) => sub {
    my ($x, $y) = @_;
    (
     $y < 0
     ? Math::GMPz::Rmpz_cmp_si($x, $y)
     : Math::GMPz::Rmpz_cmp_ui($x, $y)
    ) == 0;
};

#
## MPC
#
Class::Multimethods::multimethod __eq__ => qw(Math::MPC Math::MPC) => sub {
    my ($x, $y) = @_;

    my $f1 = Math::MPFR::Rmpfr_init2($PREC);
    my $f2 = Math::MPFR::Rmpfr_init2($PREC);

    Math::MPC::RMPC_RE($f1, $x);
    Math::MPC::RMPC_RE($f2, $y);

    Math::MPFR::Rmpfr_equal_p($f1, $f2) || return 0;

    Math::MPC::RMPC_IM($f1, $x);
    Math::MPC::RMPC_IM($f2, $y);

    Math::MPFR::Rmpfr_equal_p($f1, $f2);
};

Class::Multimethods::multimethod __eq__ => qw(Math::MPC Math::GMPz) => sub {
    (@_) = ($_[0], _mpz2mpc($_[1]));
    goto &__eq__;
};

Class::Multimethods::multimethod __eq__ => qw(Math::MPC Math::GMPq) => sub {
    (@_) = ($_[0], _mpq2mpc($_[1]));
    goto &__eq__;
};

Class::Multimethods::multimethod __eq__ => qw(Math::MPC Math::MPFR) => sub {
    (@_) = ($_[0], _mpfr2mpc($_[1]));
    goto &__eq__;
};

Class::Multimethods::multimethod __eq__ => qw(Math::MPC $) => sub {
    my ($x, $y) = @_;
    my $f = Math::MPFR::Rmpfr_init2($PREC);
    Math::MPC::RMPC_IM($f, $x);
    Math::MPFR::Rmpfr_zero_p($f) || return 0;
    Math::MPC::RMPC_RE($f, $x);
    (@_) = ($f, $y);
    goto &__eq__;
};

1;
