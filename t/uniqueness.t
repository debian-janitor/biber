use strict;
use warnings;
use utf8;
no warnings 'utf8';

use Test::More tests => 75;

use Biber;
use Biber::Utils;
use Biber::Output::BBL;
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);
chdir("t/tdata") ;

# Set up Biber object
my $biber = Biber->new(noconf => 1);
$biber->parse_ctrlfile('uniqueness1.bcf');
$biber->set_output_obj(Biber::Output::BBL->new());

# Options - we could set these in the control file but it's nice to see what we're
# relying on here for tests

# Biber options
Biber::Config->setoption('fastsort', 1);
Biber::Config->setoption('sortlocale', 'C');

# Biblatex options
Biber::Config->setblxoption('maxnames', 1);
Biber::Config->setblxoption('uniquename', 2);
Biber::Config->setblxoption('uniquelist', 0);

# Now generate the information
$biber->prepare;
my $section = $biber->sections->get_section(0);
my $bibentries = $section->bibentries;
my $main = $section->get_list('MAIN');

# Basic uniquename and hash testing
is($bibentries->entry('un1')->get_field($bibentries->entry('un1')->get_field('labelnamename'))->nth_element(1)->get_uniquename, '2', 'Uniquename requiring full name expansion - 1');
is($bibentries->entry('un2')->get_field($bibentries->entry('un2')->get_field('labelnamename'))->nth_element(1)->get_uniquename, '2', 'Uniquename requiring full name expansion - 2');
is($bibentries->entry('un5')->get_field($bibentries->entry('un5')->get_field('labelnamename'))->nth_element(1)->get_uniquename, '2', 'Uniquename requiring full name expansion - 3');
is($bibentries->entry('un3')->get_field($bibentries->entry('un2')->get_field('labelnamename'))->nth_element(1)->get_uniquename, '1', 'Uniquename requiring initials name expansion - 1');
is($bibentries->entry('un4')->get_field($bibentries->entry('un4')->get_field('labelnamename'))->nth_element(1)->get_uniquename, '1', 'Uniquename requiring initials name expansion - 2');
is($bibentries->entry('un6')->get_field('namehash'), 'AJ+1', 'Namehash and fullhash different due to maxnames setting - 1');
is($bibentries->entry('un6')->get_field('fullhash'), 'AJBM1', 'Namehash and fullhash different due to maxnames setting - 2');
is($bibentries->entry('un7')->get_field('namehash'), 'C1', 'Fullnamshash ignores SHORT* names - 1');
is($bibentries->entry('un7')->get_field('fullhash'), 'AJBM1', 'Fullnamshash ignores SHORT* names - 2');

$biber = Biber->new(noconf => 1);
$biber->parse_ctrlfile('uniqueness2.bcf');
$biber->set_output_obj(Biber::Output::BBL->new());
# Biber options
Biber::Config->setoption('fastsort', 1);
# Biblatex options
Biber::Config->setblxoption('uniquename', 1);
Biber::Config->setblxoption('uniquelist', 1);
# Now generate the information
$biber->prepare;
$bibentries = $biber->sections->get_section('0')->bibentries;

is($bibentries->entry('un8')->get_field($bibentries->entry('un8')->get_field('labelnamename'))->nth_element(1)->get_uniquename, '0', 'Uniquename - 1');
is($bibentries->entry('un8')->get_field($bibentries->entry('un8')->get_field('labelnamename'))->nth_element(2)->get_uniquename, '0', 'Uniquename - 2');
is($bibentries->entry('un8')->get_field($bibentries->entry('un8')->get_field('labelnamename'))->nth_element(3)->get_uniquename, '1', 'Uniquename - 3');
is($bibentries->entry('un9')->get_field($bibentries->entry('un9')->get_field('labelnamename'))->nth_element(1)->get_uniquename, '0', 'Uniquename - 4');
is($bibentries->entry('un9')->get_field($bibentries->entry('un9')->get_field('labelnamename'))->nth_element(2)->get_uniquename, '0', 'Uniquename - 5');
is($bibentries->entry('un9')->get_field($bibentries->entry('un9')->get_field('labelnamename'))->nth_element(3)->get_uniquename, '1', 'Uniquename - 6');
is($bibentries->entry('un9')->get_field($bibentries->entry('un9')->get_field('labelnamename'))->nth_element(4)->get_uniquename, '0', 'Uniquename - 7');
is($bibentries->entry('un10')->get_field($bibentries->entry('un10')->get_field('labelnamename'))->nth_element(1)->get_uniquename, '0', 'Uniquename - 8');

