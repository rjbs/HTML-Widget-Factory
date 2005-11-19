
use strict;
use warnings;

package HTML::Widget::Plugin::Select;
use base qw(HTML::Widget::Plugin);

=head1 NAME

HTML::Widget::Plugin::Select - a widget for selection from a list

=head1 VERSION

version 0.01

 $Id$

=cut

our $VERSION = '0.01';

=head1 DESCRIPTION

This plugin provides a select-from-list widget.

=cut

use HTML::Element;

=head1 METHODS

=head2 C< provided_widgets >

This plugin provides the following widgets: select

=cut

sub provided_widgets { qw(select) }

=head2 C< select >

This method returns a select-from-list widget.

In addition to the generic L<HTML::Widget::Plugin> attributes, the following
are valid arguments:

=over

=item disabled

If true, this option indicates that the select widget can't be changed by the
user.

=item options

This may be an arrayref of arrayrefs, each containing a value/name pair, or it
may be a hashref of values and names.

Use the array form if you need multiple entries for a single value or if order
is important.

=item value

If this argument is given, the option with this value will be pre-selected in
the widget's initial state.

An exception will be thrown if more or less than one of the provided options
has this value.

=back

=cut

sub _attribute_args { qw(disabled) }
sub _boolean_args   { qw(disabled) }

sub select {
  my $self   = shift;
  my $factor = shift;
  my $arg = $self->rewrite_arg(shift);

  my $widget = HTML::Element->new('select');

  my @options;
  if (ref $arg->{options} eq 'HASH') {
    @options = map { [ $_, $arg->{options}{$_} ] } keys %{ $arg->{options} };
  } else {
    @options = @{ $arg->{options} };
  }

  for my $entry (@options) {
    my ($value, $name) = (ref $entry) ? @$entry : ($entry) x 2;
    my $option = HTML::Element->new('option', value => $value);
       $option->push_content($name);
       $option->attr(selected => 'selected')
         if $arg->{value} and $value and $arg->{value} eq $value;
    $widget->push_content($option);
  }

  $widget->attr($_ => $arg->{attr}{$_}) for keys %{ $arg->{attr} };
  return $widget->as_HTML;
}

=head2 C< validate_value >

This method checks whether the given value option is valid.  See C<L</select>>
for an explanation of its default rules.

=cut

sub validate_value {
  my ($class, $value, $options) = @_;

  # maybe this should be configurable?
  if ($value) {
    my $matches = grep { $value eq $_ } map { ref $_ ? $_->[0] : $_ } @$options;
    Carp::croak "provided value not in given options" unless $matches;
    Carp::croak "provided value matches more than one option" if $matches > 1;
  }
}

=head1 AUTHOR

Ricardo SIGNES <C<rjbs @ cpan.org>>

=head1 COPYRIGHT

Copyright (C) 2005, Ricardo SIGNES.  This is free software, released under the
same terms as perl itself.

=cut

1;
