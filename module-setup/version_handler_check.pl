#!/usr/bin/perl

use Getopt::Std;
use Text::Trim qw(trim);
use File::Find::Rule;

getopts('vVp:');

my $verbose = $opt_v;
my $vomit = $opt_V;
my $prefix = $opt_p;

print "**************************************************************************\n";
print "This script helps detect whether a module is using version handler\n";
print "**************************************************************************\n";

foreach my $module (@ARGV) {
  print "examining module $module\n" if $verbose || $vomit;
  my $module_descriptor_file = "$prefix/$module/src/main/resources/META-INF/magnolia/$module.xml";
  open FILE, $module_descriptor_file || die "Could not open $module_descriptor_file: $!";
  my @contents = <FILE>;
  
  my ($mvhandler) = grep(/<versionHandler>/, @contents);
  my $mvhandlerv;
  if ($mvhandler =~ /<versionHandler>/) {
    $mvhandlerv = trim($');
    $mvhandlerv = substr $mvhandlerv, 0, -17;
    print "found the module version handler $mvhandlerv --> OK :) " if $verbose;
  }
  else {
    print "not found the module version handler $versionv --> FAILED :( " if $verbose;
  }
}
