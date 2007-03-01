#!perl -T
use strict;
use warnings;

use Test::More tests => 20;

BEGIN { use_ok("HTML::Widget::Factory"); }

use lib 't/lib';
use Test::WidgetFactory;

{ # make a set of radio buttons
  my ($html, $tree) = widget(radio => {
    options => [ qw(hot cold luke_warm) ],
    name    => 'temperature',
    value   => 'luke_warm',
  });
  
  my @inputs = $tree->look_down(_tag => 'input');

  is(@inputs, 3, "we created three options");

  for (@inputs) {
    isa_ok($_, 'HTML::Element');

    is(
      $_->attr('name'),
      'temperature',
      "got correct input name",
    );
  }
  
  my @selected = $tree->look_down(sub { $_[0]->attr('checked') });

  is(@selected, 1, "only one option is selected");

  is(
    $selected[0]->attr('value'),
    'luke_warm',
    "the selected one is the one we wanted to be selected",
  );
}

{ # make a set of radio buttons
  my ($html, $tree) = widget(radio => {
    options => [
      [ hot  => 'HOT!',  ],
      [ cold => 'COLD!<br />', ],
      [ luke_warm => 'SPIT IT OUT!', ],
    ],
    name    => 'temperature',
    value   => 'luke_warm',
  });

  like($html, qr/SPIT IT OUT!/, "radio label used");
  
  my @inputs = $tree->look_down(_tag => 'input');

  is(@inputs, 3, "we created three options");

  for (@inputs) {
    isa_ok($_, 'HTML::Element');

    is(
      $_->attr('name'),
      'temperature',
      "got correct input name",
    );
  }
  
  my @selected = $tree->look_down(sub { $_[0]->attr('checked') });

  is(@selected, 1, "only one option is selected");

  is(
    $selected[0]->attr('value'),
    'luke_warm',
    "the selected one is the one we wanted to be selected",
  );
}
