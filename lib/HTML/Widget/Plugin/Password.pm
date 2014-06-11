use strict;
use warnings;
package HTML::Widget::Plugin::Password;
# ABSTRACT: for SECRET input

use parent 'HTML::Widget::Plugin::Input';

=head1 SYNOPSIS

  $widget_factory->password({
    id    => 'user_secret',
    value => "not visible in html",
  });

=head1 DESCRIPTION

This plugin provides a widget for password-entry inputs.

=cut

use HTML::Element;

=head1 METHODS

=head2 C< provided_widgets >

This plugin provides the following widgets: password

=cut

sub provided_widgets { [ input => 'password' ] }

=head2 C< password >

This method returns a password-entry widget.

In addition to the generic L<HTML::Widget::Plugin> attributes, the following
are valid arguments:

=over

=item value

This is the widget's initial value.  The value is eaten and displayed as a
series of spaces, if the value is defined.

=back

=cut

=head2 C< rewrite_arg >

The password plugin's rewrite_arg replaces any non-empty value with a string of
spaces so that passwords are not inadvertantly sent as plain text.

=cut

sub rewrite_arg {
  my ($self, $arg, @rest) = @_;

  $arg = $self->SUPER::rewrite_arg($arg, @rest);

  $arg->{attr}{type} = "password";

  $arg->{attr}{value} = q{ } x 8
    if defined $arg->{attr}{value} and length $arg->{attr}{value};

  return $arg;
}

1;
