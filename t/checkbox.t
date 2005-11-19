#!perl
use Test::More 'no_plan';
use HTML::TreeBuilder;

BEGIN { use_ok("HTML::Widget::Factory"); }

my $widget = HTML::Widget::Factory->new;

isa_ok($widget, 'HTML::Widget::Factory');

can_ok($widget, 'checkbox');

{ # make a super-simple checkbox widget
  my $html = $widget->checkbox({
    name    => 'flavor',
    checked => 'minty',
  });

  my $tree = HTML::TreeBuilder->new_from_content($html);
  
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
