#!perl
use strict;
use warnings;

use Test::More tests => 8;

BEGIN { use_ok("HTML::Widget::Factory"); }

use lib 't/lib';
use Test::WidgetFactory;

{ # make a textarea widget
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

{ # make a textarea widget
  my ($html, $tree) = widget(textarea => {
    id    => 'textarea123',
    value => 'This is some big old block of text.  Pretend!',
  });
  
  my ($textarea) = $tree->look_down(_tag => 'textarea');

  isa_ok($textarea, 'HTML::Element');

  is(
    $textarea->attr('id'),
    'textarea123',
    "got correct textarea id",
  );

  is(
    $textarea->attr('name'),
    'textarea123',
    "got correct textarea name, from id",
  );

  is(
    $textarea->as_text,
    'This is some big old block of text.  Pretend!',
    "the textarea has the right content"
  );
}
