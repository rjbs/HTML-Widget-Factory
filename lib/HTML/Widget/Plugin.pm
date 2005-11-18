
use strict;
use warnings;

package HTML::Widget::Plugin;
use Carp;

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
