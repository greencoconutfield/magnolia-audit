#!/usr/bin/perl

use Getopt::Std;
use Text::Trim qw(trim);
use File::Find::Rule;

getopts('vVp:');

my $verbose = $opt_v;
my $vomit = $opt_V;
my $prefix = $opt_p;

print "**************************************************************************\n";
print "This script helps detect whether a module is a hybrid\n";
print "**************************************************************************\n";

foreach my $module (@ARGV) {
  print "examining module $module\n" if $verbose || $vomit;
  my $module_resource = "$prefix/$module/src/main/resources/$module";
  if (!is_folder_empty($module_resource)) {
    print "$module is a hybrid module --> please consider to move templates/diglogs/resources to another light-dev module\n" if $verbose || $vomit;
}

}

sub is_folder_empty {
    my $dirname = shift;
    opendir(my $dh, $dirname) or die "Not a directory";
    return scalar(grep { $_ ne "." && $_ ne ".." } readdir($dh)) == 0;
}
