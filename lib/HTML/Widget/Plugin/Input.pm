
use strict;
use warnings;

package HTML::Widget::Plugin::Input;
use base qw(HTML::Widget::Plugin);

sub provided_widgets { qw(input) }

sub input {
  my ($self, $arg) = @_;

  my $widget = HTML::Element->new('input');

  my %attr;
  for (qw(value name)) {
    $widget->attr($_ => $arg->{$_}) if exists $arg->{$_};
  }

  return $widget->as_HTML;
}

1;
