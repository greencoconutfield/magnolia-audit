#!/usr/bin/perl

use Getopt::Std;
use Text::Trim qw(trim);
use File::Find::Rule;
use POSIX qw/strftime/;
use Time::Piece (); 

$curent_time = localtime;

getopts('vVp:');

my $prefix = $opt_p;


open my $log_file, ">>", "../logs/log_project_check_$curent_time.txt" or die "Can't open 'log.txt'\n";


print "*********************************************************************************\n";
print "This script helps detect basic Magnolia project setup such as pom.xml, naming ...\n";
print "*********************************************************************************\n";

print $log_file  "*********************************************************************************\n";
print $log_file  "This script helps detect basic Magnolia project setup such as pom.xml, naming ...\n";
print $log_file  "Run the script at $curent_time                                                   \n";                                   
print $log_file  "*********************************************************************************\n";

print $log_file "====CHECKING MAVEN DEPENDENCIES==== \n";

chdir $prefix;

my $cmd = "mvn dependency:analyze-only";
if(system($cmd)){
  die print $log_file " - [ISSUE] Failed to build the project ...\n";
}
else {
    print $log_file " - [OK] Successful to build the project ...\n";
}

my @pom = glob "$prefix/*pom.xml";
my $parent_pom_path = "$prefix/pom.xml";

print $log_file "====DECTECTING THE PROJECT STRUCTURE====\n";

my $is_webapp = 0;
my $is_bundle = 0;
my $is_theme = 0;
open FILE, $parent_pom_path || die "Could not open $parent_pom_path: $!";
my @contents = <FILE>;
foreach my $module (grep(/<module>/, @contents)) {
  $modulev = trim($module);
  $modulev = substr $modulev, 8;
  $modulev = substr $modulev, 0, -9;
  if (index($modulev, "webapp") != -1) {
    print $log_file  " - [OK] Project contains a webapp: $modulev \n";
    $is_webapp = 1;
  } 
  if (index($modulev, "bundle") != -1) {
    print $log_file  " - [OK] Project  contains a bundle: $modulev \n";
    $is_bundle = 1;
  } 
  if (index($modulev, "theme") != -1) {
    print $log_file  " - [WARNING] Project  contains a maven theme module: $modulev \n";
    $is_theme = 1;
  } 
}
if ($is_webapp != 1) {
    print $log_file  " - [FALIED] Project does not contain a standard webapp --> Please visit ....\n";
} 
if ($is_bundle !=1) {
    print $log_file  " - [FAILED] Project does not contain a standard bundle --> Please visit ....\n";
} 

if ($is_bundle ==1) {
    print $log_file  " - [WARNING] Please consider to move the module $modulev to light development approach \n";
} 

print $log_file  "====DECTECTING THE PROJECT POM.XML FILES====\n";
my @files = File::Find::Rule->file()
                            ->maxdepth(2)
                            ->name( 'pom.xml' )
                            ->in($prefix);

foreach my $file (@files) {
  print "examining $file\n" if $verbose || $vomit;
  open FILE, $file || die "Could not open $file: $!";
  my @contents = <FILE>;
  foreach my $name (grep(/<name>/, @contents)) {
    $namev = trim($name);
    $namev = substr $namev, 6;
    $namev = substr $namev, 0, -7;
    print $log_file   "...CHECKING ... $namev \n" ;
  }
  foreach my $version (grep(/<version>/, @contents)) {
    $versionv = trim($version);
    print $log_file   "   $versionv \n";
    my $versionv;
    if ($version =~ /<version>/) {
      $versionv = trim($');
      $versionv = substr $versionv, 0, -10;
    }

    if ($versionv =~ /[0-9\.]+\.[0-9]+/) {
      print $log_file   "     - [FALIED] Found label value $versionv that you are hardcoding  $versionv \n";
    }
    else{
      print $log_file   "     - [OK] Found label value $versionv \n" ;
    }
  }
}
