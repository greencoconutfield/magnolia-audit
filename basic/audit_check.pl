use Switch;

print "**************************************************************************\n";
print "Thank you for choosing Magnolia! We always hope to support you the best   \n";
print "Welcome to the Magnolia Audit Tool!                                       \n";
print "The tool will help you detect and validate your Magnolia projects         \n";
print "**************************************************************************\n";

my $is_exit = 0;

while($is_exit == 0){
    print "[1] Check for project setup.       \n";
    print "[2] Check for module setup.        \n";
    print "[3] Check for templating setup.    \n";
    print "[4] Check for theme setup.         \n";
    print "[0] Quit.                          \n";
    print "                                   \n";

    print "Please select your option: ";
    my $option = <STDIN>; 
    chomp($option);

    switch ($option) {
        case 1 {
            print "Let check your project setup. \n";
            project_check();
        }
        case 2 {
            print "Let check your module setup. \n";
            module_check();
        }
        case 3 {
            print "Let check your templating setup. \n";
            templating_check();
        }
        case 4 {
            print "Let check your theme setup. \n";
        }
        case 0 {
            print "Exit checking. \n";
            $is_exit = 1;
        }
        else {
            print "Please select the correct option. \n";
        }
    }
}

sub project_check {
    # Input project path
    my $is_project_path_empty = 0;
    my $project_path = "";
    while($is_project_path_empty == 0){
        print "Please enter the path of your Magnolia project: ";
        $project_path = <STDIN>; 
        chomp($project_path);
        $is_project_path_empty = 1;
        if ($project_path eq ""){
            print "Your project path is empty! \n";
            $is_project_path_empty = 0;
        }
    }   
    print "Checking your project ..........! \n";

    $t = `perl ../project-setup/project_check.pl -p $project_path`;

    print "Please get the result at ../logs/...! \n";

}

sub module_check {
    # Input project path
    my $is_project_path_empty = 0;
    my $project_path = "";
    while($is_project_path_empty == 0){
        print "Please enter the path of your Magnolia project: ";
        $project_path = <STDIN>; 
        chomp($project_path);
        $is_project_path_empty = 1;
        if ($project_path eq ""){
            print "Your project path is empty! \n";
            $is_project_path_empty = 0;
        }
    }   
    # Input module name
    my $is_module_name_empty = 0;
    my $module_name = "";
    while($is_module_name_empty == 0){
        print "Please enter the path of your module name: ";
        $module_name = <STDIN>; 
        chomp($module_name);
        $is_module_name_empty = 1;
        if ($module_name eq ""){
            print "Your module name is empty! \n";
            $is_module_name_empty = 0;
        }
    }   

    print "Checking your module ..........! \n";

    $t = `perl ../module-setup/module_check.pl -p $project_path -m $module_name`;

    print "Please get the result at ../logs/...! \n";
}

sub templating_check {
    # Input light-modules path
    my $is_light_modules_path_empty = 0;
    my $light_modules_path = "";
    while($is_light_modules_path_empty == 0){
        print "Please enter the path of your light-modules: ";
        $light_modules_path = <STDIN>; 
        chomp($light_modules_path);
        $is_light_modules_path_empty = 1;
        if ($light_modules_path eq ""){
            print "Your light-modules path is empty! \n";
            $is_light_modules_path_empty = 0;
        }
    }   

    print "Checking your templating ..........! \n";

    $t = `perl ../templating/template_check.pl -p $light_modules_path`;
    $t = `perl ../templating/ld_check.pl -p $light_modules_path`;
    $t = `perl ../templating/inc_check.pl -p $light_modules_path`;

    print "Please get the result at ../logs/...! \n";
}

