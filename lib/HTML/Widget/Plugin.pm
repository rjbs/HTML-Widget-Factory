
use strict;
use warnings;

package HTML::Widget::Plugin;

=head1 NAME

HTML::Widget::Plugin - base class for HTML widgets

=head1 VERSION

version 0.01

 $Id$

=cut

our $VERSION = '0.01';

use Carp;
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
  my $arg = { %$given_arg };

  for ($class->attribute_args) {
    $arg->{attr}{$_} = delete $arg->{$_} if exists $arg->{$_};
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
    push @attributes, $_->_attribute_args(@_);
  }

  return @attributes;
}   

sub _attribute_args { qw(name class) };

=head2 C< provided_widgets >

This method should be implemented by any plugin.  It returns a list of method
names which should be imported from the plugin into HTML::Widget::Factory.

=cut

sub provided_widgets {
  croak "something called abstract provided_widgets in HTML::Widget::Plugin";
}

sub import {
  my ($class) = @_;
  my ($target) = caller(0);

  my @widgets = $class->provided_widgets;

  for (@widgets) {
    croak "$target can already perform method '$_'"
      if $target->can($_);
  
    croak "$class claims to provide widget '$_' but has no such method"
      unless $class->can($_);

    no strict 'refs';
    *{$target . '::' . $_} = $class->can($_);
  }
}

1;
