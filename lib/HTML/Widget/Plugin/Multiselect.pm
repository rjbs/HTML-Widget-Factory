use strict;
use warnings;
package HTML::Widget::Plugin::Multiselect;
# ABSTRACT: widget for multiple selections from a list

use parent 'HTML::Widget::Plugin::Select';

=head1 SYNOPSIS

  $widget_factory->multiselect({
    id      => 'multiopts', # if no name attr given, defaults to id value
    size    => 3,
    values  => [ 'value_1', 'value_3' ],
    options => [
      [ value_1 => 'Display Name 1' ],
      [ value_2 => 'Display Name 2' ],
      [ value_3 => 'Display Name 3' ],
    ],
  });

=head1 DESCRIPTION

This plugin provides a select-from-list widget that allows the selection of
multiple elements.

=cut

use HTML::Element;

=head1 METHODS

=head2 C< provided_widgets >

This plugin provides the following widgets: multiselect

=cut

sub provided_widgets { qw(multiselect) }

=head2 C< multiselect >

This method returns a multiple-selection-from-list widget.  Yup.

In addition to the generic L<HTML::Widget::Plugin> attributes and the
L<HTML::Widget::Plugin::Select> attributes, the following are valid arguments:

=over

=item size

This is the number of elements that should be visible in the widget.

=back

=cut

sub _attribute_args { qw(size) }

sub multiselect {
  my ($self, $factory, $arg) = @_;

  $arg->{attr}{name} = $arg->{attr}{id} if not defined $arg->{attr}{name};
  $arg->{attr}{multiple} = 'multiple';

  if ($arg->{values}) {
    $arg->{value} = delete $arg->{values};
  }

  $self->build($factory, $arg);
}

=head2 C< make_option >

This method, subclassed from the standard select widget, expects that C<$value>
will be an array of selected values.

=cut

sub make_option {
  my ($self, $factory, $value, $name, $arg, $opt_arg) = @_;

  my $option = HTML::Element->new('option', value => $value);
     $option->push_content($name);
     $option->attr(disabled => 'disabled') if $opt_arg && $opt_arg->{disabled};
     $option->attr(selected => 'selected')
       if $arg->{value} and grep { $_ eq $value } @{ $arg->{value} };

  return $option;
}

=head2 C< validate_value >

This method checks whether the given value option is valid.  It throws an
exception if the given values are not all in the list of options.

=cut

sub validate_value {
  my ($class, $values, $options) = @_;

  $values = [ $values ] unless ref $values;
  return unless grep { defined } @$values;

  for my $value (@$values) {
    my $matches = grep { $value eq $_ } map { ref $_ ? $_->[0] : $_ } @$options;
    Carp::croak "provided value '$value' not in given options" unless $matches;
  }
}

1;
