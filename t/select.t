#!perl
use Test::More 'no_plan';
use HTML::TreeBuilder;

BEGIN { use_ok("HTML::Widget::Factory"); }

my $widget = HTML::Widget::Factory->new;

isa_ok($widget, 'HTML::Widget::Factory');

can_ok($widget, 'select');

{ # make a super-simple input field
  my $html = $widget->select({
    options => [
      [ minty => 'Peppermint',     ],
      [ perky => 'Fresh and Warm', ],
      [ super => 'Red and Blue',   ],
    ],
    name  => 'flavor',
    value => 'minty',
  });

  my $tree = HTML::TreeBuilder->new_from_content($html);
  
  my ($select) = $tree->look_down(_tag => 'select');

  isa_ok($select, 'HTML::Element');

  is(
    $select->attr('name'),
    'flavor',
    "got correct input name",
  );
}
