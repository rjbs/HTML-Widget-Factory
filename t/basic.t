#!perl
#!perl -T
use Test::More 'no_plan';

BEGIN { use_ok("HTML::Widget::Factory"); }

my $widget = HTML::Widget::Factory->new;

isa_ok($widget, 'HTML::Widget::Factory');

can_ok($widget, 'input');

{ # make a super-simple input field
  my $input = $widget->input({
    name  => 'flavor',
    value => 'minty',
  });

  like(
    $input,
    qr/input.+flavor/,
    "input looks sort of like what we asked for"
  );
}
