
use strict;
use warnings;

package HTML::Widget::Plugin::Select;

use HTML::Widget::Plugin ();
BEGIN { our @ISA = 'HTML::Widget::Plugin' };

=head1 NAME

HTML::Widget::Plugin::Select - a widget for selection from a list

=head1 VERSION

version 0.060

=cut

our $VERSION = '0.060';

=head1 DESCRIPTION

This plugin provides a select-from-list widget.

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

=item ignore_invalid

If this is given and true, an invalid value is ignored instead of throwing an
exception.

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

use HTML::Element;

sub _attribute_args { qw(disabled) }
sub _boolean_args   { qw(disabled) }

sub select { ## no critic Builtin
  my ($self, $factory, $arg) = @_;

  $self->build($factory, $arg);
}

=head2 C< build >

 my $widget = $class->build($factory, \%arg)

This method does the actual construction of the widget based on the args set up
in the exported widget-constructing call.  It's here for subclasses to exploit.

=cut

sub build {
  my ($self, $factory, $arg) = @_;
  $arg->{attr}{name} = $arg->{attr}{id} unless $arg->{attr}{name};

  my $widget = HTML::Element->new('select');

  my @options;
  if (ref $arg->{options} eq 'HASH') {
    @options = map { [ $_, $arg->{options}{$_} ] } keys %{ $arg->{options} };
  } else {
    @options = @{ $arg->{options} };
    Carp::croak "undefined value passed to select widget"
      if grep { not(defined $_) or ref $_ and not defined $_->[0] } @options;
  }

  $self->validate_value($arg->{value}, \@options) unless $arg->{ignore_invalid};

  for my $entry (@options) {
    my ($value, $name) = (ref $entry) ? @$entry : ($entry) x 2;
    my $option = $self->make_option($factory, $value, $name, $arg);
    $widget->push_content($option);
  }

  $widget->attr($_ => $arg->{attr}{$_}) for keys %{ $arg->{attr} };
  return $widget->as_XML;
}

=head2 C< make_option >

  my $option = $class->make_option($factory, $value, $name, $arg);

This method constructs the HTML::Element option element that will represent one
of the options that may be put into the select box.  This is here for
subclasses to exploit.

=cut

sub make_option {
  my ($self, $factory, $value, $name, $arg) = @_;

  my $option = HTML::Element->new('option', value => $value);
     $option->push_content($name);
     $option->attr(selected => 'selected')
       if defined $arg->{value} and $arg->{value} eq $value;

  return $option;
}

=head2 C< validate_value >

This method checks whether the given value option is valid.  See C<L</select>>
for an explanation of its default rules.

=cut

sub validate_value {
  my ($class, $value, $options) = @_;

  my @options = map { ref $_ ? $_->[0] : $_ } @$options;
  # maybe this should be configurable?
  if ($value) {
    my $matches = grep { $value eq $_ } @options;

    if (not $matches) {
      Carp::croak "provided value '$value' not in given options: "
                . join(q{ }, map { "'$_'" } @options);
    } elsif ($matches > 1) {
      Carp::croak "provided value '$matches' matches more than one option";
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
