#!perl -T
use strict;
use warnings;

use Test::More tests => 9;

BEGIN { use_ok("HTML::Widget::Factory"); }

use lib 't/lib';
use Test::WidgetFactory;

{ # make a super-simple link
  my ($html, $tree) = widget(link => {
    href => 'http://rjbs.manxome.org/',
    text => "ricardo's home page",
  });

  my ($link) = $tree->look_down(_tag => 'a');

  isa_ok($link, 'HTML::Element');

  is(
    $link->attr('href'),
    'http://rjbs.manxome.org/',
    "got correct hyper-ref",
  );

  is(
    $link->as_text,
    "ricardo's home page",
    "got correct text",
  );
}

{ # make a link with html inside
  my ($html, $tree) = widget(link => {
    href => 'http://rjbs.manxome.org/',
    html => "<img src='/jpg.jpg'>",
  });
  
  my ($link) = $tree->look_down(_tag => 'a');

  isa_ok($link, 'HTML::Element');

  is(
    $link->attr('href'),
    'http://rjbs.manxome.org/',
    "got correct hyper-ref",
  );

  like(
    $link->as_text,
    qr/\A\s*\z/,
    "no visible text inside A element",
  );

  my ($img) = $link->look_down(_tag => 'img');

  ok($img, "there is an IMG inside this A element");

  isa_ok($img, 'HTML::Element');
}
