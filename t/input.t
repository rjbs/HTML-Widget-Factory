#!perl -T
use strict;
use warnings;

use Test::More tests => 9;

BEGIN { use_ok("HTML::Widget::Factory"); }

use lib 't/lib';
use Test::WidgetFactory;

{ # make a super-simple input field
  my ($html, $tree) = widget(input => {
    name  => 'flavor',
    value => 'minty',
    class => 'orange',
  });
  
  my ($input) = $tree->look_down(_tag => 'input');

  isa_ok($input, 'HTML::Element');

  is(
    $input->attr('name'),
    'flavor',
    "got correct input name",
  );

  is(
    $input->attr('value'),
    'minty',
    "got correct form value",
  );

  is(
    $input->attr('class'),
    'orange',
    "class passed through",
  );
}

{ # make a hidden input field
  my ($html, $tree) = widget(hidden => {
    id    => 'secret',
    value => '123-432-345-654',
  });
  
  my ($input) = $tree->look_down(_tag => 'input');

  isa_ok($input, 'HTML::Element');

  is(
    $input->attr('name'),
    'secret',
    "got correct input name",
  );

  is(
    $input->attr('value'),
    '123-432-345-654',
    "got correct form value",
  );

  is(
    $input->attr('type'),
    'hidden',
    'got a hidden input',
  );
}
