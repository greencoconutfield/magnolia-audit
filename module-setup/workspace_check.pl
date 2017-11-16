#!/usr/bin/perl

use Getopt::Std;
use Text::Trim qw(trim);
use File::Find::Rule;

getopts('vVp:');

my $verbose = $opt_v;
my $vomit = $opt_V;
my $prefix = $opt_p;

print "**************************************************************************\n";
print "This script helps detect for registering of new workspaces\n";
print "**************************************************************************\n";

foreach my $module (@ARGV) {
  print "examining module $module\n" if $verbose || $vomit;
  my $module_descriptor_file = "$prefix/$module/src/main/resources/META-INF/magnolia/$module.xml";
  open FILE, $module_descriptor_file || die "Could not open $module_descriptor_file: $!";
  my @contents = <FILE>;
  my $workspace_count = 0;
  foreach my $workspace (grep(/<workspace>/, @contents)) {
    if ($workspace =~ /<workspace>/) {
      $workspacev = trim($');
      $workspacev = substr $workspacev, 0, -12;
      print "found a new workspace registered - $workspacev --> Please make sure that you put the related content/data into the same workspace \n" if $verbose;
    }
  }
}
