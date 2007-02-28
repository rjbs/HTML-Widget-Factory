
use strict;
use warnings;

package HTML::Widget::Plugin::Button;
use base qw(HTML::Widget::Plugin);

=head1 NAME

HTML::Widget::Plugin::Button - a button for clicking

=head1 VERSION

version 0.001

 $Id$

=cut

our $VERSION = '0.001';

=head1 DESCRIPTION

This plugin provides a basic button widget.

=cut

use HTML::Element;

=head1 METHODS

=head2 C< provided_widgets >

This plugin provides the following widgets: input

=cut

sub provided_widgets { qw(button) }

=head2 C< button >

This method returns simple button element.

In addition to the generic L<HTML::Widget::Plugin> attributes, the following
are valid arguments:

=over

=item content

This is the content of the button element, to be displayed on the button's
face.

=item literal_content

If true, this argument indicates that the given content should not be subject
to escaping.

=item type

This is the type of input button to be created.  Valid types are button,
submit, and reset.  The default is button.

=item value

This is the widget's initial value.

=back

=cut

sub _attribute_args { qw(type value) }
sub _boolean_args   { qw(disabled) }

sub button {
  my ($self, $factory, $arg) = @_;

  $self->build($factory, $arg);
}

=head2 C< build >

  my $widget = $class->build($factory, $arg);

This method does the actual construction of the input based on the args
collected by the widget-constructing method.  It is primarily here for
subclasses to exploit.

=cut

my %TYPES = map { $_ => 1 } qw(button reset submit);
sub __is_valid_type {
  my ($self, $type) = @_;
}

sub build {
  my ($self, $factory, $arg) = @_;

  $arg->{attr}{name} ||= $arg->{attr}{id};
  $arg->{attr}{type} ||= 'button';

  my $widget = HTML::Element->new('button');

  Carp::croak "invalid button type: $arg->{attr}{type}"
    unless $self->__is_valid_type($arg->{attr}{type});

  $widget->attr($_ => $arg->{attr}{$_}) for keys %{ $arg->{attr} };

  my $content = $arg->{content} || 'Button';

  $content = HTML::Element->new('~literal' => text => $content)
    if $arg->{literal_content};

  $widget->push_content($content);

  return $widget->as_XML;
}

=head1 AUTHOR

Ricardo SIGNES <C<rjbs @ cpan.org>>

=head1 COPYRIGHT

Copyright (C) 2007, Ricardo SIGNES.  This is free software, released under the
same terms as perl itself.

=cut

1;
