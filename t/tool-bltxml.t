# -*- cperl -*-
use strict;
use warnings;
use Test::More tests => 3;
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
                       configfile => 'tool-testsort.conf');
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
Biber::Config->setoption('output_xdatasep', '_');
Biber::Config->setoption('output_resolve_xdata', 1);
Biber::Config->setoption('output_resolve_crossrefs', 1);
Biber::Config->setoption('output_format', 'biblatexml');
Biber::Config->setoption('sortlocale', 'en_GB.UTF-8');
Biber::Config->setoption('dsn', 'tool.bib');

# Set the output target
$out->set_output_target($out->set_output_target_file(\$outvar, 1));

# THERE IS A CONFIG FILE BEING READ!

# Now generate the information
$ARGV[0] = 'tool.bib'; # fake this as we are not running through top-level biber program
$biber->tool_mode_setup;
$biber->prepare_tool;
$out->output;

my $main = $biber->datalists->get_lists_by_attrs(section         => 99999,
                                      name                       => 'tool/global//global/global',
                                      type                       => 'entry',
                                      sortingtemplatename        => 'tool',
                                      sortingnamekeytemplatename => 'global',
                                      labelprefix                => '',
                                      uniquenametemplatename     => 'global',
                                      labelalphanametemplatename => 'global')->[0];

my $bltxml1 = q|<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="tool.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
<!-- Auto-generated by Biber::Output::biblatexml -->

