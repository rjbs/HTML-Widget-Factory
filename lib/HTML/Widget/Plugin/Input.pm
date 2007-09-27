
use strict;
use warnings;

package HTML::Widget::Plugin::Input;

use HTML::Widget::Plugin ();
BEGIN { our @ISA = 'HTML::Widget::Plugin' };

=head1 NAME

HTML::Widget::Plugin::Input - the most basic input widget

=head1 VERSION

version 0.060

=cut

our $VERSION = '0.060';

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

sub _attribute_args { qw(type value size maxlength) }
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

=head1 AUTHOR

Ricardo SIGNES <C<rjbs @ cpan.org>>

=head1 COPYRIGHT

Copyright (C) 2005-2007, Ricardo SIGNES.  This is free software, released under
the same terms as perl itself.

=cut

1;
