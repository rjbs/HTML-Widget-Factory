#!perl -T
use strict;
use warnings;

use Test::More tests => 11;

BEGIN { use_ok("HTML::Widget::Factory"); }

use lib 't/lib';
use Test::WidgetFactory;

{ # make a super-simple checkbox widget
  my ($html, $tree) = widget(checkbox => {
    name    => 'flavor',
    checked => 'minty',
  });
  
  my ($checkbox) = $tree->look_down(_tag => 'input');

  isa_ok($checkbox, 'HTML::Element');

  is(
    $checkbox->attr('name'),
    'flavor',
    "got correct checkbox name",
  );

  is(
    $checkbox->attr('type'),
    'checkbox',
    "it's a checkbox!",
  );

  ok(
    $checkbox->attr('checked'),
    "it's checked"
  );

  is(
    $checkbox->attr('value'),
    undef,
    "...but it has no value"
  );
}

{ # use value instead of checked
  my ($html, $tree) = widget(checkbox => {
    name  => 'flavor',
    value => 'minty',
  });
  
  my ($checkbox) = $tree->look_down(_tag => 'input');

  isa_ok($checkbox, 'HTML::Element');

  is(
    $checkbox->attr('name'),
    'flavor',
    "got correct checkbox name",
  );

  is(
    $checkbox->attr('type'),
    'checkbox',
    "it's a checkbox!",
  );

  ok(
    $checkbox->attr('checked'),
    "it's checked"
  );

  is(
    $checkbox->attr('value'),
    undef,
    "...but it has no value"
  );
}
