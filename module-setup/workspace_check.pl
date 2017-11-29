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
print "This script helps detect for registering of new workspaces\n";
print "**************************************************************************\n";

print $log_file  "*********************************************************************************\n";
print $log_file  "This script helps detect for registering of new workspaces                       \n";
print $log_file  "Run the script at $curent_time                                                   \n";                                   
print $log_file  "*********************************************************************************\n";

print $log_file ".... Checking module $module\n";
my $module_descriptor_file = "$prefix/$module/src/main/resources/META-INF/magnolia/$module.xml";
open FILE, $module_descriptor_file || die "Could not open $module_descriptor_file: $!";
my @contents = <FILE>;
my $workspace_count = 0;
foreach my $workspace (grep(/<workspace>/, @contents)) {
  if ($workspace =~ /<workspace>/) {
    $workspacev = trim($');
    $workspacev = substr $workspacev, 0, -12;
    print $log_file "     - [WARNING] Found a new workspace registered - $workspacev --> Please make sure that you put the related content/data into the same workspace \n";
  }
}

close $log_file;
 