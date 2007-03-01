#!perl -T
use strict;
use warnings;

use Test::More tests => 4;

BEGIN { use_ok("HTML::Widget::Factory"); }

use lib 't/lib';
use Test::WidgetFactory;

{ # make a password-entry widget
  my ($html, $tree) = widget(textarea => {
    name  => 'big_ol',
    value => 'This is some big old block of text.  Pretend!',
  });
  
  my ($textarea) = $tree->look_down(_tag => 'textarea');

  isa_ok($textarea, 'HTML::Element');

  is(
    $textarea->attr('name'),
    'big_ol',
    "got correct textarea name",
  );

  is(
    $textarea->as_text,
    'This is some big old block of text.  Pretend!',
    "the textarea has the right content"
  );
}
