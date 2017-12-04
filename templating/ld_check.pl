#!/usr/bin/perl

use Getopt::Std;
use File::Basename;
use Text::Trim qw(trim);
use POSIX qw/strftime/;
use Time::Piece (); 
use File::Find::Rule;

$curent_time = localtime;

getopts('vp:d:');

my $verbose = true;
my $vomit = $opt_V;
my $prefix = $opt_p;

open my $log_file, ">>", "../logs/log_ld_check_$curent_time.txt" or die "Can't open 'log.txt'\n";

my @modules = File::Find::Rule->directory()
                            ->maxdepth(1)
                            ->in($prefix);

print "**************************************************************************\n";
print "This script helps detect various light development best practises\n";
print "**************************************************************************\n";

print $log_file  "**************************************************************************\n";
print $log_file  "This script helps detect various light development best practises         \n";
print $log_file  "Run the script at $curent_time                                            \n";                                   
print $log_file  "**************************************************************************\n";

# Checking label under dialog
foreach my $module (@modules) {
  print $log_file "+ CHECKING MODULE $module\n";
  my @dialogs = File::Find::Rule->file()
                              ->name( '*.yaml' )
                              ->in("$module/dialogs");

  foreach my $file (@dialogs) {
    my ($fname, $dir, $ext) = fileparse($file, qr/\.[^.]*/);
    print $log_file "    - Found dialog: file\n";
    open FILE, $file || die "Could not open $file: $!";
    my @contents = <FILE>;

    foreach my $label (grep(/label:/, @contents)) {
      my $labelv;
      if ($label =~ /label:/) {
        $labelv = trim($');
        print $log_file "      -  Found label: $labelv\n";
      }

      if ($labelv =~ /[a-zA-Z\.]+\.[a-zA-Z]+/) {
        print $log_file "         - Found a i18n key: $labelv\n";
      } elsif ($labelv eq "") {
        print $log_file "         - Found an empty value\n";
      } else {
        print $log_file "         - found a hardcoded text label: $labelv\n";
      }
    }
  }

  my @templates = File::Find::Rule->file()
                              ->name( '*.yaml' )
                              ->in("$module/templates");

  # Checking title under templates
  foreach my $file (@templates) {
    my ($name, $dir, $ext) = fileparse($file, qr/\.[^.]*/);
    print $log_file "    - Found template: $file\n";
    open FILE, $file || die "Could not open $file: $!";
    my @contents = <FILE>;

    foreach my $title (grep(/title:/, @contents)) {
      my $titlev;
      if ($title =~ /title:/) {
        $titlev = trim($');
        print $log_file "      -  Found title: $titlev\n";
      }

      if ($labelv =~ /[a-zA-Z\.]+\.[a-zA-Z]+/) {
        print $log_file "         - Found a i18n key: $titlev\n";
      } elsif ($titlev eq "") {
        print $log_file "         - Found an empty value\n";
      } else {
        print $log_file "         - found a hardcoded text title: $titlev\n";
      }
    }
  }

}
close $log_file;
