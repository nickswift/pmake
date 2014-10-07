#!/usr/bin/perl 

# imports
use Getopt::Std;

# main vars
# my %opts;

my $debug_mode;
my $nex_mode;

# use getopts in the canonical fashion
getopts('dnf:', \%opts);

foreach (sort keys %opts) {
  print("$_ : $opts{$_}\n");
}
