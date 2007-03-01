#!perl -T
use strict;
use warnings;

use Test::More tests => 9;

BEGIN { use_ok("HTML::Widget::Factory"); }

use lib 't/lib';
use Test::WidgetFactory;

{ # make a button
  my ($html, $tree) = widget(button => {
    id   => 'some_button',
    text => "This is right & proper.",
    type => 'submit',
  });

  like($html, qr/right &\S+; proper/, 'html entites escaped in content');
  
  my @buttons = $tree->look_down(_tag => 'button');

  is(@buttons, 1, "we created one button");

  my $button = $buttons[0];

  isa_ok($button, 'HTML::Element');

  is($button->attr('name'), 'some_button', "got correct button name");
}

{ # make a button
  my ($html, $tree) = widget(button => {
    id   => 'misc_button',
    html => '<img src="Foo" />',
    type => 'submit',
  });

  like($html, qr/<img/, 'html entites not escaped with literal_content');

  my @buttons = $tree->look_down(_tag => 'button');

  is(@buttons, 1, "we created one button");

  my $button = $buttons[0];

  isa_ok($button, 'HTML::Element');

  is($button->attr('name'), 'misc_button', "got correct button name");
}
