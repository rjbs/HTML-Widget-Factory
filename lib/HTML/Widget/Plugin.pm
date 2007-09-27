
use strict;
use warnings;

package HTML::Widget::Plugin;

=head1 NAME

HTML::Widget::Plugin - base class for HTML widgets

=head1 VERSION

version 0.060

=cut

our $VERSION = '0.060';

use Carp ();
use Class::ISA;
use List::MoreUtils qw(uniq);

=head1 DESCRIPTION

This class provides a simple way to write plugins for HTML::Widget::Factory.

=head1 METHODS

=head2 C< rewrite_arg >

 $arg = $plugin->rewrite_arg($arg);

This method returns a reference to a hash of arguments, rewriting the given
hash reference to place arguments that are intended to become element
attributes into the C<attr> parameter.

It moves attributes listed in the results of the C<attribute_args> method.

=cut

sub rewrite_arg {
  my ($class, $given_arg) = @_;
  my $arg = { $given_arg ? %$given_arg : () };

  my %bool = map { $_ => 1 } $class->boolean_args;

  for ($class->attribute_args) {
    if (exists $arg->{$_}) {
      $arg->{attr}{$_} = delete $arg->{$_};
      $arg->{attr}{$_} = $arg->{attr}{$_} ? $_ : undef if $bool{$_};
    }
  }

  return $arg;
}

=head2 C< attribute_args >

This method returns a list of argument names, the values of which should be
used as HTML element attributes.

The default implementation climbs the plugin's inheritance tree, calling
C<_attribute_args> and pushing all the results onto a list from which unique
results are then returned.

=cut

sub attribute_args {
  my ($class) = shift;
  my @attributes;

  for ($class, Class::ISA::super_path($class)) {
    next unless $_->can('_attribute_args');
    push @attributes, $_->_attribute_args(@_);
  }

  return uniq @attributes;
}   

sub _attribute_args { qw(id name class) }

=head2 C< boolean_args >

This method returns a list of argument names, the values of which should be
treated as booleans.

The default implementation climbs the plugin's inheritance tree, calling
C<_boolean_args> and pushing all the results onto a list from which unique
results are then returned.

=cut

sub boolean_args {
  my ($class) = shift;
  my @attributes;

  for ($class, Class::ISA::super_path($class)) {
    next unless $_->can('_boolean_args');
    push @attributes, $_->_boolean_args(@_);
  }

  return @attributes;
}

sub _boolean_args { () }

=head2 C< provided_widgets >

This method should be implemented by any plugin.  It returns a list of method
names which should be imported from the plugin into HTML::Widget::Factory.

=cut

sub provided_widgets {
  Carp::croak
    "something called abstract provided_widgets in HTML::Widget::Plugin";
}

sub import {
  my ($class, $arg) = @_;
  $arg ||= {};

  my $target = $arg->{into} ||= caller(0);

  my @widgets = $class->provided_widgets;

  for my $widget (@widgets) {
    my $install_to = $widget;
    ($widget, $install_to) = @$widget if ref $widget;

    Carp::croak "$target can already provide widget '$widget'"
      if $target->can($install_to);
  
    Carp::croak
      "$class claims to provide widget '$widget' but has no such method"
      unless $class->can($widget);

    no strict 'refs';
    *{$target . '::' . $install_to} = sub {
      my ($self, $given_arg) = @_;
      my $arg = $class->rewrite_arg($given_arg);

      $class->$widget($self, $arg);
    }
  }
}

=head1 AUTHOR

Ricardo SIGNES <C<rjbs @ cpan.org>>

=head1 COPYRIGHT

Copyright (C) 2005-2007, Ricardo SIGNES.  This is free software, released under
the same terms as perl itself.

=cut

1;
