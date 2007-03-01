#!perl -T
use strict;
use warnings;

use Test::More tests => 5;

BEGIN { use_ok("HTML::Widget::Factory"); }

use lib 't/lib';
use Test::WidgetFactory;

{ # make a super-simple image
  my ($html, $tree) = widget(image => {
    href => 'http://www.example.com/foo.jpg',
    alt  => "photo of a foo",
  });

  my ($image) = $tree->look_down(_tag => 'img');

  isa_ok($image, 'HTML::Element');

  is(
    $image->attr('src'),
    'http://www.example.com/foo.jpg',
    "got correct image source",
  );

  is($image->as_text, q{}, "got correct text version (nothing)");

  is($image->attr('alt'), 'photo of a foo', "and got non-empty alt text");
}
