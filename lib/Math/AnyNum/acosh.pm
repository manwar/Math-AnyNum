use 5.014;
use warnings;

our ($ROUND, $PREC);

sub __acosh__ {
    my ($x) = @_;
    goto(ref($x) =~ tr/:/_/rs);

  Math_MPFR: {
        my ($x) = @_;

        # Return a complex number for x < 1
        if (Math::MPFR::Rmpfr_cmp_ui($x, 1) < 0) {
            my $r = _mpfr2mpc($x);
            Math::MPC::Rmpc_acosh($r, $r, $ROUND);
            return $r;
        }

        my $r = Math::MPFR::Rmpfr_init2($PREC);
        Math::MPFR::Rmpfr_acosh($r, $x, $ROUND);
        return $r;
    }

  Math_MPC: {
        my $r = Math::MPC::Rmpc_init2($PREC);
        Math::MPC::Rmpc_acosh($r, $x, $ROUND);
        return $r;
    }
}

1;
