#!perl -T

use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 189;

use Math::AnyNum qw(:special rat float complex);

like(beta(3,            5),            qr/^0\.00952380952380952380952380952\d*\z/);
like(beta(-3.5,         1.2),          qr/^-0\.171367065975014844712104\d*\z/);
like(beta(rat('1/2'),   rat('1/2')),   qr/^3\.1415926535897932384626433\d*\z/);
like(beta(rat('1/2'),   0.5),          qr/^3\.1415926535897932384626433\d*\z/);
like(beta(rat('1/2'),   '1/2'),        qr/^3\.1415926535897932384626433\d*\z/);
like(beta('1/2',        '1/2'),        qr/^3\.1415926535897932384626433\d*\z/);
like(beta('1/2',        rat('1/2')),   qr/^3\.1415926535897932384626433\d*\z/);
like(beta(0.5,          0.5),          qr/^3\.1415926535897932384626433\d*\z/);
like(beta(complex(0.5), complex(0.5)), qr/^3\.1415926535897932384626433\d*\z/);

{
    my $f1 = float('0.5');
    my $f2 = float('1.5');

    like(beta($f1, $f2), qr/^1\.570796326794896619231321691639751\d*\z/);

    is($f1, '0.5');
    is($f2, '1.5');

    like(atan2($f1, $f2), qr/^0\.3217505543966421934014046143586613\d*\z/);

    is($f1, '0.5');
    is($f2, '1.5');

    like(hypot($f1, $f2), qr/^1\.58113883008418966599944677221635926\d*\z/);

    is($f1, '0.5');
    is($f2, '1.5');

    like(agm($f1, $f2), qr/^0\.931808391622448271177844515512135297\d*\z/);

    is($f1, '0.5');
    is($f2, '1.5');

    $f1 = complex($f1);
    $f2 = complex($f2);

    like(atan2($f1, $f2), qr/^0\.3217505543966421934014046143586613\d*\z/);

    is($f1, '0.5');
    is($f2, '1.5');

    like(hypot($f1, $f2), qr/^1\.58113883008418966599944677221635926\d*\z/);

    is($f1, '0.5');
    is($f2, '1.5');
}

is(rat(42) / 0,      'Inf');
is(rat(-42) / 0,     '-Inf');
is(float(42) / 0,    'Inf');
is(float(-42) / 0,   '-Inf');
is(complex(42) / 0,  'Inf+NaNi');
is(complex(-42) / 0, '-Inf+NaNi');

is(rat(42) / rat(0),      'Inf');
is(rat(-42) / rat(0),     '-Inf');
is(float(42) / rat(0),    'Inf');
is(float(-42) / rat(0),   '-Inf');
is(complex(42) / rat(0),  'Inf+NaNi');
is(complex(-42) / rat(0), '-Inf+NaNi');

is(rat(0) / rat(42),      '0');
is(rat(0) / rat(-42),     '0');
is(rat(0) / float(42),    '0');
is(rat(0) / float(-42),   '0');
is(rat(0) / complex(42),  '0');
is(rat(0) / complex(-42), '0');

is(0 / rat(42),      '0');
is(0 / rat(-42),     '0');
is(0 / float(42),    '0');
is(0 / float(-42),   '0');
is(0 / complex(42),  '0');
is(0 / complex(-42), '0');

is(eta(-3), '-0.125');
like(eta('1/2'),           qr/^0\.604898643421630370247265914235955\d*\z/);
like(eta(rat('-3/4')),     qr/^0\.315876145356554312866371877\d*\z/);
like(eta(complex('-3/4')), qr/^0\.315876145356554312866371877\d*\z/);

is(gamma(6), 120);
like(gamma(rat('1/2')),      qr/^1\.77245385090551602729816748334114\d*\z/);
like(gamma(rat('-1/2')),     qr/^-3\.5449077018110320545963349666822\d*\z/);
like(gamma(complex('-1/2')), qr/^-3\.5449077018110320545963349666822\d*\z/);

like(lgamma(0.5),             qr/^0\.5723649429247000870717136756765293558236\d*\z/);
like(lgamma('1/2'),           qr/^0\.5723649429247000870717136756765293558236\d*\z/);
like(lgamma(rat('-1/2')),     qr/^1\.265512123484645396488945797134705\d*\z/);
like(lgamma(complex('-1/2')), qr/^1\.265512123484645396488945797134705\d*\z/);

like(lngamma(0.5),         qr/^0\.5723649429247000870717136756765293558236\d*\z/);
like(lngamma('1/2'),       qr/^0\.5723649429247000870717136756765293558236\d*\z/);
like(lngamma(complex(50)), qr/^144\.56574394634488600891844306296897\d*\z/);

like(digamma(3),          qr/^0\.9227843350984671393934879099175975\d*\z/);
like(digamma(float('3')), qr/^0\.9227843350984671393934879099175975\d*\z/);
like(digamma('1/2'),      qr/^-1\.96351002602142347944097633299\d*\z/);

