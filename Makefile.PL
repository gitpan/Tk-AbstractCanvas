use ExtUtils::MakeMaker;
  # See lib/ExtUtils/MakeMaker.pm for details of how to influence
  # # the contents of the Makefile that is written.
  WriteMakefile(
    'NAME'         => 'Tk::AbstractCanvas',
    'VERSION'      => '1.0.56BHMOt',
    'ABSTRACT'     => 'Canvas with abstract center, zoom, and rotate methods',
    'AUTHOR'       => 'Pip Stuart <Pip@CPAN.Org>',
    'EXE_FILES'    => [ 
                      ],
    'PREREQ_PM'    => {
      'Tk::Canvas'                     => 0,
      'Tk::Derived'                    => 0,
      'Tk::AbstractCanvas'             => 0,
      'Tk'                             => 0,
    }, # Module::Name => 1.1,
    'dist'         => { 'COMPRESS' => 'gzip', 'SUFFIX' => 'tgz' },
  );