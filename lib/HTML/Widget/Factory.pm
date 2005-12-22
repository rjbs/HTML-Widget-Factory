
use strict;
use warnings;

package HTML::Widget::Factory;

=head1 NAME

HTML::Widget::Factory - churn out HTML widgets

=head1 VERSION

version 0.03

 $Id$

=cut

our $VERSION = '0.03';

=head1 SYNOPSIS

 my $widget = HTML::Widget::Factory->new();

 my $html = $widget->select({
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

use Module::Pluggable search_path => [qw(HTML::Widget::Plugin)];
use UNIVERSAL::require;

for (__PACKAGE__->plugins) {
  $_->require or die $@;
  $_->import;
}

=head1 METHODS

Most of the useful methods in an HTML::Widget::Factory object will be installed
there by its plugins.  Consult the documentation for the HTML::Widget::Plugin
modules.

=head2 C< new >

This constructor returns a new widget factory.  It ignores all its arguments.

=cut

sub new {
  my ($class) = @_;
  bless {} => $class;
}

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

=item L<HTML::Widget::Plugin::Link>

=item L<HTML::Widget::Plugin::Password>

=item L<HTML::Widget::Plugin::Select>

=item L<HTML::Widget::Plugin::Multiselect>

=item L<HTML::Widget::Plugin::Checkbox>

=item L<HTML::Widget::Plugin::Radio>

=item L<HTML::Widget::Plugin::Textarea>

=item L<HTML::Element>

=back

=head1 AUTHOR

Ricardo SIGNES <C<rjbs @ cpan.org>>

=head1 COPYRIGHT

Copyright (C) 2005, Ricardo SIGNES.  This is free software, released under the
same terms as perl itself.

=cut

1;
