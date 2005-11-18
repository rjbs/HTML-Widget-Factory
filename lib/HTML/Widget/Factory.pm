
use strict;
use warnings;

package HTML::Widget::Factory;

use Module::Pluggable search_path => [qw(HTML::Widget::Plugin)];
use UNIVERSAL::require;

for (__PACKAGE__->plugins) {
  $_->require;
  $_->import;
}

sub new {
  my ($class) = @_;
  bless {} => $class;
}

1;
