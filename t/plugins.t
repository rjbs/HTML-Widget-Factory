#!perl -T
use strict;
use warnings;

use Test::More tests => 3;

use_ok('HTML::Widget::Factory');

my $factory = HTML::Widget::Factory->new;

isa_ok($factory, 'HTML::Widget::Factory');

is_deeply(
  [ sort $factory->plugins ],
  [ qw(
      HTML::Widget::Plugin::Button
      HTML::Widget::Plugin::Checkbox
      HTML::Widget::Plugin::Image
      HTML::Widget::Plugin::Input
      HTML::Widget::Plugin::Link
      HTML::Widget::Plugin::Multiselect
      HTML::Widget::Plugin::Password
      HTML::Widget::Plugin::Radio
      HTML::Widget::Plugin::Select
      HTML::Widget::Plugin::Submit
      HTML::Widget::Plugin::Textarea
  ) ],
  "got all the standard plugins",
);
