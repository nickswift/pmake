#-------------------------------------------------------------------------------
# MODULE: File manipulation
#-------------------------------------------------------------------------------
package Modules::Files;
use strict;
use warnings;

use Modules::Helpers;

our $VERSION = '0.0.1';
use base 'Exporter';

our @EXPORT = qw(read_to_string);

sub read_to_string ($)
{
  my $file_location = shift;
  debug_print("Reading in: $file_location ... ");
  local $/=undef;

  open MAKEFILE, $file_location 
    or die("Makefile:$file_location could not be opened\n");
  
  my $file_contents = <MAKEFILE>;
  debug_print("DONE");
  close MAKEFILE;
  return $file_contents;
}

1;