<bltx:entries xmlns:bltx="http://biblatex-biber.sourceforge.net/biblatexml">
  <bltx:entry id="i3Š" entrytype="unpublished">
    <bltx:options>useprefix=false</bltx:options>
    <bltx:names type="author">
      <bltx:name>
        <bltx:namepart type="family" initial="A">AAA</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="B">BBB</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="C">CCC</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="D">DDD</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="E">EEE</bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:institution>
      <bltx:list>
        <bltx:item>REPlaCEDte</bltx:item>
        <bltx:item>early</bltx:item>
      </bltx:list>
    </bltx:institution>
    <bltx:lista>
      <bltx:list>
        <bltx:item>list test</bltx:item>
      </bltx:list>
    </bltx:lista>
    <bltx:listb>
      <bltx:list>
        <bltx:item>late</bltx:item>
        <bltx:item>early</bltx:item>
      </bltx:list>
    </bltx:listb>
    <bltx:location>
      <bltx:list>
        <bltx:item>one</bltx:item>
        <bltx:item>two</bltx:item>
      </bltx:list>
    </bltx:location>
    <bltx:abstract>Some abstract %50 of which is useless</bltx:abstract>
    <bltx:note>i3Š</bltx:note>
    <bltx:title>Š title</bltx:title>
    <bltx:userb>test</bltx:userb>
    <bltx:date>2003</bltx:date>
  </bltx:entry>
  <bltx:entry id="xd1" entrytype="book">
    <bltx:names type="author">
      <bltx:name>
        <bltx:namepart type="family" initial="E">Ellington</bltx:namepart>
        <bltx:namepart type="given">
          <bltx:namepart initial="E">Edward</bltx:namepart>
          <bltx:namepart initial="P">Paul</bltx:namepart>
        </bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:location>
      <bltx:list>
        <bltx:item>New York</bltx:item>
        <bltx:item>London</bltx:item>
      </bltx:list>
    </bltx:location>
    <bltx:publisher>
      <bltx:list>
        <bltx:item>Macmillan</bltx:item>
      </bltx:list>
    </bltx:publisher>
    <bltx:note>A Note</bltx:note>
    <bltx:date>2001</bltx:date>
  </bltx:entry>
  <bltx:entry id="macmillan" entrytype="xdata">
    <bltx:ids>
      <bltx:list>
        <bltx:item>macmillanalias</bltx:item>
      </bltx:list>
    </bltx:ids>
    <bltx:location>
      <bltx:list>
        <bltx:item>New York</bltx:item>
        <bltx:item>London</bltx:item>
      </bltx:list>
    </bltx:location>
    <bltx:publisher>
      <bltx:list>
        <bltx:item>Macmillan</bltx:item>
      </bltx:list>
    </bltx:publisher>
    <bltx:note>A Note</bltx:note>
    <bltx:date>2001</bltx:date>
  </bltx:entry>
  <bltx:entry id="macmillan:pub" entrytype="xdata">
    <bltx:ids>
      <bltx:list>
        <bltx:item>macmillan:pubALIAS</bltx:item>
      </bltx:list>
    </bltx:ids>
    <bltx:publisher>
      <bltx:list>
        <bltx:item>Macmillan</bltx:item>
      </bltx:list>
    </bltx:publisher>
  </bltx:entry>
  <bltx:entry id="macmillan:loc" entrytype="xdata">
    <bltx:location>
      <bltx:list>
        <bltx:item>New York</bltx:item>
        <bltx:item>London</bltx:item>
      </bltx:list>
    </bltx:location>
    <bltx:note>A Note</bltx:note>
  </bltx:entry>
  <bltx:entry id="b1" entrytype="book">
    <bltx:location>
      <bltx:list>
        <bltx:item>London</bltx:item>
        <bltx:item>Edinburgh</bltx:item>
      </bltx:list>
    </bltx:location>
    <bltx:mainsubtitle>Mainsubtitle</bltx:mainsubtitle>
    <bltx:maintitle>Maintitle</bltx:maintitle>
    <bltx:maintitleaddon>Maintitleaddon</bltx:maintitleaddon>
    <bltx:title>Booktitle</bltx:title>
    <bltx:date>1999</bltx:date>
    <bltx:annotation field="title" name="default" literal="0">ann1, ann2</bltx:annotation>
    <bltx:annotation field="location" name="default" item="1" literal="0">ann1</bltx:annotation>
    <bltx:annotation field="location" name="default" item="2" literal="0">ann2</bltx:annotation>
  </bltx:entry>
  <bltx:entry id="mv1" entrytype="mvbook">
    <bltx:ids>
      <bltx:list>
        <bltx:item>mvalias</bltx:item>
      </bltx:list>
    </bltx:ids>
    <bltx:subtitle>Mainsubtitle</bltx:subtitle>
    <bltx:title>Maintitle</bltx:title>
    <bltx:titleaddon>Maintitleaddon</bltx:titleaddon>
  </bltx:entry>
  <bltx:entry id="dt1" entrytype="book">
    <bltx:date>
      <bltx:start>2004-04-25T14:34:00</bltx:start>
      <bltx:end>2004-04-05T14:37:06</bltx:end>
    </bltx:date>
    <bltx:date type="event">
      <bltx:start>2004-04-25T14:34:00+05:00</bltx:start>
      <bltx:end>2004-04-05T15:34:00+05:00</bltx:end>
    </bltx:date>
    <bltx:date type="orig">
      <bltx:start>2004-04-25T14:34:00Z</bltx:start>
      <bltx:end>2004-04-05T14:34:05Z</bltx:end>
    </bltx:date>
    <bltx:date type="url">
      <bltx:start>2004-04-25T14:34:00</bltx:start>
      <bltx:end>2004-04-05T15:00:00</bltx:end>
    </bltx:date>
  </bltx:entry>
  <bltx:entry id="m1" entrytype="article">
    <bltx:date>2017</bltx:date>
  </bltx:entry>
  <bltx:entry id="badcr1" entrytype="book">
    <bltx:names type="author">
      <bltx:name>
        <bltx:namepart type="family" initial="F">Foo</bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:title>Foo</bltx:title>
    <bltx:date>2019</bltx:date>
  </bltx:entry>
  <bltx:entry id="badcr2" entrytype="book">
    <bltx:names type="author">
      <bltx:name>
        <bltx:namepart type="family" initial="B">Bar</bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:title>Bar</bltx:title>
    <bltx:date>2019</bltx:date>
  </bltx:entry>
  <bltx:entry id="gxd1" entrytype="book">
    <bltx:names type="author">
      <bltx:name>
        <bltx:namepart type="family" initial="S">Smith</bltx:namepart>
        <bltx:namepart type="given" initial="S">Simon</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="B">Bloom</bltx:namepart>
        <bltx:namepart type="given" initial="B">Brian</bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:names type="editor">
      <bltx:name>
        <bltx:namepart type="family" initial="F">Frill</bltx:namepart>
        <bltx:namepart type="given" initial="F">Frank</bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:names type="translator">
      <bltx:name xdata="gxd2_author_3" />
    </bltx:names>
    <bltx:lista>
      <bltx:list>
        <bltx:item xdata="gxd3_location_5" />
      </bltx:list>
    </bltx:lista>
    <bltx:location>
      <bltx:list>
        <bltx:item>A</bltx:item>
        <bltx:item>B</bltx:item>
      </bltx:list>
    </bltx:location>
    <bltx:organization>
      <bltx:list>
        <bltx:item xdata="gxd2_author_3" />
      </bltx:list>
    </bltx:organization>
    <bltx:publisher>
      <bltx:list>
        <bltx:item xdata="gxd2" />
      </bltx:list>
    </bltx:publisher>
    <bltx:addendum xdata="missing" />
    <bltx:note xdata="gxd2_note" />
    <bltx:title>Some title</bltx:title>
  </bltx:entry>
  <bltx:entry id="gxd2" entrytype="xdata">
    <bltx:names type="author">
      <bltx:name>
        <bltx:namepart type="family" initial="B">Bloom</bltx:namepart>
        <bltx:namepart type="given" initial="B">Brian</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="A">Anderson</bltx:namepart>
        <bltx:namepart type="given" initial="A">Arthur</bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:names type="editor">
      <bltx:name>
        <bltx:namepart type="family" initial="W">Wool</bltx:namepart>
        <bltx:namepart type="given" initial="W">William</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="F">Frill</bltx:namepart>
        <bltx:namepart type="given" initial="F">Frank</bltx:namepart>
      </bltx:name>
    </bltx:names>
  </bltx:entry>
  <bltx:entry id="gxd3" entrytype="xdata">
    <bltx:location>
      <bltx:list>
        <bltx:item>A</bltx:item>
        <bltx:item>C</bltx:item>
      </bltx:list>
    </bltx:location>
  </bltx:entry>
  <bltx:entry id="gxd4" entrytype="xdata">
    <bltx:names type="editor">
      <bltx:name>
        <bltx:namepart type="family" initial="F">Frill</bltx:namepart>
        <bltx:namepart type="given" initial="F">Frank</bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:title>Some title</bltx:title>
  </bltx:entry>
  <bltx:entry id="bo1" entrytype="book">
    <bltx:ids>
      <bltx:list>
        <bltx:item>box1</bltx:item>
        <bltx:item>box2</bltx:item>
      </bltx:list>
    </bltx:ids>
    <bltx:names type="author">
      <bltx:name>
        <bltx:namepart type="family" initial="S">Smith</bltx:namepart>
        <bltx:namepart type="given" initial="S">Simon</bltx:namepart>
      </bltx:name>
    </bltx:names>
  </bltx:entry>
  <bltx:entry id="ld1" entrytype="book">
    <bltx:names type="author">
      <bltx:name>
        <bltx:namepart type="family" initial="A">AAA</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="B">BBB</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="C">CCC</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="D">DDD</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="E">EEE</bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:publisher>
      <bltx:list>
        <bltx:item>Publisher</bltx:item>
      </bltx:list>
    </bltx:publisher>
    <bltx:title>A title</bltx:title>
    <bltx:date>2003-04</bltx:date>
  </bltx:entry>
