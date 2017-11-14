#!/usr/bin/perl

use Getopt::Std;
use Text::Trim qw(trim);

getopts('vV');

my $verbose = $opt_v;
my $vomit = $opt_V;

foreach my $file (@ARGV) {
  print "examining $file\n" if $verbose || $vomit;
  open FILE, $file || die "Could not open $file: $!";
  my @contents = <FILE>;

  foreach my $label (grep(/label:/, @contents)) {
    print "label = $label\n" if $verbose;
    my $labelv;
    if ($label =~ /label:/) {
      $labelv = trim($');
      print "found label value $labelv\n" if $verbose;
    }

    if ($labelv =~ /[a-zA-Z\.]+\.[a-zA-Z]+/) {
      print "found a i18n key: $labelv\n" if $verbose;
    } elsif ($labelv eq "") {
      print "$file: found an empty label\n";
    } else {
      print "$file: found a hardcoded text label: $labelv\n";
    }
  }
}
