use 5.006;
use strict;
use warnings;
package HTML::Widget::Factory;
# ABSTRACT: churn out HTML widgets

use Carp ();
use Module::Load ();
use MRO::Compat;

=head1 SYNOPSIS

 my $factory = HTML::Widget::Factory->new();

 my $html = $factory->select({
   name    => 'flavor',
   options => [
     [ minty => 'Peppermint',     ],
     [ perky => 'Fresh and Warm', ],
     [ super => 'Red and Blue',   ],
   ],
   value   => 'minty',
 });

=head1 DESCRIPTION

HTML::Widget::Factory provides a simple, pluggable system for constructing HTML
form controls.

=cut

=head1 METHODS

Most of the useful methods in an HTML::Widget::Factory object will be provided
by its plugins.  Consult the documentation for the HTML::Widget::Plugin
modules.

=head2 new

  my $factory = HTML::Widget::Factory->new(\%arg);

This constructor returns a new widget factory.

The only valid arguments are C<plugins> and C<extra_plugins>, which provide
arrayrefs of plugins to be used.  If C<plugins> is not given, the default
plugin list is used, which is those plugins that ship with
HTML::Widget::Factory.  The plugins in C<extra_plugins> are loaded in addition
to these.

Plugins may be provided as class names or as objects.

=cut

my %default_instance;
sub _default_instance {
  $default_instance{ $_[0] } ||= $_[0]->new;
}

my $LOADED_DEFAULTS;
my @DEFAULT_PLUGINS = qw(
  HTML::Widget::Plugin::Attrs
  HTML::Widget::Plugin::Button
  HTML::Widget::Plugin::Checkbox
  HTML::Widget::Plugin::Image
  HTML::Widget::Plugin::Input
  HTML::Widget::Plugin::Link
  HTML::Widget::Plugin::Multiselect
  HTML::Widget::Plugin::Password
  HTML::Widget::Plugin::Radio
  HTML::Widget::Plugin::Select
  HTML::Widget::Plugin::Submit
  HTML::Widget::Plugin::Textarea
);

sub _default_plugins {
  $LOADED_DEFAULTS ||= do {
    Module::Load::load("$_") for @DEFAULT_PLUGINS;
    1;
  };
  return @DEFAULT_PLUGINS;
}

sub new {
  my ($self, $arg) = @_;
  $arg ||= {};

  my $class = ref $self || $self;

  # XXX: I think we need to use default plugins when new is invoked on the
  # class, but get the parent object's plugins when it's called on an existing
  # factory. -- rjbs, 2014-02-21
  my @plugins = $arg->{plugins}
              ? @{ $arg->{plugins} }
              : $class->_default_plugins;

  unshift @plugins, @{ $self->{plugins} } if ref $self;

  if ($arg->{plugins} or $arg->{extra_plugins}) {
    push @plugins, @{ $arg->{extra_plugins} } if $arg->{extra_plugins};
  }

  # make sure plugins given as classes become objects
  ref $_ or $_ = $_->new for @plugins;

  my %widget;
  for my $plugin (@plugins) {
    for my $widget ($plugin->provided_widgets) {
      my ($method, $name) = ref $widget ? @$widget : ($widget) x 2;

      Carp::croak "$plugin tried to provide $name, already provided by $widget{$name}{plugin}"
        if $widget{$name};

      Carp::croak
        "$plugin claims to provide widget via ->$method but has no such method"
        unless $plugin->can($method);

      $widget{$name} = { plugin => $plugin, method => $method };
    }
  }

  # for some reason PPI/Perl::Critic think this is multiple statements:
  bless { ## no critic
    plugins => \@plugins,
    widgets => \%widget,
  } => $class;
}

=head2 provides_widget

  if ($factory->provides_widget($name)) { ... }

This method returns true if the given name is a widget provided by the factory.
This, and not C<can> should be used to determine whether a factory can provide
a given widget.

=cut

sub provides_widget {
  my ($self, $name) = @_;
  $self = $self->_default_instance unless ref $self;

  return 1 if $self->{widgets}{$name};

  return;
}

=head2 provided_widgets

  for my $name ($fac->provided_widgets) { ... }

This method returns an unordered list of the names of the widgets provided by
this factory.

=cut

sub provided_widgets {
  my ($self) = @_;
  $self = $self->_default_instance unless ref $self;

  return keys %{ $self->{widgets} };
}

my $ErrorMsg = qq{Can\'t locate object method "%s" via package "%s" }.
               qq{at %s line %d.\n};

sub AUTOLOAD {
  my $widget_name = our $AUTOLOAD;
  $widget_name =~ s/.*:://;

  my ($self, $given_arg) = @_;
  my $class = ref $self || $self;
  my $howto = $self->{widgets}{$widget_name};

  unless ($howto) {
    my ($callpack, $callfile, $callline) = caller;
    die sprintf $ErrorMsg, $widget_name, $class, $callfile, $callline;
  }

  my ($plugin, $method) = @$howto{qw(plugin method)};
  my $arg = $plugin->rewrite_arg($given_arg, $method);

  return $plugin->$method($self, $arg);
}

sub can {
  my ($self, $method) = @_;

  return sub { $self->$method(@_) }
    if ref $self and $self->{widgets}{$method};

  return $self->SUPER::can($method);
}

=head2 plugins

This returns a list of the plugins loaded by the factory.

=cut

sub plugins { @{ $_[0]->{plugins} } }

=head1 TODO

=over

=item * fixed_args for args that are fixed, like (type => 'checkbox')

=item * a simple way to say "only include this output if you haven't before"

This will make it easy to do JavaScript inclusions: if you've already made a
calendar (or whatever) widget, don't bother including this hunk of JS, for
example.

=item * giving the constructor a data store

Create a factory that has a CGI.pm object and let it default values to the
param that matches the passed name.

=item * include id attribute where needed

=item * optional labels (before or after control, or possibly return a list)

=back

=head1 SEE ALSO

=over

=item L<HTML::Widget::Plugin>

=item L<HTML::Widget::Plugin::Input>

=item L<HTML::Widget::Plugin::Submit>

=item L<HTML::Widget::Plugin::Link>

=item L<HTML::Widget::Plugin::Image>

=item L<HTML::Widget::Plugin::Password>

=item L<HTML::Widget::Plugin::Select>

=item L<HTML::Widget::Plugin::Multiselect>

=item L<HTML::Widget::Plugin::Checkbox>

=item L<HTML::Widget::Plugin::Radio>

=item L<HTML::Widget::Plugin::Button>

=item L<HTML::Widget::Plugin::Textarea>

=item L<HTML::Element>

=back

=cut

1;
