
use strict;
use warnings;

package HTML::Widget::Plugin::Submit;

use HTML::Widget::Plugin::Input ();
BEGIN { our @ISA = 'HTML::Widget::Plugin::Input' };

=head1 NAME

HTML::Widget::Plugin::Submit - for submit type inputs

=head1 VERSION

version 0.061

=cut

our $VERSION = '0.061';

=head1 DESCRIPTION

This plugin provide a simple submit plugin, which returns an input element of
type submit.

=head1 METHODS

=head2 C< provided_widgets >

This plugin provides the following widgets: input

=cut

sub provided_widgets { qw(submit) }

=head2 C< submit >

This method returns a basic submit input.

In addition to the generic L<HTML::Widget::Plugin> attributes, the following
are valid arguments:

=over

=item value

This is the widget's initial value, which (for submit inputs) is generally used
as the text for the label on its face.

=back

=cut

use HTML::Element;

sub submit {
  my ($self, $factory, $arg) = @_;

  $arg->{attr}{type} = 'submit';

  # I suppose I could carp, here, if the type is altered, but... it's your
  # foot, shoot it if you want. -- rjbs, 2007-02-28]

  $self->build($factory, $arg);
}

=head1 AUTHOR

Ricardo SIGNES <C<rjbs @ cpan.org>>

=head1 COPYRIGHT

Copyright (C) 2007, Ricardo SIGNES.  This is free software, released under the
same terms as perl itself.

=cut

1;
