#!perl 
use Test::More tests => 6;
use HTML::TreeBuilder;

BEGIN { use_ok("HTML::Widget::Factory"); }

my $widget = HTML::Widget::Factory->new;

isa_ok($widget, 'HTML::Widget::Factory');

can_ok($widget, 'textarea');

{ # make a password-entry widget
  my $html = $widget->textarea({
    name  => 'big_ol',
    value => 'This is some big old block of text.  Pretend!',
  });

  my $tree = HTML::TreeBuilder->new_from_content($html);
  
  my ($textarea) = $tree->look_down(_tag => 'textarea');

  isa_ok($textarea, 'HTML::Element');

  is(
    $textarea->attr('name'),
    'big_ol',
    "got correct textarea name",
  );

  is(
    $textarea->as_text,
    'This is some big old block of text.  Pretend!',
    "the textarea has the right content"
  );
}
