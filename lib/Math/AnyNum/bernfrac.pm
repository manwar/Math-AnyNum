use 5.014;
use warnings;

our ($ROUND, $PREC);

# Algorithm due to Kevin J. McGown (December 8, 2005).
# Described in his paper: "Computing Bernoulli Numbers Quickly".

sub __bernfrac__ {
    my ($n) = @_;    # $n is an unsigned integer

    # B(n) = (-1)^(n/2 + 1) * zeta(n)*2*n! / (2*pi)^n

    if ($n == 0) {
        my $r = Math::GMPq::Rmpq_init();
        Math::GMPq::Rmpq_set_ui($r, 1, 1);
        return $r;
    }

    if ($n == 1) {
        my $r = Math::GMPq::Rmpq_init();
        Math::GMPq::Rmpq_set_ui($r, 1, 2);
        return $r;
    }

    if (($n & 1) and ($n > 1)) {    # Bn = 0 for odd n>1
        my $r = Math::GMPq::Rmpq_init();
        Math::GMPq::Rmpq_set_ui($r, 0, 1);
        return $r;
    }

    my $round = Math::MPFR::MPFR_RNDN();

    my $tau   = 6.28318530717958647692528676655900576839433879875;
    my $log2B = (CORE::log(4 * $tau * $n) / 2 + $n * (CORE::log($n) - CORE::log($tau) - 1)) / CORE::log(2);

    my $prec = (
                $n <= 90
                    ? CORE::int($n * CORE::log($n) + 1)
                    : CORE::int($n + $log2B)
               );

    my $d = Math::GMPz::Rmpz_init();
    Math::GMPz::Rmpz_fac_ui($d, $n);                      # d = n!

    my $K = Math::MPFR::Rmpfr_init2($prec);
    Math::MPFR::Rmpfr_const_pi($K, $round);               # K = pi
    Math::MPFR::Rmpfr_pow_si($K, $K, -$n, $round);        # K = K^(-n)
    Math::MPFR::Rmpfr_mul_z($K, $K, $d, $round);          # K = K*d
    Math::MPFR::Rmpfr_div_2ui($K, $K, $n - 1, $round);    # K = K / 2^(n-1)

    Math::GMPz::Rmpz_set_ui($d, 1);                       # d = 1

    my @primes;

    {  # Sieve the primes <= n+1
        my @composite;
        foreach my $i (2 .. CORE::sqrt($n) + 1) {
            for (my $j = $i**2 ; $j <= $n + 1 ; $j += $i) {
                $composite[$j] = 1;
            }
        }

        foreach my $p (2 .. $n + 1) {
            if (!$composite[$p]) {

                if ($n % ($p - 1) == 0) {
                    Math::GMPz::Rmpz_mul_ui($d, $d, $p);    # d = d*p   iff (p-1)|n
                }

                push @primes, $p;
            }
        }
    }

    my $N = Math::MPFR::Rmpfr_init2(64);
    Math::MPFR::Rmpfr_mul_z($N, $K, $d, $round);            # N = K*d
    Math::MPFR::Rmpfr_root($N, $N, $n - 1, $round);         # N = N^(1/(n-1))
    Math::MPFR::Rmpfr_ceil($N, $N);                         # N = ceil(N)

    $N = Math::MPFR::Rmpfr_get_ui($N, $round);              # N = int(N)

    my $z = Math::MPFR::Rmpfr_init2($prec);                 # zeta(n)
    my $u = Math::GMPz::Rmpz_init();                        # p^n

    Math::MPFR::Rmpfr_set_ui($z, 1, $round);                # z = 1

    for (my $i = 0 ; $primes[$i] <= $N ; ++$i) {            # primes <= N
        Math::GMPz::Rmpz_ui_pow_ui($u, $primes[$i], $n);    # u = p^n
        Math::GMPz::Rmpz_sub_ui($u, $u, 1);                 # u = u-1
        Math::MPFR::Rmpfr_mul_z($z, $z, $u, $round);        # z = z*u
        Math::GMPz::Rmpz_add_ui($u, $u, 1);                 # u = u+1
        Math::MPFR::Rmpfr_div_z($z, $z, $u, $round);        # z = z/u
    }

    Math::MPFR::Rmpfr_ui_div($z, 1, $z, $round);            # z = 1 / z
    Math::MPFR::Rmpfr_mul($z, $z, $K, $round);              # z = z * K
    Math::MPFR::Rmpfr_mul_z($z, $z, $d, $round);            # z = z * d
    Math::MPFR::Rmpfr_ceil($z, $z);                         # z = ceil(z)

    my $q = Math::GMPq::Rmpq_init();

    Math::GMPq::Rmpq_set_den($q, $d);                       # denominator
    Math::MPFR::Rmpfr_get_z($d, $z, $round);
    Math::GMPz::Rmpz_neg($d, $d) if $n % 4 == 0;            # d = -d, iff 4|n
    Math::GMPq::Rmpq_set_num($q, $d);                       # numerator

    return $q;                                              # Bn
}

1;