like(Ai(3),          qr/^0\.0065911393574607191442574484079613\d*\z/);
like(Ai(float('3')), qr/^0\.0065911393574607191442574484079613\d*\z/);
like(Ai('-1/2'),     qr/^0\.475728091610539588798643778281\d*\z/);

like(zeta(2),          qr/^1\.644934066848226436472415166646\d*\z/);
like(Ei(3),            qr/^9\.93383257062541655800833601921676\d*\z/);
like(Li(3),            qr/^2\.16358859466719197287692236734772\d*\z/);
like(Li2(3),           qr/^2\.3201804233130983964061944737031\d*\z/);
like(LambertW(3),      qr/^1\.0499088949640399599886970\d*\z/);
like(LambertW('3+4i'), qr/^1\.281561806123775878151693432366363\d*\+0\.53309522202097107130904031005820\d*i\z/);
like(lgrt(3),          qr/^1\.8254550229248300400414692977405\d*\z/);
like(lgrt('3+4i'),     qr/^2\.16451037205781732329483408\d*\+0\.520464705097416694328450543626720606\d*i\z/);
like(pow(3, 4), qr/^81\z/);

like(BesselJ(3,            4),       qr/^0\.1320341839246122103286892957786822\d*\z/);
like(BesselJ(3.5,          0),       qr/^-0\.3801277399872633773787493043869623\d*\z/);
like(BesselJ(3.5,          1),       qr/^0\.1373775273623271857161318971839706\d*\z/);
like(BesselJ(-3.5,         1),       qr/^-0\.1373775273623271857161318971839706\d*\z/);
like(BesselJ(3.5,          2),       qr/^0\.4586291841943074835022532456349456\d*\z/);
like(BesselJ(3,            4.9),     qr/^0\.1320341839246122103286892957786822\d*\z/);    # 4.9 gets truncated to 4
like(BesselJ('1/2',        -4),      qr/^0\.00016073647636428759684002811094\d*\z/);
like(BesselJ(float('1/2'), -4),      qr/^0\.00016073647636428759684002811094\d*\z/);
like(BesselJ(rat('1/2'),   -4),      qr/^0\.00016073647636428759684002811094\d*\z/);
like(BesselJ(rat('1/2'),   rat(-4)), qr/^0\.00016073647636428759684002811094\d*\z/);
like(BesselJ('1/2',        rat(-4)), qr/^0\.00016073647636428759684002811094\d*\z/);

like(BesselY(3,        4),      qr/^-0\.916682838725139506333639511139208009511\d*\z/);
like(BesselY(float(3), 4),      qr/^-0\.916682838725139506333639511139208009511\d*\z/);
like(BesselY(rat(3),   rat(4)), qr/^-0\.916682838725139506333639511139208009511\d*\z/);
like(BesselY(3,        rat(4)), qr/^-0\.916682838725139506333639511139208009511\d*\z/);
like(BesselY(3.5,      2),      qr/^0\.04537143772918028346059404157378122135039\d*\z/);
like(BesselY(3.5,      1),      qr/^0\.4101884178875118828721196834074010689\d*\z/);
like(BesselY(3.5,      0),      qr/^0\.18902194392082650675204577751616224660\d*\z/);

like(pow('-1/2',        '1/2'), qr/^0\.70710678118654752440084436210484903928\d*i\z/);
like(pow('-3',          '1/2'), qr/^1\.73205080756887729352744634150587236694\d*i\z/);
like(pow('-3',          0.5),   qr/^1\.73205080756887729352744634150587236694\d*i\z/);
like(pow(rat('-3'),     0.5),   qr/^1\.73205080756887729352744634150587236694\d*i\z/);
like(pow(complex('-3'), 0.5),   qr/^1\.73205080756887729352744634150587236694\d*i\z/);

is(pow('-1/2', '4'),           '1/16');
is(pow('-1/2', rat('4')),      '1/16');
is(pow('-1/2', rat('-4')),     '16');
is(pow('-1/2', float('-4')),   '16');
is(pow('-1/2', complex('-4')), '16');
is(pow('-1/2', '3'),           '-1/8');

is(sqr(3),               '9');
is(sqr(rat('-3')),       '9');
is(sqr(rat('-3/4')),     '9/16');
is(sqr('3+4i'),          '-7+24i');
is(sqr(complex('3+4i')), '-7+24i');

is(norm('3+4i'),          '25');
is(norm(complex('3+4i')), '25');
is(norm('-3'),            '9');
is(norm('-3.5'),          '12.25');
is(norm(rat('-3/4')),     '9/16');

is(root('64',        '2'), '8');
is(root(float(64),   2),   8);
is(root(complex(64), 2),   8);
is(root(rat(64),     2),   8);

is(root(rat(125),     float(3)),   5);
is(root(complex(125), complex(3)), 5);
is(root(int(125),     complex(3)), 5);
is(root(int(125),     float(3)),   5);
is(root(float(125),   rat(3)),     5);

is(root(125, rat(3)),     5);
is(root(125, complex(3)), 5);
is(root(125, rat(3)),     5);
is(root(125, int(3)),     5);

