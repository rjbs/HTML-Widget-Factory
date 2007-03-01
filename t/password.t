#!perl -T
use strict;
use warnings;

use Test::More tests => 5;

BEGIN { use_ok("HTML::Widget::Factory"); }

use lib 't/lib';
use Test::WidgetFactory;

{ # make a password-entry widget
  my ($html, $tree) = widget(password => {
    name  => 'pw',
    value => 'minty',
  });
  
  my ($input) = $tree->look_down(_tag => 'input');

  isa_ok($input, 'HTML::Element');

  is(
    $input->attr('name'),
    'pw',
    "got correct input name",
  );

  is(
    $input->attr('type'),
    'password',
    "it's a password input!",
  );

  is(
    $input->attr('value'),
    q{ }x8,
    "the content has been replaced"
  );
}
