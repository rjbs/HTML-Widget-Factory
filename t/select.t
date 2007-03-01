#!perl -T
use strict;
use warnings;

use Test::More tests => 23;

BEGIN { use_ok("HTML::Widget::Factory"); }

use lib 't/lib';
use Test::WidgetFactory;

{ # make a select field with AoA options
  my ($html, $tree) = widget(select => {
    options => [
      [ ''    => 'Flavorless',     ],
      [ minty => 'Peppermint',     ],
      [ perky => 'Fresh and Warm', ],
      [ super => 'Red and Blue',   ],
    ],
    name  => 'flavor',
    value => 'minty',
  });
  
  my ($select) = $tree->look_down(_tag => 'select');

  isa_ok($select, 'HTML::Element');

  is(
    $select->attr('name'),
    'flavor',
    "got correct input name",
  );

  my @options = $select->look_down(_tag => 'option');

  is(@options, 4, "there are four options listed");

  my @selected = $select->look_down(selected => 'selected');

  is(@selected, 1, "only one is selected");

  is($selected[0]->attr('value'), 'minty', "the correct one is selected");
}

{ # make a select field with hash options
  my ($html, $tree) = widget(select => {
    options => {
      minty => 'Peppermint',
      perky => 'Fresh and Warm',
      super => 'Red and Blue',
    },
    name  => 'flavor',
    value => 'minty',
  });
  
  my ($select) = $tree->look_down(_tag => 'select');

  isa_ok($select, 'HTML::Element');

  is(
    $select->attr('name'),
    'flavor',
    "got correct input name",
  );

  my @options = $select->look_down(_tag => 'option');

  is(@options, 3, "we created three options");
  
  my @selected = $select->look_down(sub { $_[0]->attr('selected') });

  is(@selected, 1, "only one option is selected");

  is(
    $selected[0]->attr('value'),
    'minty',
    "the selected one is the one we wanted to be selected",
  );
}

{ # make a select field with hash options
  my ($html, $tree) = widget(select => {
    options  => [ qw(red orange yellow green blue indigo violet) ],
    name     => 'color',
    disabled => 'yup',
  });
  
  my ($select) = $tree->look_down(_tag => 'select');

  isa_ok($select, 'HTML::Element');

  is(
    $select->attr('name'),
    'color',
    "got correct input name",
  );

  is(
    $select->attr('disabled'),
    'disabled',
    "disabled set true as a bool",
  );

  my @selected = $select->look_down(sub { $_[0]->attr('selected') });

  is(@selected, 0, "we didn't pre-select anything");
}

{
  # test exception on invalid value
  eval { widget(select => { options => [[1,1]], value => 2 }) };
  like($@, qr/not in given/, "bad values throw exception");

  my $html = eval {
    my ($x) = widget(
      select => { options => [[1,1]], value => 2, ignore_invalid => 1 }
    );
    $x;
  };

  is($@, '', "...unless you pass ignore_invalid");

  like($html, qr/select/, "and we got a html element back!");
}
{
  # test exception on ambiguous value
  eval {
    widget(select => {
      value   => 'foo',
      options => [
        [ foo => "Foo 1" ],
        [ foo => "Foo 2" ],
        [ bar => "Bar 1" ],
      ],
    });
  };
  like($@, qr/more than one/, "ambiguous values throw exception");

  my ($html) = eval {
    widget(select => {
      value   => 'foo',
      options => [
        [ foo => "Foo 1" ],
        [ foo => "Foo 2" ],
        [ bar => "Bar 1" ],
      ],
      ignore_invalid => 1,
    });
  };

  is($@, '', "...unless you pass ignore_invalid");

  like($html, qr/select/, "and we got a html element back!");
}

{
  # test exception on undef value
  eval {
    widget(select => {
      options => [
        [ undef,   'Peppermint',     ],
        [ perky => 'Fresh and Warm', ],
        [ super => 'Red and Blue',   ],
      ],
      name  => 'flavor',
      value => 'minty',
    });
  };

  like($@, qr/undefined value/, "you can't pass undef as a value (AOA)");
}

{
  # test exception on undef value
  eval {
    widget(select => {
      options => [ undef, 1, 2, 3 ],
      name    => 'flavor',
      value   => 'minty',
    });
  };

  like($@, qr/undefined value/, "you can't pass undef as a value (aref)");
}
