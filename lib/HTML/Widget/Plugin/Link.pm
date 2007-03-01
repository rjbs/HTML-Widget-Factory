
use strict;
use warnings;

package HTML::Widget::Plugin::Link;
use base qw(HTML::Widget::Plugin);

=head1 NAME

HTML::Widget::Plugin::Link - a hyperlink

=head1 VERSION

version 0.055

 $Id: /my/icg/widget/trunk/lib/HTML/Widget/Plugin/Input.pm 16769 2005-11-29T17:50:44.157832Z rjbs  $

=cut

our $VERSION = '0.055';

=head1 DESCRIPTION

This plugin provides a basic input widget.

=cut

use Carp ();
use HTML::Element;

=head1 METHODS

=head2 C< provided_widgets >

This plugin provides the following widgets: link

=cut

sub provided_widgets { qw(link) }

=head2 C< link >

This method returns a basic text hyperlink.

In addition to the generic L<HTML::Widget::Plugin> attributes, the following
are valid arguments:

=over

=item href

This is the URI to which the link ... um ... links.  If no href is supplied, an
exception is thrown.

=item text

This is the text of created link.  If no text is supplied, the href is used.

=back

=cut

sub _attribute_args { qw(href class id) }

sub link {
  my ($self, $factory, $arg) = @_;

  $arg->{attr}{name} ||= $arg->{attr}{id};

  Carp::croak "can't create a link without an href"
    unless $arg->{attr}{href};

  Carp::croak "text and html arguments for link widget are mutually exclusive"
    if $arg->{text} and $arg->{html};

  my $widget = HTML::Element->new('a');
  $widget->attr($_ => $arg->{attr}{$_}) for keys %{ $arg->{attr} };

  my $content;
  if ($arg->{html}) {
    $content = ref $arg->{html}
             ? $arg->{html}
             : HTML::Element->new('~literal' => text => $arg->{html});
  } else {
    $content = $arg->{text} || $arg->{attr}{href};
  }

  $widget->push_content($content);

  return $widget->as_XML;
}

=head1 AUTHOR

Ricardo SIGNES <C<rjbs @ cpan.org>>

=head1 COPYRIGHT

Copyright (C) 2005-2007, Ricardo SIGNES.  This is free software, released under
the same terms as perl itself.

=cut

1;
