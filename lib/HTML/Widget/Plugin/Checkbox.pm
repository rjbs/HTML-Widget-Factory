
use strict;
use warnings;

package HTML::Widget::Plugin::Checkbox;

use HTML::Widget::Plugin ();
BEGIN { our @ISA = 'HTML::Widget::Plugin' };

=head1 NAME

HTML::Widget::Plugin::Checkbox - it's either [ ] or [x]

=head1 VERSION

version 0.064

=cut

our $VERSION = '0.064';

=head1 DESCRIPTION

This plugin provides a widget for boolean checkbox widgets.

=cut

use HTML::Element;

=head1 METHODS

=head2 C< provided_widgets >

This plugin provides the following widgets: checkbox

=cut

sub provided_widgets { qw(checkbox) }

=head2 C< checkbox >

This method returns a checkbox widget.

In addition to the generic L<HTML::Widget::Plugin> attributes, the following
are valid arguments:

=over

=item checked

This is the widget's initial state.  If true, the checkbox is checked.
Otherwise, it is not.

=item value

This is the value for the checkbox, not to be confused with whether or not it
is checked.

=back

=cut

sub _attribute_args { qw(checked value) }
sub _boolean_args   { qw(checked) }

sub checkbox {
  my ($self, $factory, $arg) = @_;

  $arg->{attr}{type} = 'checkbox';

  $arg->{attr}{name} = $arg->{attr}{id} if not defined $arg->{attr}{name};

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
