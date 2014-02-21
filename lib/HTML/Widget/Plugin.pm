use strict;
use warnings;
package HTML::Widget::Plugin;
# ABSTRACT: base class for HTML widgets

use Carp ();
use List::MoreUtils qw(uniq);
use MRO::Compat;
use Scalar::Util qw(reftype);
use Sub::Install;

=head1 DESCRIPTION

This class provides a simple way to write plugins for HTML::Widget::Factory.

=head1 METHODS

=head2 new

  my $plugin = Plugin->new( \%arg );

The default plugin constructor is really simple.  It requires that the argument
is either a hashref or not given.

=cut

sub new {
  my ($class, $arg) = @_;
  $arg = {} unless defined $arg;

  Carp::confess("illegal argument to $class->new: $arg")
    unless ref $arg and reftype $arg eq 'HASH';

  my @attribute_args;
  for (@{ mro::get_linear_isa($class) }) {
    next unless $_->can('_attribute_args');
    push @attribute_args, $_->_attribute_args(@_);
  }
  @attribute_args = uniq @attribute_args;

  my @boolean_args;
  for ($class, @{ mro::get_linear_isa($class) }) {
    next unless $_->can('_boolean_args');
    push @boolean_args, $_->_boolean_args(@_);
  }
  @boolean_args = uniq @boolean_args;

  bless {
    %$arg,
    _attribute_args => \@attribute_args,
    _boolean_args   => \@boolean_args,
  }, $class;
}

=head2 rewrite_arg

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
  my ($self) = shift;
  return @{ $self->{_attribute_args} };
}

sub _attribute_args { qw(id name class tabindex) }

=head2 C< boolean_args >

This method returns a list of argument names, the values of which should be
treated as booleans.

The default implementation climbs the plugin's inheritance tree, calling
C<_boolean_args> and pushing all the results onto a list from which unique
results are then returned.

=cut

sub boolean_args {
  my ($self) = shift;
  return @{ $self->{_boolean_args} };
}

sub _boolean_args { () }

=head2 C< provided_widgets >

This method should be implemented by any plugin.  It returns a list of method
names which a factor should delegate to this plugin.

=cut

sub provided_widgets {
  Carp::croak
    "something called abstract provided_widgets in HTML::Widget::Plugin";
}

1;