is($bibentries->entry('un8')->get_field($bibentries->entry('un8')->get_field('labelnamename'))->get_uniquelist, '3', 'Uniquelist - 1');
is($bibentries->entry('un9')->get_field($bibentries->entry('un9')->get_field('labelnamename'))->get_uniquelist, '3', 'Uniquelist - 2');
ok(is_undef($bibentries->entry('un10')->get_field($bibentries->entry('un10')->get_field('labelnamename'))->get_uniquelist), 'Uniquelist - 3');
is($bibentries->entry('unapa1')->get_field($bibentries->entry('unapa1')->get_field('labelnamename'))->get_uniquelist, '3', 'Uniquelist - 4');
is($bibentries->entry('unapa2')->get_field($bibentries->entry('unapa2')->get_field('labelnamename'))->get_uniquelist, '3', 'Uniquelist - 5');
ok(is_undef($bibentries->entry('others1')->get_field($bibentries->entry('others1')->get_field('labelnamename'))->get_uniquelist), 'Uniquelist - 6');

# These next two should have uniquelist undef as they are identical author lists and so
# can't be disambiguated (and shouldn't be).
ok(is_undef($bibentries->entry('unall1')->get_field($bibentries->entry('unall1')->get_field('labelnamename'))->get_uniquelist), 'Uniquelist - 7');
ok(is_undef($bibentries->entry('unall2')->get_field($bibentries->entry('unall2')->get_field('labelnamename'))->get_uniquelist), 'Uniquelist - 8');

# These all should have uniquelist=5 as even though two are identical, they still both
# need disambiguating from the other one which differs in fifth place
is($bibentries->entry('unall5')->get_field($bibentries->entry('unall5')->get_field('labelnamename'))->get_uniquelist, '5', 'Uniquelist - 9');
is($bibentries->entry('unall6')->get_field($bibentries->entry('unall6')->get_field('labelnamename'))->get_uniquelist, '5', 'Uniquelist - 10');
is($bibentries->entry('unall7')->get_field($bibentries->entry('unall7')->get_field('labelnamename'))->get_uniquelist, '5', 'Uniquelist - 11');
# unall8/unall9 are the same (ul=5) and unall10 is superset of them (ul=6)
is($bibentries->entry('unall8')->get_field($bibentries->entry('unall8')->get_field('labelnamename'))->get_uniquelist, '5', 'Uniquelist - 12');
is($bibentries->entry('unall9')->get_field($bibentries->entry('unall9')->get_field('labelnamename'))->get_uniquelist, '5', 'Uniquelist - 13');
is($bibentries->entry('unall10')->get_field($bibentries->entry('unall10')->get_field('labelnamename'))->get_uniquelist, '6', 'Uniquelist - 14');

# These next two should have uniquelist 5/6 as they need disambiguating in place 5
is($bibentries->entry('unall3')->get_field($bibentries->entry('unall3')->get_field('labelnamename'))->get_uniquelist, '5', 'Uniquelist - 15');
is($bibentries->entry('unall4')->get_field($bibentries->entry('unall4')->get_field('labelnamename'))->get_uniquelist, '6', 'Uniquelist - 16');

$biber = Biber->new(noconf => 1);
$biber->parse_ctrlfile('uniqueness3.bcf');
$biber->set_output_obj(Biber::Output::BBL->new());
# Biber options
Biber::Config->setoption('fastsort', 1);
# Biblatex options
Biber::Config->setblxoption('uniquename', 1);
Biber::Config->setblxoption('uniquelist', 0);
Biber::Config->setblxoption('singletitle', 1);
Biber::Config->setblxoption('labelyearspec', [ 'year' ]);
# Now generate the information
$biber->prepare;
$section = $biber->sections->get_section(0);
$bibentries = $section->bibentries;
$main = $section->get_list('MAIN');

