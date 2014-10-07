#!/usr/bin/perl 
use strict;
use warnings;

# imports
use Getopt::Std;

# use getopts in the canonical fashion
getopts('dnf:', \%opts);
my $debug_mode = (exists %opts{'d'}) ? 1          : 0;
my $nex_mode   = (exists %opts{'n'}) ? 1          : 0;
my $makefile   = (exists %opts{'f'}) ? %opts{'f'} : 'Makefile';

# TEST
print("$debug_mode, $nex_mode, $makefile");