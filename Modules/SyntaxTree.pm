#-------------------------------------------------------------------------------
# MODULE: Makefile syntax tree functions
#-------------------------------------------------------------------------------
package Modules::SyntaxTree;
use strict;
use warnings;

our $VERSION = '0.0.1';
use base 'Exporter';

our @EXPORT = qw(
    new_root_node
    root_node_add_macro
    root_node_add_target
    new_macro_node
    find_macro
    new_evalmacro_node
    new_target_node
    target_node_add_stmt 
  );

sub new_root_node ()
{
  my %node;
  
  $node{'macros'}  = ();
  $node{'targets'} = ();

  return \%node;
}

sub root_node_add_macro ($$)
{
  my $node = shift;
  push(@{$node->{'macros'}}, shift);
}

sub root_node_add_target ($$)
{
  my $node = shift;
  push(@{$node->{'targets'}}, shift);
}

sub new_macro_node ($$)
{
  my %node;
  $node{'key'}   = shift;
  $node{'value'} = shift;
  return \%node;
}

# search for macro in the root node when one is needed
sub find_macro ($$)
{
  my $node     = shift;
  my $needle   = shift;
  my @haystack = @{$node->{'macros'}};
  my $foundval = undef;

  for my $macro (@haystack) {
    my $comp = $macro->{'key'};
    if ($comp eq $needle) {
      $foundval = $comp;
      last;
    }
  }

  defined($foundval) or die("MACRO \"$needle\" NOT FOUND");
  return $foundval;
}

# evaluate a macro's value immediately
sub new_evalmacro_node ($$)
{
  my %node;
  my $key    = shift;
  my $rawval = shift;

  # ex) ALL:= ${basename ${filter %.tex %.mm, ${shell ls -t}}}
  # pull apart the value
  system($rawval) == 0
    or die ("$rawval failed: $?");
  #
  # my $val = find_macro($root_node, );

  %node = new_macro_node($key, shift);
  return \%node;
}

sub new_target_node ($$)
{
  my %node;
  $node{'output'} = shift;
  $node{'deps'}   = shift;
  $node{'stmts'}  = ();
  return \%node;
}

sub target_node_add_stmt ($$)
{
  my $node = shift;
  push(@{$node->{'stmts'}}, shift);
}

1;