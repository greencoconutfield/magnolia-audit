#!/usr/bin/perl

use Getopt::Std;

getopts('avVt:');

my $verbose = $opt_v;
my $vomit = $opt_V;
my $all = $opt_a;
my $threshold = (defined $opt_t) ? $opt_t : 0;

foreach my $file (@ARGV) {
  print "examining $file\n" if $verbose || $vomit;
  open FILE, $file || die "Could not open $file: $!";
  my @contents = <FILE>;
  my @found = grep(/\!include/, @contents);

  print "found = @found" if $vomit;
  print "$file: " . ($#found + 1) . " includes\n" if $all || ($#found + 1) >= $threshold;
}
