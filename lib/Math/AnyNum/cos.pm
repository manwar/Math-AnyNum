use 5.014;
use warnings;

our ($ROUND, $PREC);

sub __cos__ {
    my ($x) = @_;
    goto(ref($x) =~ tr/:/_/rs);

  Math_MPFR: {
        my $r = Math::MPFR::Rmpfr_init2($PREC);
        Math::MPFR::Rmpfr_cos($r, $x, $ROUND);
        return $r;
    }

  Math_MPC: {
        my $r = Math::MPC::Rmpc_init2($PREC);
        Math::MPC::Rmpc_cos($r, $x, $ROUND);
        return $r;
    }
}

1;
