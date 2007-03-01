#!perl -T
use strict;
use warnings;

use Test::More tests => 9;

BEGIN { use_ok("HTML::Widget::Factory"); }

my $widget_factory = HTML::Widget::Factory->new;

my $input_factory = HTML::Widget::Factory->new({
  plugins => [ qw(HTML::Widget::Plugin::Input) ],
});

# generic factory

isa_ok($widget_factory, 'HTML::Widget::Factory');

can_ok($widget_factory, 'input');
can_ok($widget_factory, 'hidden');

ok(
  $widget_factory->can('password'),
  "widget factory can do password",
);

# specialized factory

isa_ok($input_factory,  'HTML::Widget::Factory');

can_ok($input_factory, 'input');
can_ok($input_factory, 'hidden');

ok(
  ! $input_factory->can('password'),
  "input-only factory can't do password",
);
