use 5.014;
use warnings;

our ($ROUND, $PREC);

sub __csc__ {
    my ($x) = @_;
    goto(ref($x) =~ tr/:/_/rs);

  Math_MPFR: {
        my $r = Math::MPFR::Rmpfr_init2($PREC);
        Math::MPFR::Rmpfr_csc($r, $x, $ROUND);
        return $r;
    }

    # csc(x) = 1/sin(x)
  Math_MPC: {
        my $r = Math::MPC::Rmpc_init2($PREC);
        Math::MPC::Rmpc_sin($r, $x, $ROUND);
        Math::MPC::Rmpc_ui_div($r, 1, $r, $ROUND);
        return $r;
    }
}

1;
