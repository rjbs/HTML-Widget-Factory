#!perl 
use Test::More tests => 7;
use HTML::TreeBuilder;

BEGIN { use_ok("HTML::Widget::Factory"); }

my $widget = HTML::Widget::Factory->new;

isa_ok($widget, 'HTML::Widget::Factory');

can_ok($widget, 'image');

{ # make a super-simple image
  my $html = $widget->image({
    href => 'http://www.example.com/foo.jpg',
    alt  => "photo of a foo",
  });

  my $tree = HTML::TreeBuilder->new_from_content($html);
  
  my ($image) = $tree->look_down(_tag => 'img');

  isa_ok($image, 'HTML::Element');

  is(
    $image->attr('src'),
    'http://www.example.com/foo.jpg',
    "got correct image source",
  );

  is($image->as_text, q{}, "got correct text version (nothing)");

  is($image->attr('alt'), 'photo of a foo', "and got non-empty alt text");
}
