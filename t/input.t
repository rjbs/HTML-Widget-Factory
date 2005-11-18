#!perl
use Test::More 'no_plan';
use HTML::TreeBuilder;

BEGIN { use_ok("HTML::Widget::Factory"); }

my $widget = HTML::Widget::Factory->new;

isa_ok($widget, 'HTML::Widget::Factory');

can_ok($widget, 'input');

{ # make a super-simple input field
  my $input = $widget->input({
    name  => 'flavor',
    value => 'minty',
  });

  my $tree = HTML::TreeBuilder->new_from_content($input);
  
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
}
