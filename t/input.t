#!perl -T
use Test::More 'no_plan';
use HTML::TreeBuilder;

BEGIN { use_ok("HTML::Widget::Factory"); }

my $widget = HTML::Widget::Factory->new;

isa_ok($widget, 'HTML::Widget::Factory');

can_ok($widget, 'input');
can_ok($widget, 'hidden');

{ # make a super-simple input field
  my $html = $widget->input({
    name  => 'flavor',
    value => 'minty',
    class => 'orange',
  });

  my $tree = HTML::TreeBuilder->new_from_content($html);
  
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
  my $html = $widget->hidden({
    name  => 'secret',
    value => '123-432-345-654',
  });

  my $tree = HTML::TreeBuilder->new_from_content($html);
  
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
