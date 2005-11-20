#!perl
use Test::More 'no_plan';
use HTML::TreeBuilder;

BEGIN { use_ok("HTML::Widget::Factory"); }

my $widget = HTML::Widget::Factory->new;

isa_ok($widget, 'HTML::Widget::Factory');

can_ok($widget, 'radio');

{ # make a set of radio buttons
  my $html = $widget->radio({
    options => [ qw(hot cold luke_warm) ],
    name    => 'temperature',
    value   => 'luke_warm',
  });

  warn $html;

  my $tree = HTML::TreeBuilder->new_from_content($html);
  
  my @inputs = $tree->look_down(_tag => 'input');

  is(@inputs, 3, "we created three options");

  for (@inputs) {
    isa_ok($_, 'HTML::Element');

    is(
      $_->attr('name'),
      'temperature',
      "got correct input name",
    );
  }
  
  my @selected = $tree->look_down(sub { $_[0]->attr('on') });

  is(@selected, 1, "only one option is selected");

  is(
    $selected[0]->attr('value'),
    'luke_warm',
    "the selected one is the one we wanted to be selected",
  );
}
