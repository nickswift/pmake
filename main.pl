#!/usr/bin/perl 

# imports
use Getopt::Std;

# main vars
my %opts;

my $debug_mode;
my $nex_mode;

# use getopts in the canonical fashion
getopts('dn:', %opts);

print("%opts");
