use strict;
use warnings;
package HTML::Widget::Plugin::Textarea;
use parent 'HTML::Widget::Plugin';

# ABSTRACT: a widget for a large text entry box

=head1 SYNOPSIS

  $widget_factory->textarea({
    id    => 'elem-id', # also used as control name, if no name given
    value => $big_hunk_of_text,
  });

=head1 DESCRIPTION

This plugin provides a text-entry area widget.

The C<default_classes> attribute may be used to add a default class to every
produced input.  This class cannot be overridden.

  my $plugin = HTML::Widget::Factory::Input->new({
    default_classes => [ qw(foo bar) ],
  });

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

sub rewrite_arg {
  my ($self, $arg) = @_;

  $arg = $self->SUPER::rewrite_arg($arg);

  if ($self->{default_classes}) {
    my $class = join q{ }, @{ $self->{default_classes} };
    $arg->{attr}{class} = defined $arg->{attr}{class}
      ? "$class $arg->{attr}{class}"
      : $class;
  }

  return $arg;
}

1;
