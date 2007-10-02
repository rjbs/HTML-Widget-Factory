#!perl -T
use strict;
use warnings;

use Test::More tests => 39;

BEGIN { use_ok("HTML::Widget::Factory"); }

use lib 't/lib';
use Test::WidgetFactory;

{ # make a set of radio buttons
  my ($html, $tree) = widget(radio => {
    options => [ qw(hot cold luke_warm) ],
    name    => 'temperature',
    id      => 'foo',
    value   => 'luke_warm',
  });
  
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

  my %id;
  $id{$_}++ for grep { defined } map { $_->attr('id') } @inputs;

  is(keys %id, 0, "the id argument is ignored");
  
  my @selected = $tree->look_down(sub { $_[0]->attr('checked') });

  is(@selected, 1, "only one option is selected");

  is(
    $selected[0]->attr('value'),
    'luke_warm',
    "the selected one is the one we wanted to be selected",
  );
}

{ # make a set of radio buttons, nothing selected
  my ($html, $tree) = widget(radio => {
    options => [ qw(hot cold luke_warm) ],
    name    => 'temperature',
  });
  
  my @inputs = $tree->look_down(_tag => 'input');

  is(@inputs, 3, "we created three options");

  my @selected = $tree->look_down(sub { $_[0]->attr('checked') });

  is(@selected, 0, "nothing selected");
}

{ # make a set of radio buttons
  my ($html, $tree) = widget(radio => {
    options => [
      [ hot  => 'HOT!',  ],
      [ cold => 'COLD!<br />', ],
      [ luke_warm => 'SPIT IT OUT!', ],
    ],
    id      => 'temperature',
    value   => 'luke_warm',
  });

  like($html, qr/SPIT IT OUT!/, "radio label used");
  
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
  
  my @selected = $tree->look_down(sub { $_[0]->attr('checked') });

  is(@selected, 1, "only one option is selected");

  is(
    $selected[0]->attr('value'),
    'luke_warm',
    "the selected one is the one we wanted to be selected",
  );
}

{ # make a set of radio buttons with button ids
  my ($html, $tree) = widget(radio => {
    options => [
      [ hot       => 'HOT!',         'temp1' ],
      [ cold      => 'COLD!<br />',  'temp2' ],
      [ luke_warm => 'SPIT IT OUT!', 'temp3' ],
    ],
    id      => 'temperature',
    value   => 'luke_warm',
  });

  like($html, qr/SPIT IT OUT!/, "radio label used");
  
  my @inputs = $tree->look_down(_tag => 'input');

  is(@inputs, 3, "we created three options");

  my $i = 1;
  for (@inputs) {
    isa_ok($_, 'HTML::Element');

    is(
      $_->attr('name'),
      'temperature',
      "got correct input name",
    );

    is(
      $_->attr('id'),
      'temp' . $i++,
      "got correct input id",
    );
  }
  
  my @selected = $tree->look_down(sub { $_[0]->attr('checked') });

  is(@selected, 1, "only one option is selected");

  is(
    $selected[0]->attr('value'),
    'luke_warm',
    "the selected one is the one we wanted to be selected",
  );
}

{ # exception: invalid value
  my ($html, $tree) = eval {
    widget(radio => {
      options => [
        [ hot  => 'HOT!',  ],
        [ cold => 'COLD!<br />', ],
        [ luke_warm => 'SPIT IT OUT!', ],
      ],
      id      => 'temperature',
      value   => 'tepid',
    });
  };

  like($@, qr/not in given options/, "exception on invalid value");
}

{ # exception: ambiguous value
  my ($html, $tree) = eval {
    widget(radio => {
      options => [
        [ hot => 'HOT!',  ],
        [ hot => 'FIREY!<br />', ],
        [ luke_warm => 'SPIT IT OUT!', ],
      ],
      id      => 'temperature',
      value   => 'hot',
    });
  };

  like($@, qr/more than one/, "exception on ambiguous value");
}

{ # no exception: invalid value 
  my ($html, $tree) = eval {
    widget(radio => {
      options => [
        [ hot       => 'HOT!',  ],
        [ cold      => 'COLD!<br />', ],
        [ luke_warm => 'SPIT IT OUT!', ],
      ],
      name    => 'temperature',
      value   => 'cool',
      ignore_invalid => 1,
    });
  };

  is($@, '', "no exception on invalid value with ignore_invalid");
}
