#!/usr/bin/perl
  use Module::Build;
      Module::Build->new(
  # 'module_name'                   => 'Tk::AbstractCanvas',
    'dist_name'                     => 'Tk-AbstractCanvas',
  # 'dist_version_from'             => 'AbstractCanvas.pm',
    'dist_version'                  => '1.0.56BHMOt',
    'dist_abstract'                 => 'Canvas with abstract center, zoom, and rotate methods',
    'dist_author'                   => 'Pip Stuart <Pip@CPAN.Org>',
  # 'create_readme'                 => '1',
  # 'create_makefile_pl'            => '1',
    'license'                       => 'gpl',
    'script_files'                  => {
    },
    'pm_files'                      => {
      'AbstractCanvas.pm'             => 'lib/Tk/AbstractCanvas.pm',
    },
    'requires'                      => {
      'Tk::Canvas'                    => '0',
      'Tk::Derived'                   => '0',
      'Tk::AbstractCanvas'            => '0',
      'Tk'                            => '0',
    },
  )->create_build_script();