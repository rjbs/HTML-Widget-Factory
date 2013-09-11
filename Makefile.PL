use ExtUtils::MakeMaker;

require 5.006;

WriteMakefile(
  'NAME'         => 'HTML::Widget::Factory',
  'AUTHOR'       => 'Ricardo Signes',
  'PREREQ_PM'    => {
    'HTML::Element'      => 0.00,
    'List::MoreUtils'    => 0.00,
    'Module::Pluggable'  => 2.9,
    'MRO::Compat'        => 0.000,  # unknown
    'Package::Generator' => 0.100,
    'Package::Reaper'    => 0.100,
    'Sub::Install'       => 0.000,  # unknown
  }
);
