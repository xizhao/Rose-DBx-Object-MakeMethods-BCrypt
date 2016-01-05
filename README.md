# NAME
         Rose::DBx::Object::MakeMethods::BCrypt

# SYNOPSIS
         package User;
         use strict;
         use base Rose::DB::Object;
         use Rose::DBx::Object::MakeMethods::BCrypt;

         __PACKAGE__->meta->setup(
           db => $db,
           table => 'users',

           columns => [
             id              => { type => 'serial',    not_null => 1 },
             name            => { type => 'varchar',   length   => 255, not_null => 1 },
             password        => { type => 'bcrypt', not_null => 1, },
           ],

           primary_key_columns => ['id'],

           unique_key => ['name'],

         );

         my $user = User->new(name => 'Foobar', password => '123');
         say $user->password # password
         say $user->password_encrypted; # bcrypted string
         say $user->password_is(123) # 1

# DESCRIPTION
    Rose::DBx::Object::MakeMethods::BCrypt is a custom Rose::DB column type
    that handles the bcrypting of a password column.

# CONTRIBUTING
    The code for `Rose-DBx-Object-MakeMethods-BCrypt` is hosted on GitHub
    at:

        https://github.com/MediaMath/Rose-DBx-Object-MakeMethods-BCrypt 

    If you would like to contribute code, documentation, tests, or bugfixes,
    follow these steps:

      1. Fork the project on GitHub.
      2. Clone the fork to your local machine.
      3. Make your changes and push them back up to your GitHub account.
      4. Send a "pull request" with a brief description of your changes, and a link to a JIRA 
      ticket if there is one.
 
    If you are unfamiliar with GitHub, start with their excellent
    documentation here:

      https://help.github.com/articles/fork-a-repo

# COPYRIGHT & LICENSE
    Copyright 2015, Logan Bell / MediaMath

    This program is free software; you can redistribute it and/or modify it
    under the same terms as Perl itself.

