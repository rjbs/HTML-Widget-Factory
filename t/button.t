#!perl 
use Test::More tests => 11;
use HTML::TreeBuilder;

BEGIN { use_ok("HTML::Widget::Factory"); }

my $widget = HTML::Widget::Factory->new;

isa_ok($widget, 'HTML::Widget::Factory');

can_ok($widget, 'button');

{ # make a button
  my $html = $widget->button({
    id      => 'some_button',
    content => "This is right & proper.",
    type    => 'submit',
  });

  like($html, qr/right &\S+; proper/, 'html entites escaped in content');

  my $tree = HTML::TreeBuilder->new_from_content($html);
  
  my @buttons = $tree->look_down(_tag => 'button');

  is(@buttons, 1, "we created one button");

  my $button = $buttons[0];

  isa_ok($button, 'HTML::Element');

  is($button->attr('name'), 'some_button', "got correct button name");
}

{ # make a button
  my $html = $widget->button({
    id      => 'misc_button',
    content => '<img src="Foo" />',
    type    => 'submit',
    literal_content => 1,
  });

  like($html, qr/<img/, 'html entites not escaped with literal_content');

  my $tree = HTML::TreeBuilder->new_from_content($html);
  
  my @buttons = $tree->look_down(_tag => 'button');

  is(@buttons, 1, "we created one button");

  my $button = $buttons[0];

  isa_ok($button, 'HTML::Element');

  is($button->attr('name'), 'misc_button', "got correct button name");
}