is($main->get_extraalphadata('ey1'), '1', 'Extrayear - 1');
is($main->get_extraalphadata('ey2'), '2', 'Extrayear - 2');
is($main->get_extraalphadata('ey3'), '1', 'Extrayear - 3');
is($main->get_extraalphadata('ey4'), '2', 'Extrayear - 4');
is($main->get_extraalphadata('ey5'), '1', 'Extrayear - 5');
is($main->get_extraalphadata('ey6'), '2', 'Extrayear - 6');
ok(is_undef($bibentries->entry('ey1')->get_field('singletitle')), 'Singletitle - 1');
ok(is_undef($bibentries->entry('ey2')->get_field('singletitle')), 'Singletitle - 2');
ok(is_undef($bibentries->entry('ey5')->get_field('singletitle')), 'Singletitle - 3');

$biber = Biber->new(noconf => 1);
$biber->parse_ctrlfile('uniqueness3.bcf');
$biber->set_output_obj(Biber::Output::BBL->new());
# Biber options
Biber::Config->setoption('fastsort', 1);
# Biblatex options
Biber::Config->setblxoption('uniquename', 2);
Biber::Config->setblxoption('uniquelist', 1);
Biber::Config->setblxoption('singletitle', 1);
Biber::Config->setblxoption('labelyearspec', [ 'year' ]);
# Now generate the information
$biber->prepare;
$section = $biber->sections->get_section(0);
$bibentries = $section->bibentries;
$main = $section->get_list('MAIN');

ok(is_undef($main->get_extraalphadata('ey1')), 'Extrayear - 7');
ok(is_undef($main->get_extraalphadata('ey2')), 'Extrayear - 8');
is($main->get_extraalphadata('ey3'), '1', 'Extrayear - 9');
is($main->get_extraalphadata('ey4'), '2', 'Extrayear - 10');
ok(is_undef($main->get_extraalphadata('ey5')), 'Extrayear - 11');
ok(is_undef($main->get_extraalphadata('ey6')), 'Extrayear - 12');
is($bibentries->entry('ey1')->get_field('singletitle'), '1', 'Singletitle - 4');
is($bibentries->entry('ey2')->get_field('singletitle'), '1', 'Singletitle - 5');
is($bibentries->entry('ey5')->get_field('singletitle'), '1', 'Singletitle - 6');

$biber = Biber->new(noconf => 1);
$biber->parse_ctrlfile('uniqueness3.bcf');
$biber->set_output_obj(Biber::Output::BBL->new());
# Biber options
Biber::Config->setoption('fastsort', 1);
# Biblatex options
Biber::Config->setblxoption('uniquename', 0);
Biber::Config->setblxoption('uniquelist', 0);
Biber::Config->setblxoption('singletitle', 1);
Biber::Config->setblxoption('labelyearspec', [ 'year' ]);
# Now generate the information
$biber->prepare;
$section = $biber->sections->get_section(0);
$bibentries = $section->bibentries;
$main = $section->get_list('MAIN');

is($main->get_extraalphadata('ey1'), '1', 'Extrayear - 13');
is($main->get_extraalphadata('ey2'), '2', 'Extrayear - 14');
is($main->get_extraalphadata('ey3'), '1', 'Extrayear - 15');
is($main->get_extraalphadata('ey4'), '2', 'Extrayear - 16');
is($main->get_extraalphadata('ey5'), '1', 'Extrayear - 17');
is($main->get_extraalphadata('ey6'), '2', 'Extrayear - 18');
ok(is_undef($bibentries->entry('ey1')->get_field('singletitle')), 'Singletitle - 7');
ok(is_undef($bibentries->entry('ey2')->get_field('singletitle')), 'Singletitle - 8');


