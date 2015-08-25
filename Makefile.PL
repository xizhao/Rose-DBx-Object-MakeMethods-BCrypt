use ExtUtils::MakeMaker;

WriteMakefile(
  NAME          => "Rose::DBx::Object::MakeMethods::BCrypt",
  AUTHOR        => 'Logan Bell <logie@cpan.org>',
  VERSION_FROM  => "lib/Rose/DBx/Object/MakeMethods/BCrypt.pm",
  LICENSE       => "perl_5",
  TEST_REQUIRES => {
    "Test::Deep"        => 0,
    "Test::Exception"   => 0,
    "Test::More"        => 0,
    "File::FindLib"     => 0,
  },
  PREREQ_PM     => {
    "Rose::DB"                          => 0,
    "Rose::DB::Object"                  => 0,
    "Authen::Passphrase::BlowfishCrypt" => 0,
    "Sub::Exporter"                     => 0,
    "Rose::DBx::TestDB" => 0,
  }
);

