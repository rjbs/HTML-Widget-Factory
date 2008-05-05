
use strict;
use warnings;

package HTML::Widget::Plugin::Image;

use HTML::Widget::Plugin ();
BEGIN { our @ISA = 'HTML::Widget::Plugin' };

=head1 NAME

HTML::Widget::Plugin::Image - an image object

=head1 VERSION

version 0.066

=cut

our $VERSION = '0.066';

=head1 DESCRIPTION

This plugin provides a basic image widget.

=cut

use Carp ();
use HTML::Element;

=head1 METHODS

=head2 C< provided_widgets >

This plugin provides the following widgets: image

=cut

sub provided_widgets { qw(image) }

=head2 C< image >

This method returns a basic image element.

In addition to the generic L<HTML::Widget::Plugin> attributes, the following
are valid arguments:

=over

=item src

This is the source href for the image.  "href" is a synonym for src.  If no
href is supplied, an exception is thrown.

=item alt

This is the alt text for the image.

=back

=cut

sub _attribute_args { qw(src alt) }

sub image {
  my ($self, $factory, $arg) = @_;
  
  if ($arg->{attr}{src} and $arg->{href}) {
    Carp::croak "don't provide both href and src for image widget";
  }

  $arg->{attr}{src} = $arg->{href} if not defined $arg->{attr}{src};

  Carp::croak "can't create an image without a src"
    unless defined $arg->{attr}{src};

  my $widget = HTML::Element->new('img');
  $widget->attr($_ => $arg->{attr}{$_}) for keys %{ $arg->{attr} };

  return $widget->as_XML;
}

=head1 AUTHOR

Ricardo SIGNES <C<rjbs @ cpan.org>>

=head1 COPYRIGHT

Copyright (C) 2007, Ricardo SIGNES.  This is free software, released under the
same terms as perl itself.

=cut

1;
