#-------------------------------------------------------------------------------
# MODULE: Makefile functions
#-------------------------------------------------------------------------------
package Modules::Makefiles;
use strict;
use warnings;

use Modules::Helpers;
use Modules::SyntaxTree;

our $VERSION = '0.0.1';
use base 'Exporter';

our @EXPORT = qw(parse);

sub parse ($)
{
  # regex
  debug_print("BUILDING MAKEFILE TREE");

  my $macro_regex       = "[A-z0-9_\$\{\}]+ *= *[A-z0-9_\$\{\}]+";
  my $evalmacro_regex   = "[A-z0-9_\$\{\}]+ *\:= *[A-z0-9_\$\{\}]+";
  my $target_regex      = "[A-z0-9_\$\{\}]+ *\: *[A-z0-9_\$\{\}]*";
  my $target_line_regex = "[\t].*";

  my $root_node = new_root_node();

  # reference to whatever target node is being built (if that's the case)
  my $active_target = undef;
  my $recog_line    = 0;

  # Read makefile line-by-line
  for my $line (split(m/\n/, shift)) {

    if ($line =~ /$target_line_regex/ || $line =~ /$macro_regex/ 
      || $line =~ /$target_regex/) 
    {
      debug_print("READ LINE [ $line ]");
    }

    # allow the active target to hijack the process until further notice
    if (defined($active_target)) {
      if ($line =~ /$target_line_regex/) {
        debug_print("DETECTED: {statement}: $line");
        target_node_add_stmt($active_target, $line);
      } else {
        # no regex match? stop hijacking.
        $active_target = undef;
      }
      continue;
    } 

    # Determine whether this is a macro, evalmacro or target
    if ($line =~ /$macro_regex/) {
      my @macro_strs = split(m/ *= */, $line);
      debug_print("DETECTED: macro {key val}: @macro_strs");
      my $macro_node = new_macro_node(shift(@macro_strs), 
        shift(@macro_strs));

      root_node_add_macro($root_node, $macro_node);
    } elsif ($line =~ /$evalmacro_regex/) {
      my @macro_strs = split(m/ *\:= */, $line);
      debug_print("DETECTED: eval_macro {key val}: @macro_strs");
      my $macro_node = new_macro_node(shift(@macro_strs), 
        shift(@macro_strs));

      root_node_add_macro($root_node, $macro_node);
    } elsif ($line =~ /$target_regex/) {
      # Add new target node -- allow that target to hijack the loop
      my @target_strs = split(m/ *\: */, $line);
      debug_print("DETECTED: target {output deps}: @target_strs");

      my $targ_size   = @target_strs;
      debug_print("TARG SIZE: $targ_size");
      my $targ_out    = shift(@target_strs);
      my $targ_deps   = ($targ_size == 2) ? shift(@target_strs) : '';

      my $target_node = new_target_node($targ_out, $targ_deps);

      root_node_add_target($root_node, $target_node);
    }
  }
  debug_print("DONE BUILDING MAKEFILE TREE");
  # give back the reference
  return $root_node;
}

1;