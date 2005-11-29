#!perl
#!perl -T
use Test::More 'no_plan';
use HTML::TreeBuilder;

BEGIN { use_ok("HTML::Widget::Factory"); }

my $widget = HTML::Widget::Factory->new;

isa_ok($widget, 'HTML::Widget::Factory');

can_ok($widget, 'password');

{ # make a password-entry widget
  my $html = $widget->password({
    name  => 'pw',
    value => 'minty',
  });

  my $tree = HTML::TreeBuilder->new_from_content($html);
  
  my ($input) = $tree->look_down(_tag => 'input');

  isa_ok($input, 'HTML::Element');

  is(
    $input->attr('name'),
    'pw',
    "got correct input name",
  );

  is(
    $input->attr('type'),
    'password',
    "it's a password input!",
  );

  is(
    $input->attr('value'),
    q{ }x8,
    "the content has been replaced"
  );
}
