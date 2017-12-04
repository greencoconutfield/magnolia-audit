#!/usr/bin/perl

use Getopt::Std;
use File::Basename;
use Text::Trim qw(trim);
use POSIX qw/strftime/;
use Time::Piece (); 
use File::Find::Rule;

$curent_time = localtime;

getopts('a:p:t:');

my $verbose = $opt_v;
my $vomit = $opt_V;
my $all = (defined $opt_a) ? $opt_a : 0;
my $threshold = (defined $opt_t) ? $opt_t : 1;

my $prefix = $opt_p;

open my $log_file, ">>", "../logs/log_inc_check_$curent_time.txt" or die "Can't open 'log.txt'\n";

my @modules = File::Find::Rule->directory()
                            ->maxdepth(1)
                            ->in($prefix);


print "**************************************************************************\n";
print "This script helps count includes used in a YAML file\n";
print "**************************************************************************\n";

print $log_file  "**************************************************************************\n";
print $log_file  "This script helps count includes used in a YAML file                      \n";
print $log_file  "Run the script at $curent_time                                            \n";                                   
print $log_file  "**************************************************************************\n";

foreach my $module (@modules) {
  print $log_file "+ CHECKING MODULE $module\n";
  my @yaml = File::Find::Rule->file()
                              ->name( '*.yaml' )
                              ->in("$module");

  foreach my $file (@yaml) {
    my ($tsname, $tsdir, $tsext) = fileparse($file, qr/\.[^.]*/);
    open FILE, $file || die "Could not open $file: $!";
    my @contents = <FILE>;

    my @found = grep(/\!include/, @contents);

    print $log_file "   - [WARNING] Found $file: " . ($#found + 1) . " includes\n" if $all || ($#found + 1) >= $threshold;
  }
}
close $log_file;

