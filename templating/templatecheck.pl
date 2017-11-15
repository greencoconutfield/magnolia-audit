#!/usr/bin/perl

use Getopt::Std;
use File::Basename;
use Text::Trim qw(trim);

getopts('vp:d:');

my $verbose = $opt_v;
# path prefix template script
my $prefix = $opt_p;
# path prefix for dialog definition
my $dialogpath = $opt_d;

my @yaml = glob "$prefix/*.yaml";

foreach my $file (@yaml) {
  print "examining $file\n" if $verbose;
  open FILE, $file || die "Could not open $file: $!";
  my @contents = <FILE>;

  my ($tscript) = grep(/templateScript:/, @contents);
  my $tscriptv;
  if ($tscript =~ /templateScript:/) {
    $tscriptv = trim($');
  }
  my ($tsname, $tsdir, $tsext) = fileparse($tscriptv, qr/\.[^.]*/);
  print "found template script: $tscriptv name: $tsname dir: $tsdir ext: $tsext\n" if $verbose;

  my ($dialog) = grep(/dialog:/, @contents);
  my $dialogv, $dialogp;
  if ($dialog =~/dialog:/) {
    $dialogv = trim($');
    my ($dprefix, $dpath) = split(/:/, trim($'));
    $dialogp = "$dialogpath$dpath.yaml";
  }

  my ($fname, $fdir, $fext) = fileparse($file, qr/\.[^.]*/);
  print "found file name: $fname dir: $fdir ext: $fext\n" if $verbose;

  print "template definition name $fname ($file) does not match template script name $tsname ($tscriptv)\n" if ($fname ne $tsname);
  print "checking for $prefix$tscriptv\n" if $verbose;
  print "template script $tscriptv does not exist in template definition $file!\n" unless -e "$prefix$tscriptv";
  print "checking for $dialogp\n" if $verbose;
  print "dialog $dialogp does not exist in template definition $file\n" unless -e $dialogp;
}
