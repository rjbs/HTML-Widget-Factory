use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME                => 'HTML-Widget-Factory',
	AUTHOR              => 'Ricardo SIGNES <rjbs@cpan.org>',
	VERSION_FROM        => 'lib/HTML/Widget/Factory.pm',
	PL_FILES            => {},
	PREREQ_PM => {
		'HTML::Element'      => 0.00,
    'List::MoreUtils'    => 0.00,
    'Module::Pluggable'  => 2.9,
    'Package::Generator' => 0.100,
    'Package::Reaper'    => 0.100,
    'Sub::Install'       => 0.000, # unknown
    'UNIVERSAL::require' => 0.10,
	},
	dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
	clean               => { FILES => 'HTML-Widget-Factory-*' },
  (eval { ExtUtils::MakeMaker->VERSION(6.21) } ? (LICENSE => 'perl') : ()),
);
