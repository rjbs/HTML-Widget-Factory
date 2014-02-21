use strict;
use warnings;
package HTML::Widget::Plugin::Input;
use parent 'HTML::Widget::Plugin';
# ABSTRACT: the most basic input widget

=head1 SYNOPSIS

  $widget_factory->input({
    id    => 'flavor',   # if "name" isn't given, id will be used for name
    size  => 25,
    value => $default_flavor,
  });

...or...

  $widget_factory->hidden({
    id    => 'flavor',   # if "name" isn't given, id will be used for name
    value => $default_flavor,
  });

=head1 DESCRIPTION

This plugin provides a basic input widget.

=cut

use HTML::Element;

=head1 METHODS

=head2 C< provided_widgets >

This plugin provides the following widgets: input, hidden

=cut

sub provided_widgets { qw(input hidden) }

=head2 C< input >

This method returns a basic one-line text-entry widget.

In addition to the generic L<HTML::Widget::Plugin> attributes, the following
are valid arguments:

=over

=item value

This is the widget's initial value.

=item type

This is the type of input widget to be created.  You may wish to use a
different plugin, instead.

=back

=cut

sub _attribute_args { qw(disabled type value size maxlength) }
sub _boolean_args   { qw(disabled) }

sub input {
  my ($self, $factory, $arg) = @_;

  $self->build($factory, $arg);
}

=head2 C< hidden >

This method returns a hidden input that is not displayed in the rendered HTML.
Its arguments are the same as those to C<input>.

This method may later be factored out into a plugin.

=cut

sub hidden {
  my ($self, $factory, $arg) = @_;

  $arg->{attr}{type} = 'hidden';

  $self->build($factory, $arg);
}

=head2 C< build >

  my $widget = $class->build($factory, $arg);

This method does the actual construction of the input based on the args
collected by the widget-constructing method.  It is primarily here for
subclasses to exploit.

=cut

sub build {
  my ($self, $factory, $arg) = @_;

  $arg->{attr}{name} = $arg->{attr}{id} unless defined $arg->{attr}{name};

  my $widget = HTML::Element->new('input');

  $widget->attr($_ => $arg->{attr}{$_}) for keys %{ $arg->{attr} };
  return $widget->as_XML;
}

sub rewrite_arg {
  my ($self, $arg, $method) = @_;

  $arg = $self->SUPER::rewrite_arg($arg);

  if ($self->{default_classes} && $method ne 'hidden') {
    my $class = join q{ }, @{ $self->{default_classes} };
    $arg->{attr}{class} = defined $arg->{attr}{class}
      ? "$class $arg->{attr}{class}"
      : $class;
  }

  return $arg;
}


1;
