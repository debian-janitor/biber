# -*- cperl -*-
use strict;
use warnings;
use Test::More tests => 1;
use Test::Differences;
unified_diff;
use Text::Diff::Config;
$Text::Diff::Config::Output_Unicode = 1;

use Encode;
use Biber;
use Biber::Utils;
use Biber::Output::biblatexml;
use Log::Log4perl;
use Unicode::Normalize;
use Cwd 'abs_path';

chdir("t/tdata");
no warnings 'utf8';
use utf8;

# Set up Biber object
my $biber = Biber->new(tool => 1,
                       configtool => abs_path('../../data/biber-tool.conf'),
                       configfile => 'tool-test.conf');
my $LEVEL = 'ERROR';
my $l4pconf = qq|
    log4perl.category.main                             = $LEVEL, Screen
    log4perl.category.screen                           = $LEVEL, Screen
    log4perl.appender.Screen                           = Log::Log4perl::Appender::Screen
    log4perl.appender.Screen.utf8                      = 1
    log4perl.appender.Screen.Threshold                 = $LEVEL
    log4perl.appender.Screen.stderr                    = 0
    log4perl.appender.Screen.layout                    = Log::Log4perl::Layout::SimpleLayout
|;
Log::Log4perl->init(\$l4pconf);

my $outvar;

$biber->set_output_obj(Biber::Output::biblatexml->new());
# Get reference to output object
my $out = $biber->get_output_obj;

# Options - we could set these in the control file but it's nice to see what we're
# relying on here for tests

# Biber options
Biber::Config->setoption('output_resolve_xdata', 1);
Biber::Config->setoption('output_resolve_crossrefs', 1);
Biber::Config->setoption('output_format', 'biblatexml');
Biber::Config->setoption('input_format', 'biblatexml');
Biber::Config->setoption('sortlocale', 'en_GB.UTF-8');
Biber::Config->setoption('dsn', 'biblatexml.bltxml');

# Set the output target
$out->set_output_target($out->set_output_target_file(\$outvar, 1));

# THERE IS A CONFIG FILE BEING READ!

# Now generate the information
$ARGV[0] = 'biblatexml.bltxml'; # fake this as we are not running through top-level biber program
$biber->tool_mode_setup;

$biber->prepare_tool;
$out->output;
my $main = $biber->datalists->get_lists_by_attrs(section                    => 99999,
                                       name                       => 'tool/global//global/global',
                                       type                       => 'entry',
                                       sortingtemplatename             => 'tool',
                                       sortingnamekeytemplatename      => 'global',
                                       labelprefix                => '',
                                       uniquenametemplatename     => 'global',
                                       labelalphanametemplatename => 'global')->[0];

my $bltxml1 = q|<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="biblatexml.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
<!-- Auto-generated by Biber::Output::biblatexml -->