# Testing uniquename = 3
$biber = Biber->new(noconf => 1);
$biber->parse_ctrlfile('uniqueness2.bcf');
$biber->set_output_obj(Biber::Output::BBL->new());
# Biber options
Biber::Config->setoption('fastsort', 1);
# Biblatex options
Biber::Config->setblxoption('uniquename', 3);
Biber::Config->setblxoption('uniquelist', 1);
# Now generate the information
$biber->prepare;
$section = $biber->sections->get_section(0);
$bibentries = $section->bibentries;
$main = $section->get_list('MAIN');

is($bibentries->entry('un8')->get_field($bibentries->entry('un8')->get_field('labelnamename'))->nth_element(1)->get_uniquename, '0', 'Forced init expansion - 1');
is($bibentries->entry('un8')->get_field($bibentries->entry('un8')->get_field('labelnamename'))->nth_element(2)->get_uniquename, '0', 'Forced init expansion - 2');
is($bibentries->entry('un8')->get_field($bibentries->entry('un8')->get_field('labelnamename'))->nth_element(3)->get_uniquename, '1', 'Forced init expansion - 3');
is($bibentries->entry('un9')->get_field($bibentries->entry('un9')->get_field('labelnamename'))->nth_element(1)->get_uniquename, '0', 'Forced init expansion - 4');
is($bibentries->entry('un9')->get_field($bibentries->entry('un9')->get_field('labelnamename'))->nth_element(2)->get_uniquename, '0', 'Forced init expansion - 5');
is($bibentries->entry('un9')->get_field($bibentries->entry('un9')->get_field('labelnamename'))->nth_element(3)->get_uniquename, '1', 'Forced init expansion - 6');
is($bibentries->entry('un9')->get_field($bibentries->entry('un9')->get_field('labelnamename'))->nth_element(4)->get_uniquename, '1', 'Forced init expansion - 7');
is($bibentries->entry('un10')->get_field($bibentries->entry('un10')->get_field('labelnamename'))->nth_element(1)->get_uniquename, '1', 'Forced init expansion - 8');

# Testing uniquename = 4
$biber = Biber->new(noconf => 1);
$biber->parse_ctrlfile('uniqueness2.bcf');
$biber->set_output_obj(Biber::Output::BBL->new());
# Biber options
Biber::Config->setoption('fastsort', 1);
# Biblatex options
Biber::Config->setblxoption('uniquename', 4);
Biber::Config->setblxoption('uniquelist', 1);
# Now generate the information
$biber->prepare;
$section = $biber->sections->get_section(0);
$bibentries = $section->bibentries;
$main = $section->get_list('MAIN');

is($bibentries->entry('un8')->get_field($bibentries->entry('un8')->get_field('labelnamename'))->nth_element(1)->get_uniquename, '2', 'Forced name expansion - 1');
is($bibentries->entry('un8')->get_field($bibentries->entry('un8')->get_field('labelnamename'))->nth_element(2)->get_uniquename, '0', 'Forced name expansion - 2');
is($bibentries->entry('un8')->get_field($bibentries->entry('un8')->get_field('labelnamename'))->nth_element(3)->get_uniquename, '1', 'Forced name expansion - 3');
is($bibentries->entry('un9')->get_field($bibentries->entry('un9')->get_field('labelnamename'))->nth_element(1)->get_uniquename, '2', 'Forced name expansion - 4');
is($bibentries->entry('un9')->get_field($bibentries->entry('un9')->get_field('labelnamename'))->nth_element(2)->get_uniquename, '0', 'Forced name expansion - 5');
is($bibentries->entry('un9')->get_field($bibentries->entry('un9')->get_field('labelnamename'))->nth_element(3)->get_uniquename, '1', 'Forced name expansion - 6');
is($bibentries->entry('un9')->get_field($bibentries->entry('un9')->get_field('labelnamename'))->nth_element(4)->get_uniquename, '1', 'Forced name expansion - 7');
is($bibentries->entry('un10')->get_field($bibentries->entry('un10')->get_field('labelnamename'))->nth_element(1)->get_uniquename, '1', 'Forced name expansion - 8');

