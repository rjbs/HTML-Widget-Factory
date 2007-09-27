
use strict;
use warnings;

package HTML::Widget::Plugin::Textarea;

use HTML::Widget::Plugin;
BEGIN { our @ISA = 'HTML::Widget::Plugin' };

=head1 NAME

HTML::Widget::Plugin::Textarea - a widget for a large text entry box

=head1 VERSION

version 0.060

=cut

our $VERSION = '0.060';

=head1 DESCRIPTION

This plugin provides a text-entry area widget.

=head1 METHODS

=head2 C< provided_widgets >

This plugin provides the following widgets: textarea

=cut

sub provided_widgets { qw(textarea) }

=head2 C< textarea >

This method returns a text-entry area widget.

In addition to the generic L<HTML::Widget::Plugin> attributes, the following
are valid arguments:

=over

=item disabled

If true, this option indicates that the widget can't be changed by the user.

=item value

If this argument is given, the widget will be initially populated by its value.

=back

=cut

use HTML::Element;

sub _attribute_args { qw(disabled id) }
sub _boolean_args   { qw(disabled) }

sub textarea {
  my ($self, $factory, $arg) = @_;

  $arg->{attr}{name} = $arg->{attr}{id} if not defined $arg->{attr}{name};

  my $widget = HTML::Element->new('textarea');

  $widget->attr($_ => $arg->{attr}{$_}) for keys %{ $arg->{attr} };

  $widget->push_content($arg->{value});

  return $widget->as_XML;
}

=head1 AUTHOR

Ricardo SIGNES <C<rjbs @ cpan.org>>

=head1 COPYRIGHT

Copyright (C) 2005-2007, Ricardo SIGNES.  This is free software, released under
the same terms as perl itself.

=cut

1;
