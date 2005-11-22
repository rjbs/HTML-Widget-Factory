use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME                => 'HTML-Widget-Factory',
	AUTHOR              => 'Ricardo SIGNES <rjbs@cpan.org>',
	VERSION_FROM        => 'lib/HTML/Widget/Factory.pm',
	PL_FILES            => {},
	PREREQ_PM => {
		'HTML::Element'    => 0.00,
    'List::MoreUtils'  => 0.00,
	},
#  test => {
#    TESTS => join " ", do {
#      my $w; $w = sub {
#        map { -d $_ ? $w->($_) : /\.t\Z/ ? $_ : () } grep { ! /^\./ } <$_[0]/*>
#      };
#      $w->("t");
#    }
#  },
	dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
	clean               => { FILES => 'HTML-Widget-Factory-*' },
);
