use Getopt::Std;

getopt('vVp:m');

my $verbose = $opt_v;
my $vomit   = $opt_V;
my $prefix  = $opt_p;
my $module  = $opt_m;

$t = `perl hybrid_check.pl -p $prefix -m $module`;
$t = `perl workspace_check.pl -p $prefix -m $module`;
$t = `perl version_handler_check.pl -p $prefix -m $module`;