
use strict;
use warnings;

package HTML::Widget::Plugin::Input;
use base qw(HTML::Widget::Plugin);

=head1 NAME

HTML::Widget::Plugin::Input - the most basic input widget

=head1 VERSION

version 0.01

 $Id$

=cut

our $VERSION = '0.01';

=head1 DESCRIPTION

This plugin provides a basic input widget.

=cut

use HTML::Element;

=head1 METHODS

=head2 C< provided_widgets >

This plugin provides the following widgets: input

=cut

sub provided_widgets { qw(input) }

=head2 C< input >

This method returns a select-from-list widget.

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

sub _attribute_args { qw(type value) }
sub _boolean_args   { qw(disabled) }

sub input {
  my $self    = shift;
  my $factory = shift;
  my $arg     = $self->rewrite_arg(shift);

  $self->build($factory, $arg);
}

sub build {
  my ($self, $factory, $arg) = @_;

  my $widget = HTML::Element->new('input');

  $widget->attr($_ => $arg->{attr}{$_}) for keys %{ $arg->{attr} };
  return $widget->as_HTML;
}

=head1 AUTHOR

Ricardo SIGNES <C<rjbs @ cpan.org>>

=head1 COPYRIGHT

Copyright (C) 2005, Ricardo SIGNES.  This is free software, released under the
same terms as perl itself.

=cut

1;
