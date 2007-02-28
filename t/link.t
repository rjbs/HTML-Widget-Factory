#!perl 
use Test::More tests => 11;
use HTML::TreeBuilder;

BEGIN { use_ok("HTML::Widget::Factory"); }

my $widget = HTML::Widget::Factory->new;

isa_ok($widget, 'HTML::Widget::Factory');

can_ok($widget, 'link');

{ # make a super-simple link
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

{ # make a link with html inside
  my $html = $widget->link({
    href => 'http://rjbs.manxome.org/',
    html => "<img src='/jpg.jpg'>",
  });

  my $tree = HTML::TreeBuilder->new_from_content($html);
  
  my ($link) = $tree->look_down(_tag => 'a');

  isa_ok($link, 'HTML::Element');

  is(
    $link->attr('href'),
    'http://rjbs.manxome.org/',
    "got correct hyper-ref",
  );

  like(
    $link->as_text,
    qr/\A\s*\z/,
    "no visible text inside A element",
  );

  my ($img) = $link->look_down(_tag => 'img');

  ok($img, "there is an IMG inside this A element");

  isa_ok($img, 'HTML::Element');
}
