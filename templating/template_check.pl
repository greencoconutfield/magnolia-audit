#!/usr/bin/perl

use Getopt::Std;
use File::Basename;
use Text::Trim qw(trim);
use POSIX qw/strftime/;
use Time::Piece (); 
use File::Find::Rule;

$curent_time = localtime;


getopts('vp:d:');

my $verbose = $opt_v;
# path prefix template script
my $prefix = $opt_p;
# path prefix for dialog definition
my $dialogpath = $opt_d;

open my $log_file, ">>", "../logs/log_template_check_$curent_time.txt" or die "Can't open 'log.txt'\n";


# my @yaml = glob "$prefix/templates/*.yaml";

my @modules = File::Find::Rule->directory()
                            ->maxdepth(1)
                            ->in($prefix);

print "**************************************************************************\n";
print "This script helps detect the name of templates & definitions              \n";
print "**************************************************************************\n";

print $log_file  "**************************************************************************\n";
print $log_file  "This script helps detect the name of templates & definitions              \n";
print $log_file  "Run the script at $curent_time                                             \n";                                   
print $log_file  "**************************************************************************\n";

foreach my $module (@modules) {
  print $log_file "+ CHECKING MODULE $module\n";
  my @yaml = File::Find::Rule->file()
                              ->name( '*.yaml' )
                              ->in("$module/templates");

  foreach my $file (@yaml) {
    open FILE, $file || die "Could not open $file: $!";
    my @contents = <FILE>;

    my ($tscript) = grep(/templateScript:/, @contents);
    my $tscriptv;
    if ($tscript =~ /templateScript:/) {
      $tscriptv = trim($');
    }
    my ($tsname, $tsdir, $tsext) = fileparse($tscriptv, qr/\.[^.]*/);

    my ($dialog) = grep(/dialog:/, @contents);
    my $dialogv, $dialogp;
    if ($dialog =~/dialog:/) {
      $dialogv = trim($');
      my ($dprefix, $dpath) = split(/:/, trim($'));
      $dialogp = "$dialogpath$dpath.yaml";
    }

    my ($fname, $fdir, $fext) = fileparse($file, qr/\.[^.]*/);
    print $log_file "    - Found template: $fname\n";
    print $log_file "      -  At: $fdir\n";
    print $log_file "      - [ISSUE] Template definition name $fname ($file) does not match template script name $tsname ($tscriptv)\n" if ($fname ne $tsname);
    print $log_file "      - [ISSUE] Template script $tscriptv does not exist in template definition $file!\n" unless -e "$prefix$tscriptv";
    print $log_file "      - [ISSUE] Dialog $dialogp does not exist in template definition $file\n" unless -e $dialogp;

  }
}

  close $log_file;
