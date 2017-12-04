#!/usr/bin/perl

use Getopt::Std;
use Text::Trim qw(trim);
use File::Find::Rule;
use POSIX qw/strftime/;
use Time::Piece (); 

$curent_time = localtime;

getopt('vVp:m');

my $verbose = $opt_v;
my $vomit   = $opt_V;
my $prefix  = $opt_p;
my $module  = $opt_m;

open my $log_file, ">>", "../logs/log_hybrid_check$curent_time.txt" or die "Can't open 'log.txt'\n";

print "**************************************************************************\n";
print "This script helps detect whether a module is a hybrid                     \n";
print "**************************************************************************\n";

print $log_file  "*********************************************************************************\n";
print $log_file  "This script helps detect whether a module is a hybrid                            \n";
print $log_file  "Run the script at $curent_time                                                   \n";                                   
print $log_file  "*********************************************************************************\n";

print $log_file "...Checking module $module\n";

my $module_resource = "$prefix/$module/src/main/resources/$module";
if (!is_folder_empty($module_resource)) {
    print $log_file "     - [WARNING] This is a hybrid module --> please consider to move templates,diglogs,resources ... to another light-dev module\n";
}



sub is_folder_empty {
    my $dirname = shift;
    opendir(my $dh, $dirname) or die "Not a directory";
    return scalar(grep { $_ ne "." && $_ ne ".." } readdir($dh)) == 0;
}

close $log_file;
