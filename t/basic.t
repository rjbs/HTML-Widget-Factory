#!perl -T
use strict;
use warnings;

use Test::More tests => 2;

BEGIN { use_ok("HTML::Widget::Factory"); }

use lib 't/lib';
use Test::WidgetFactory;

{ # make a super-simple input field
  my ($html, $tree) = widget(input => {
    name  => 'flavor',
    value => 'minty',
  });

  like(
    $html,
    qr/input.+flavor/,
    "input looks sort of like what we asked for"
  );
}
