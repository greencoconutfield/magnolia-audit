#!/usr/bin/perl

use Getopt::Std;
use Text::Trim qw(trim);
use File::Find::Rule;
use POSIX qw/strftime/;
use Time::Piece (); 

$curent_time = localtime;

getopt('vVp:m');

my $verbose = $opt_v;
my $vomit = $opt_V;
my $prefix = $opt_p;
my $module = $opt_m;

open my $log_file, ">>", "log.txt" or die "Can't open 'log.txt'\n";

print "**************************************************************************\n";
print "This script helps detect whether a module is using version handler        \n";
print "**************************************************************************\n";

print $log_file  "*********************************************************************************\n";
print $log_file  "This script helps detect whether a module is using version handler               \n";
print $log_file  "Run the script at $curent_time                                                   \n";                                   
print $log_file  "*********************************************************************************\n";

print $log_file "....Checking module $module\n";
my $module_descriptor_file = "$prefix/$module/src/main/resources/META-INF/magnolia/$module.xml";
open FILE, $module_descriptor_file || die "Could not open $module_descriptor_file: $!";
my @contents = <FILE>;
  
my ($mvhandler) = grep(/<versionHandler>/, @contents);
my $mvhandlerv;
if ($mvhandler =~ /<versionHandler>/) {
  $mvhandlerv = trim($');
  $mvhandlerv = substr $mvhandlerv, 0, -17;
  print $log_file "     - [OK] Found the module version handler $mvhandlerv \n" ;
}
else {
  print $log_file "     - [FAILED] Do not found the module version handler $versionv \n";
}

close $log_file;