
use strict;
use warnings;

package HTML::Widget::Plugin::Select;
use base qw(HTML::Widget::Plugin);

sub provided_widgets { qw(select) }

sub select {
  my ($self, $arg) = @_;

  my $widget = HTML::Element->new('select');

  my %attr;
  for (qw(name)) {
    $widget->attr($_ => $arg->{$_}) if exists $arg->{$_};
  }

  my @options;
  if (ref $arg->{options} eq 'HASH') {
    @options = map { [ $_, $arg->{options}{$_} ] } keys %{ $arg->{options} };
  } else {
    @options = @{ $arg->{options} };
  }

  for my $entry (@options) {
    my ($value, $name) = @$entry;
    my $option = HTML::Element->new('option', value => $value);
       $option->push_content($name);
       $option->attr(selected => 'selected') if $arg->{value} eq $value;
    $widget->push_content($option);
  }

  return $widget->as_HTML;
}

1;