<bltx:entries xmlns:bltx="http://biblatex-biber.sourceforge.net/biblatexml">
  <bltx:entry id="bltx1" entrytype="book">
    <bltx:ids>
      <bltx:list>
        <bltx:item>bltx1a1</bltx:item>
        <bltx:item>bltx1a2</bltx:item>
      </bltx:list>
    </bltx:ids>
    <bltx:options>useprefix=false</bltx:options>
    <bltx:names type="afterword">
      <bltx:name gender="sm">
        <bltx:namepart type="family" initial="B">Brown</bltx:namepart>
        <bltx:namepart type="given" initial="J">John</bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:names type="author" morenames="1" useprefix="true">
      <bltx:name gender="sm">
        <bltx:namepart type="family" initial="Б">Булгаков</bltx:namepart>
        <bltx:namepart type="given">
          <bltx:namepart initial="П">Павел</bltx:namepart>
          <bltx:namepart initial="Г">Георгиевич</bltx:namepart>
        </bltx:namepart>
        <bltx:namepart type="prefix" initial="v">von</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="Р">Розенфельд</bltx:namepart>
        <bltx:namepart type="given">
          <bltx:namepart initial="Б-Z">Борис-ZZ</bltx:namepart>
          <bltx:namepart initial="A">Aбрамович</bltx:namepart>
        </bltx:namepart>
        <bltx:namepart type="prefix" initial="v">von</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="A">Aхмедов</bltx:namepart>
        <bltx:namepart type="given">
          <bltx:namepart initial="A">Ашраф</bltx:namepart>
          <bltx:namepart initial="А">Ахмедович</bltx:namepart>
        </bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:names type="editor">
      <bltx:name gender="sm">
        <bltx:namepart type="family" initial="S">Smith</bltx:namepart>
        <bltx:namepart type="given" initial="P">Paul</bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:names type="translator">
      <bltx:name gender="sm">
        <bltx:namepart type="family" initial="B">Brown</bltx:namepart>
        <bltx:namepart type="given" initial="J">John</bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:language>
      <bltx:list>
        <bltx:item>russian</bltx:item>
      </bltx:list>
    </bltx:language>
    <bltx:location>
      <bltx:list>
        <bltx:item>Москва</bltx:item>
      </bltx:list>
    </bltx:location>
    <bltx:publisher>
      <bltx:list>
        <bltx:item>Наука</bltx:item>
      </bltx:list>
    </bltx:publisher>
    <bltx:pagetotal>240</bltx:pagetotal>
    <bltx:relatedstring>Somestring</bltx:relatedstring>
    <bltx:relatedtype>reprint</bltx:relatedtype>
    <bltx:series>Научно-биографическая литература</bltx:series>
    <bltx:title>Мухаммад ибн муса ал-Хорезми. Около 783 – около 850</bltx:title>
    <bltx:usera>usera</bltx:usera>
    <bltx:userb>userb</bltx:userb>
    <bltx:userc>userc</bltx:userc>
    <bltx:userd>userd</bltx:userd>
    <bltx:usere>a</bltx:usere>
    <bltx:pages>
      <bltx:list>
        <bltx:item>
          <bltx:start>1</bltx:start>
          <bltx:end>10</bltx:end>
        </bltx:item>
        <bltx:item>
          <bltx:start>30</bltx:start>
          <bltx:end>34</bltx:end>
        </bltx:item>
      </bltx:list>
    </bltx:pages>
    <bltx:date>198X</bltx:date>
    <bltx:date type="event">
      <bltx:start>1990-05-16</bltx:start>
      <bltx:end>1990-05-17</bltx:end>
    </bltx:date>
    <bltx:date type="orig">-356</bltx:date>
    <bltx:date type="url">
      <bltx:start>1991~</bltx:start>
      <bltx:end></bltx:end>
    </bltx:date>
    <bltx:annotation field="author" name="alt" literal="0">names-ann3</bltx:annotation>
    <bltx:annotation field="author" name="default" literal="0">names-ann</bltx:annotation>
    <bltx:annotation field="language" name="default" literal="0">list-ann1</bltx:annotation>
    <bltx:annotation field="title" name="default" literal="0">field-ann1</bltx:annotation>
    <bltx:annotation field="author" name="default" item="1" literal="0">name-ann1</bltx:annotation>
    <bltx:annotation field="author" name="default" item="3" literal="0">name-ann2</bltx:annotation>
    <bltx:annotation field="language" name="default" item="1" literal="0">item-ann1</bltx:annotation>
    <bltx:annotation field="author" name="default" item="1" part="given" literal="1">namepart-ann1</bltx:annotation>
    <bltx:annotation field="author" name="default" item="2" part="family" literal="0">namepart-ann2</bltx:annotation>
  </bltx:entry>
</bltx:entries>
|;

# NFD here because we are testing internals here and all internals expect NFD
eq_or_diff($outvar, encode_utf8($bltxml1), 'bltxml in and out tool mode - 1');


