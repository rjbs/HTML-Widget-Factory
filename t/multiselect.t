#!perl
use Test::More 'no_plan';
use HTML::TreeBuilder;

BEGIN { use_ok("HTML::Widget::Factory"); }

my $widget = HTML::Widget::Factory->new;

isa_ok($widget, 'HTML::Widget::Factory');

can_ok($widget, 'multiselect');

{ # make a select field with hash options
  my $html = $widget->multiselect({
    options => [ qw(portable rechargeable delicious diet) ],
    name    => 'options',
    value   => [ qw(diet portable) ],
    size    => 5,
  });

  my $tree = HTML::TreeBuilder->new_from_content($html);

  my ($select) = $tree->look_down(_tag => 'select');

  isa_ok($select, 'HTML::Element');

  is(
    $select->attr('name'),
    'options',
    "got correct input name",
  );

  my @options = $select->look_down(_tag => 'option');

  is(@options, 4, "we created four options");
  
  my @selected = $select->look_down(sub { $_[0]->attr('selected') });

  is(@selected, 2, "two options are selected");

  is(
    $selected[0]->attr('value'),
    'portable',
    "the first selected element is one we selected",
  );

  is(
    $selected[1]->attr('value'),
    'diet',
    "the second selected element is one we selected",
  );
}
