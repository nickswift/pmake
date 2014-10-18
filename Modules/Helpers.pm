#-------------------------------------------------------------------------------
# MODULE: Helper functions
#-------------------------------------------------------------------------------
package Modules::Helpers;
use strict;
use warnings;

our $VERSION = '0.0.1';
use base 'Exporter';

our @EXPORT = qw(debug_print print_mf_tree);

our $debug;

# set debug mode
sub set_debug ($)
{
  $debug = shift;
}

# print out debug information
sub debug_print ($)
{
  if ($debug) {
    my $msg = shift;
    print("$msg\n");
  }
}

# Debug print -- syntax tree structure
sub print_mf_tree ($)
{
  my $root_node   = shift;
  my @macro_list  = @{$root_node->{'macros'}};
  my @target_list = @{$root_node->{'targets'}};

  print("@macro_list\n");
  print("@target_list\n");
}

1;