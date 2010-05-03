use strict;
use warnings;

package HTML::Widget::Plugin::Radio;

use HTML::Widget::Plugin ();
BEGIN { our @ISA = 'HTML::Widget::Plugin' };

our $VERSION = '0.080';

=head1 NAME

HTML::Widget::Plugin::Radio - a widget for sets of radio buttons

=head1 SYNOPSIS

  $widget_factory->radio({
    name    => 'radio',
    value   => 'value_1',
    options => [
      [ value_1 => "Description 1" ],
      [ value_2 => "Description 2" ],
      [ value_2 => "Description 2", 'optional-elem-id' ],
    ],
  });

This will emit roughly:

  <input type='radio' name='radio' value='value_1' id='radio-value_1'
  checked='checked'></input>
  <label for='radio-value_1'>Description 2</label>

  <input type='radio' name='radio' value='value_2' id='radio-value_2'></input>
  <label for='radio-value_2'>Description 2</label>

  <input type='radio' name='radio' value='value_3'
  id='optional-elem-id'></input>
  <label for='optional-elem-id'>Description 2</label>

=head1 DESCRIPTION

This plugin provides a radio button-set widget

=cut

use HTML::Element;

=head1 METHODS

=head2 C< provided_widgets >

This plugin provides the following widgets: radio

=cut

sub provided_widgets { qw(radio) }

=head2 C< radio >

This method returns a set of radio buttons.

In addition to the generic L<HTML::Widget::Plugin> attributes, the following
are valid arguments:

=over

=item disabled

If true, this option indicates that the select widget can't be changed by the
user.

=item ignore_invalid

If this is given and true, an invalid value is ignored instead of throwing an
exception.

=item options

This option must be a reference to an array of allowed values, each of which
will get its own radio button.

=item value

If this argument is given, the option with this value will be pre-selected in
the widget's initial state.

An exception will be thrown if more or less than one of the provided options
has this value.

=back

=cut

sub _attribute_args { qw(disabled) }
sub _boolean_args   { qw(disabled) }

sub radio {
  my ($self, $factory, $arg) = @_;

  my @widgets;

  $self->validate_value($arg->{value}, $arg->{options})
    unless $arg->{ignore_invalid};

  if (my $id_attr = delete $arg->{attr}{id}) {
    Carp::cluck "id may not be used as a widget-level attribute for radio";
    $arg->{attr}{name} = $id_attr if not defined $arg->{attr}{name};
  }

  for my $option (@{ $arg->{options} }) {
    my ($value, $text, $id) = (ref $option) ? (@$option) : (($option) x 2);

    my $widget = HTML::Element->new('input', type => 'radio');
    $widget->attr($_ => $arg->{attr}{$_}) for keys %{ $arg->{attr} };

    $id = "$arg->{attr}{name}-$value"
      if ! defined $id and defined $arg->{attr}{name};

    $widget->attr(id => $id) if defined $id;

    $widget->attr(value => $value);

    $widget->attr(checked => 'checked')
      if defined $arg->{value} and $arg->{value} eq $value;

    push @widgets, $widget;
    push @widgets, (! $arg->{parts} and defined $id)
      ? HTML::Element->new_from_lol([ label => $text => { for => $id } ])
      : HTML::Element->new('~literal', text => $text);
  }

  # XXX document
  return @widgets if wantarray and $arg->{parts};

  return join q{}, map { $_->as_XML } @widgets;
}

=head2 C< validate_value >

This method checks whether the given value option is valid.  See C<L</radio>>
for an explanation of its default rules.

=cut

sub validate_value {
  my ($class, $value, $options) = @_;

  my @options = map { ref $_ ? $_->[0] : $_ } @$options;

  if (defined $value) {
    my $matches = grep { $value eq $_ } @options;

    if (not $matches) {
      Carp::croak "provided value '$value' not in given options: "
                . join(q{ }, map { "'$_'" } @options);
    } elsif ($matches > 1) {
      Carp::croak "provided value '$value' matches more than one option";
    }
  }
}

=head1 AUTHOR

Ricardo SIGNES <C<rjbs @ cpan.org>>

=head1 COPYRIGHT

Copyright (C) 2005-2007, Ricardo SIGNES.  This is free software, released under
the same terms as perl itself.

=cut

1;