like(sqrt(1234),          qr/^35\.128336140500591605870311625356306764540\d*\z/);
like(sqrt(rat(1234)),     qr/^35\.128336140500591605870311625356306764540\d*\z/);
like(sqrt(complex(1234)), qr/^35\.128336140500591605870311625356306764540\d*\z/);
is(sqrt(-1), 'i');
is(sqrt(-4), '2i');
like(sqrt(rat('-1/2')), qr/^0\.7071067811865475244008443621048490\d*i\z/);
like(sqrt('-1/2'),      qr/^0\.7071067811865475244008443621048490\d*i\z/);
is(sqrt('3+4i'), '2+i');

like(cbrt(rat('1/2')),     qr/^0\.79370052598409973737585281963615413\d*\z/);
like(cbrt(complex('1/2')), qr/^0\.79370052598409973737585281963615413\d*\z/);
like(cbrt('1/2'),          qr/^0\.79370052598409973737585281963615413\d*\z/);
like(cbrt(-1),             qr/^0\.5\+0\.8660254037844386467637231707529361834\d*i\z/);
like(cbrt(0.3),            qr/^0\.66943295008216952188265932463993079330341\d*\z/);
like(cbrt('3+4i'),         qr/^1\.628937145922175875214609371717504971\d*\+0\.5201745023045458395456941701\d*i\z/);

is(exp(0), '1');
like(exp(-1),             qr/^0\.36787944117144232159552377016146086744581\d*\z/);
like(exp('1/2'),          qr/^1\.6487212707001281468486507878141635716\d*\z/);
like(exp(complex('1/2')), qr/^1\.6487212707001281468486507878141635716\d*\z/);

like(ln(-1),          qr/^3\.14159265358979323846264338327950288\d*i\z/);
like(ln(float(-1)),   qr/^3\.14159265358979323846264338327950288\d*i\z/);
like(ln(rat(-1)),     qr/^3\.14159265358979323846264338327950288\d*i\z/);
like(ln(complex(-1)), qr/^3\.14159265358979323846264338327950288\d*i\z/);
like(ln(123),         qr/^4\.81218435537241749526200860995993329302\d*\z/);

is(abs('-42'),          '42');
is(abs('42'),           '42');
is(abs(rat('-42')),     '42');
is(abs(rat('42')),      '42');
is(abs(complex('-42')), '42');
is(abs('3+4i'),         '5');

like(erf('-2'),           qr/^-0\.9953222650189527341620692563672529286\d*\z/);
like(erf('1/2'),          qr/^0\.52049987781304653768274665389196452873\d*\z/);
like(erf(complex('1/2')), qr/^0\.52049987781304653768274665389196452873\d*\z/);
like(erf(float('1/2')),   qr/^0\.52049987781304653768274665389196452873\d*\z/);

like(erfc('-2'),         qr/^1\.9953222650189527341620692563672529286108\d*\z/);
like(erfc('1/2'),        qr/^0\.4795001221869534623172533461080354712635\d*\z/);
like(erfc(float('1/2')), qr/^0\.4795001221869534623172533461080354712635\d*\z/);
like(erfc('0.5+0i'),     qr/^0\.4795001221869534623172533461080354712635\d*\z/);

is(hypot(3, 4), 5);
like(hypot(rat('1/2'), rat('3/4')), qr/^0\.9013878188659973232798053168676\d*\z/);
like(hypot('1/2',      rat('3/4')), qr/^0\.9013878188659973232798053168676\d*\z/);
like(hypot(rat('1/2'), '3/4'),      qr/^0\.9013878188659973232798053168676\d*\z/);
like(hypot('-3-7i',    '-2+5i'),    qr/^9\.327379053088815045554475542320556983\d*\z/);

like(agm('1/2',      '3/4'),      qr/^0\.618670109059076115651664900897850\d*\z/);
like(agm(rat('1/2'), '3/4'),      qr/^0\.618670109059076115651664900897850\d*\z/);
like(agm(rat('1/2'), rat('3/4')), qr/^0\.618670109059076115651664900897850\d*\z/);
like(agm('1/2',      rat('3/4')), qr/^0\.618670109059076115651664900897850\d*\z/);

like(agm(complex('3+4i'), '17'),
     qr/^9\.14737506556653398212699689105659172\d*\+3\.10414217328140125706445795960150788220\d*i\z/);
like(agm('-3', '4'), qr/^0\.6346850976655090814274452823332819\d*\+1\.344308708089627302166124189489276064904\d*i\z/);

like(agm(complex('3'), float('4')),   qr/^3\.482027676359570406621962949156686005392\d*\z/);
like(agm(float('3'),   complex('4')), qr/^3\.482027676359570406621962949156686005392\d*\z/);
like(agm(float('3'),   float('4')),   qr/^3\.482027676359570406621962949156686005392\d*\z/);

is(agm('-3',  '0'),   '0');
is(agm('3',   '0'),   '0');
is(agm('-10', '-10'), '-10');
is(agm('10',  '10'),  '10');
is(agm('10',  '-10'), '0');
