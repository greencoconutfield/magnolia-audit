#!/usr/bin/perl

use Getopt::Std;
use Text::Trim qw(trim);
use File::Find::Rule;

getopts('vVp:');

my $verbose = $opt_v;
my $vomit = $opt_V;
my $prefix = $opt_p;

my @pom = glob "$prefix/*pom.xml";

my @files = File::Find::Rule->file()
                            ->maxdepth(2)
                            ->name( 'pom.xml' )
                            ->in($prefix);

foreach my $file (@files) {
  print "examining $file\n" if $verbose || $vomit;
  open FILE, $file || die "Could not open $file: $!";
  my @contents = <FILE>;
  foreach my $name (grep(/<name>/, @contents)) {
    $namev = trim($name);
    $namev = substr $namev, 6;
    $namev = substr $namev, 0, -7;
      print "...Checking ... $namev \n" if $verbose;
  }
  foreach my $version (grep(/<version>/, @contents)) {
    $versionv = trim($version);
    print "$versionv" if $verbose;
    my $versionv;
    if ($version =~ /<version>/) {
      $versionv = trim($');
      $versionv = substr $versionv, 0, -10;
      print "found label value $versionv " if $verbose;
    }

    if ($versionv =~ /[0-9\.]+\.[0-9]+/) {
      print "--> you are hardcoding the version  $versionv :(\n" if $verbose;
    }
    else{
      print " --> ALL GOOD :)\n" if $verbose;
    }
  }
}
