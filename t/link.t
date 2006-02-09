#!perl 
use Test::More 'no_plan';
use HTML::TreeBuilder;

BEGIN { use_ok("HTML::Widget::Factory"); }

my $widget = HTML::Widget::Factory->new;

isa_ok($widget, 'HTML::Widget::Factory');

can_ok($widget, 'link');

{ # make a super-simple input field
  my $html = $widget->link({
    href => 'http://rjbs.manxome.org/',
    text => "ricardo's home page",
  });

  my $tree = HTML::TreeBuilder->new_from_content($html);
  
  my ($link) = $tree->look_down(_tag => 'a');

  isa_ok($link, 'HTML::Element');

  is(
    $link->attr('href'),
    'http://rjbs.manxome.org/',
    "got correct hyper-ref",
  );

  is(
    $link->as_text,
    "ricardo's home page",
    "got correct text",
  );
}
