#!perl 
use Test::More tests => 6;
use HTML::TreeBuilder;

BEGIN { use_ok("HTML::Widget::Factory"); }

my $widget = HTML::Widget::Factory->new;

isa_ok($widget, 'HTML::Widget::Factory');

can_ok($widget, 'submit');

{ # make a super-simple submit input
  my $html = $widget->submit;

  my $tree = HTML::TreeBuilder->new_from_content($html);
  
  my ($input) = $tree->look_down(_tag => 'input');

  isa_ok($input, 'HTML::Element');
}

{ # make a super-simple input field
  my $html = $widget->submit({ value => 'Click Me!' });

  my $tree = HTML::TreeBuilder->new_from_content($html);
  
  my ($input) = $tree->look_down(_tag => 'input');

  isa_ok($input, 'HTML::Element');

  is(
    $input->attr('value'),
    'Click Me!',
    "the label (value) is passed along"
  );
}
