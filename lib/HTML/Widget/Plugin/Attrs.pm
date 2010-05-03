use strict;
use warnings;

package HTML::Widget::Plugin::Attrs;

use HTML::Widget::Plugin ();
BEGIN { our @ISA = 'HTML::Widget::Plugin' };

our $VERSION = '0.080';

=head1 NAME

HTML::Widget::Plugin::Attrs - an HTML attribute string

=head1 DESCRIPTION

This plugin produces HTML attribute strings.

=cut

use HTML::Element;

=head1 METHODS

=head2 C< provided_widgets >

This plugin provides the following widgets: attrs

=cut

sub provided_widgets { qw(attrs) }

=head2 C< attrs >

This method returns HTML attribute strings, so:

  $factory->attrs({
    size => 10,
    name => q(Michael "Five-Toes" O'Gambini),
  });

will produce something like:

  size="10" name="Michael &quot;Five-Toes&quot;"

None of the standard argument rewriting applies.  These are the valid
arguments:

=over

=item -tag

This may be the name of an HTML element.  If given, it will be used to look up
what attributes are boolean.

=item -bool

This may be an arrayref of attribute names to treat as boolean arguments.

=back

All attributes not beginning with a dash will be treated as attributes for the
attribute string.  Boolean attributes will always have the attribute name as
the value if true, and will be omitted if false.

If both C<-tag> and C<-bool> are given, they are unioned.

=cut

# Note that we're totally replacing the standard args rewriting!  This is not
# going to act quite like existing widget plugins! -- rjbs, 2008-05-05
# ALL unless they are boolean args.
sub rewrite_arg { return $_[1] }

sub attrs {
  my ($self, $factor, $arg) = @_;

  my $attr = {};

  my %bool;
  $bool{lc $_} = 1 for @{ $arg->{-bool} || [] };
  
  require HTML::Tagset;
  if ($arg->{-tag} and my $entry = $HTML::Tagset::boolean_attr{$arg->{-tag}}) {
    $bool{lc $_} = 1 for (ref $entry ? keys %$entry : $entry);
  }

  my $str = '';
  for my $key (sort grep { $_ !~ /^-/ and defined $arg->{$_} } keys %$arg) {
    my $is_bool = $bool{ lc $key };
    next if $is_bool and not $arg->{$key};

    $str .= HTML::Entities::encode_entities($key)
         .  '="'
         . ($is_bool ? HTML::Entities::encode_entities($key)
                     : HTML::Entities::encode_entities($arg->{$key}))
         .  '" ';
  }

  # Remove the trailing space that we're sure to have -- rjbs, 2008-05-05
  substr $str, -1, 1, '' if length $str;

  return $str;
}

=head1 AUTHOR

Ricardo SIGNES <C<rjbs @ cpan.org>>

=head1 COPYRIGHT

Copyright (C) 2008, Ricardo SIGNES.  This is free software, released under the
same terms as perl itself.

=cut

1;