</bltx:entries>
|;

my $bltxml2 = q|<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="tool.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
<!-- Auto-generated by Biber::Output::biblatexml -->

<bltx:entries xmlns:bltx="http://biblatex-biber.sourceforge.net/biblatexml">
  <bltx:entry id="i3Š" entrytype="unpublished">
    <bltx:options>useprefix=false</bltx:options>
    <bltx:names type="author">
      <bltx:name>
        <bltx:namepart type="family" initial="A">AAA</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="B">BBB</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="C">CCC</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="D">DDD</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="E">EEE</bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:institution>
      <bltx:list>
        <bltx:item>REPlaCEDte</bltx:item>
        <bltx:item>early</bltx:item>
      </bltx:list>
    </bltx:institution>
    <bltx:lista>
      <bltx:list>
        <bltx:item>list test</bltx:item>
      </bltx:list>
    </bltx:lista>
    <bltx:listb>
      <bltx:list>
        <bltx:item>late</bltx:item>
        <bltx:item>early</bltx:item>
      </bltx:list>
    </bltx:listb>
    <bltx:location>
      <bltx:list>
        <bltx:item>one</bltx:item>
        <bltx:item>two</bltx:item>
      </bltx:list>
    </bltx:location>
    <bltx:abstract>Some abstract %50 of which is useless</bltx:abstract>
    <bltx:note>i3Š</bltx:note>
    <bltx:title>Š title</bltx:title>
    <bltx:userb>test</bltx:userb>
    <bltx:date>2003</bltx:date>
  </bltx:entry>
  <bltx:entry id="xd1" entrytype="book">
    <bltx:xdata>
      <bltx:list>
        <bltx:item>macmillanalias</bltx:item>
      </bltx:list>
    </bltx:xdata>
    <bltx:names type="author">
      <bltx:name>
        <bltx:namepart type="family" initial="E">Ellington</bltx:namepart>
        <bltx:namepart type="given">
          <bltx:namepart initial="E">Edward</bltx:namepart>
          <bltx:namepart initial="P">Paul</bltx:namepart>
        </bltx:namepart>
      </bltx:name>
    </bltx:names>
  </bltx:entry>
  <bltx:entry id="macmillan" entrytype="xdata">
    <bltx:ids>
      <bltx:list>
        <bltx:item>macmillanalias</bltx:item>
      </bltx:list>
    </bltx:ids>
    <bltx:xdata>
      <bltx:list>
        <bltx:item>macmillan:pubALIAS</bltx:item>
        <bltx:item>macmillan:loc</bltx:item>
      </bltx:list>
    </bltx:xdata>
    <bltx:date>2001</bltx:date>
  </bltx:entry>
  <bltx:entry id="macmillan:pub" entrytype="xdata">
    <bltx:ids>
      <bltx:list>
        <bltx:item>macmillan:pubALIAS</bltx:item>
      </bltx:list>
    </bltx:ids>
    <bltx:publisher>
      <bltx:list>
        <bltx:item>Macmillan</bltx:item>
      </bltx:list>
    </bltx:publisher>
  </bltx:entry>
  <bltx:entry id="macmillan:loc" entrytype="xdata">
    <bltx:location>
      <bltx:list>
        <bltx:item>New York</bltx:item>
        <bltx:item>London</bltx:item>
      </bltx:list>
    </bltx:location>
    <bltx:note>A Note</bltx:note>
  </bltx:entry>
  <bltx:entry id="b1" entrytype="book">
    <bltx:location>
      <bltx:list>
        <bltx:item>London</bltx:item>
        <bltx:item>Edinburgh</bltx:item>
      </bltx:list>
    </bltx:location>
    <bltx:mainsubtitle>Mainsubtitle</bltx:mainsubtitle>
    <bltx:maintitle>Maintitle</bltx:maintitle>
    <bltx:maintitleaddon>Maintitleaddon</bltx:maintitleaddon>
    <bltx:title>Booktitle</bltx:title>
    <bltx:date>1999</bltx:date>
    <bltx:annotation field="title" name="default" literal="0">ann1, ann2</bltx:annotation>
    <bltx:annotation field="location" name="default" item="1" literal="0">ann1</bltx:annotation>
    <bltx:annotation field="location" name="default" item="2" literal="0">ann2</bltx:annotation>
  </bltx:entry>
  <bltx:entry id="mv1" entrytype="mvbook">
    <bltx:ids>
      <bltx:list>
        <bltx:item>mvalias</bltx:item>
      </bltx:list>
    </bltx:ids>
    <bltx:subtitle>Mainsubtitle</bltx:subtitle>
    <bltx:title>Maintitle</bltx:title>
    <bltx:titleaddon>Maintitleaddon</bltx:titleaddon>
  </bltx:entry>
  <bltx:entry id="dt1" entrytype="book">
    <bltx:date>
      <bltx:start>2004-04-25T14:34:00</bltx:start>
      <bltx:end>2004-04-05T14:37:06</bltx:end>
    </bltx:date>
    <bltx:date type="event">
      <bltx:start>2004-04-25T14:34:00+05:00</bltx:start>
      <bltx:end>2004-04-05T15:34:00+05:00</bltx:end>
    </bltx:date>
    <bltx:date type="orig">
      <bltx:start>2004-04-25T14:34:00Z</bltx:start>
      <bltx:end>2004-04-05T14:34:05Z</bltx:end>
    </bltx:date>
    <bltx:date type="url">
      <bltx:start>2004-04-25T14:34:00</bltx:start>
      <bltx:end>2004-04-05T15:00:00</bltx:end>
    </bltx:date>
  </bltx:entry>
  <bltx:entry id="m1" entrytype="article">
    <bltx:date>2017</bltx:date>
  </bltx:entry>
  <bltx:entry id="badcr1" entrytype="book">
    <bltx:names type="author">
      <bltx:name>
        <bltx:namepart type="family" initial="F">Foo</bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:title>Foo</bltx:title>
    <bltx:date>2019</bltx:date>
  </bltx:entry>
  <bltx:entry id="badcr2" entrytype="book">
    <bltx:names type="author">
      <bltx:name>
        <bltx:namepart type="family" initial="B">Bar</bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:title>Bar</bltx:title>
    <bltx:date>2019</bltx:date>
  </bltx:entry>
  <bltx:entry id="gxd1" entrytype="book">
    <bltx:names type="author">
      <bltx:name>
        <bltx:namepart type="family" initial="S">Smith</bltx:namepart>
        <bltx:namepart type="given" initial="S">Simon</bltx:namepart>
      </bltx:name>
      <bltx:name xdata="gxd2+author+1" />
    </bltx:names>
    <bltx:names type="editor">
      <bltx:name xdata="gxd2+editor+2" />
    </bltx:names>
    <bltx:names type="translator">
      <bltx:name xdata="gxd2+author+3" />
    </bltx:names>
    <bltx:lista>
      <bltx:list>
        <bltx:item xdata="gxd3+location+5" />
      </bltx:list>
    </bltx:lista>
    <bltx:location>
      <bltx:list>
        <bltx:item xdata="gxd3+location+1" />
        <bltx:item>B</bltx:item>
      </bltx:list>
    </bltx:location>
    <bltx:organization>
      <bltx:list>
        <bltx:item xdata="gxd2+author+3" />
      </bltx:list>
    </bltx:organization>
    <bltx:publisher>
      <bltx:list>
        <bltx:item xdata="gxd2" />
      </bltx:list>
    </bltx:publisher>
    <bltx:addendum xdata="missing" />
    <bltx:note xdata="gxd2+note" />
    <bltx:title xdata="gxd4+title" />
  </bltx:entry>
  <bltx:entry id="gxd2" entrytype="xdata">
    <bltx:names type="author">
      <bltx:name>
        <bltx:namepart type="family" initial="B">Bloom</bltx:namepart>
        <bltx:namepart type="given" initial="B">Brian</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="A">Anderson</bltx:namepart>
        <bltx:namepart type="given" initial="A">Arthur</bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:names type="editor">
      <bltx:name>
        <bltx:namepart type="family" initial="W">Wool</bltx:namepart>
        <bltx:namepart type="given" initial="W">William</bltx:namepart>
      </bltx:name>
      <bltx:name xdata="gxd4+editor+1" />
    </bltx:names>
  </bltx:entry>
  <bltx:entry id="gxd3" entrytype="xdata">
    <bltx:location>
      <bltx:list>
        <bltx:item>A</bltx:item>
        <bltx:item>C</bltx:item>
      </bltx:list>
    </bltx:location>
  </bltx:entry>
  <bltx:entry id="gxd4" entrytype="xdata">
    <bltx:names type="editor">
      <bltx:name>
        <bltx:namepart type="family" initial="F">Frill</bltx:namepart>
        <bltx:namepart type="given" initial="F">Frank</bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:title>Some title</bltx:title>
  </bltx:entry>
  <bltx:entry id="bo1" entrytype="book">
    <bltx:ids>
      <bltx:list>
        <bltx:item>box1</bltx:item>
        <bltx:item>box2</bltx:item>
      </bltx:list>
    </bltx:ids>
    <bltx:names type="author">
      <bltx:name>
        <bltx:namepart type="family" initial="S">Smith</bltx:namepart>
        <bltx:namepart type="given" initial="S">Simon</bltx:namepart>
      </bltx:name>
    </bltx:names>
  </bltx:entry>
  <bltx:entry id="ld1" entrytype="book">
    <bltx:names type="author">
      <bltx:name>
        <bltx:namepart type="family" initial="A">AAA</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="B">BBB</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="C">CCC</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="D">DDD</bltx:namepart>
      </bltx:name>
      <bltx:name>
        <bltx:namepart type="family" initial="E">EEE</bltx:namepart>
      </bltx:name>
    </bltx:names>
    <bltx:publisher>
      <bltx:list>
        <bltx:item>Publisher</bltx:item>
      </bltx:list>
    </bltx:publisher>
    <bltx:title>A title</bltx:title>
    <bltx:date>2003-04</bltx:date>
  </bltx:entry>
</bltx:entries>
|;


eq_or_diff($outvar, encode_utf8($bltxml1), 'bltxml tool mode - 1');
is_deeply($main->get_keys, ['b1', 'macmillan', 'dt1', 'm1', 'macmillan:pub', 'macmillan:loc', 'mv1', 'gxd3', 'gxd4', NFD('i3Š'), 'ld1', 'badcr2', 'gxd2', 'xd1', 'badcr1', 'bo1', 'gxd1'], 'tool mode sorting');

Biber::Config->setoption('output_resolve_xdata', 0);
Biber::Config->setoption('output_xdatasep', '+');
$outvar = '';
$out->set_output_target($out->set_output_target_file(\$outvar, 1));
$biber->tool_mode_setup;
$biber->prepare_tool;

$out->output;

$main = $biber->datalists->get_lists_by_attrs(section            => 99999,
                                      name                       => 'tool/global//global/global',
                                      type                       => 'entry',
                                      sortingtemplatename        => 'tool',
                                      sortingnamekeytemplatename => 'global',
                                      labelprefix                => '',
                                      uniquenametemplatename     => 'global',
                                      labelalphanametemplatename => 'global')->[0];

eq_or_diff($outvar, encode_utf8($bltxml2), 'bltxml tool mode - 2');

