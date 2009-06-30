use inc::Module::Install;
all_from 'lib/HTML/Widget/Factory.pm';

requires 'HTML::Element'      => 0.00;
requires 'List::MoreUtils'    => 0.00;
requires 'Module::Pluggable'  => 2.9;
requires 'Package::Generator' => 0.100;
requires 'Package::Reaper'    => 0.100;
requires 'Sub::Install'       => 0.000; # unknown

auto_manifest;
extra_tests;

WriteAll;
