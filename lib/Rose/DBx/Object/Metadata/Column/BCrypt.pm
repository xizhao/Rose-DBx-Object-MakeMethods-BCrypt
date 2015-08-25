use strict; 
use warnings;
package Rose::DBx::Object::Metadata::Column::BCrypt;
use Rose::DB::Object::Metadata::Column;
use Rose::Object::MakeMethods::Generic;

our @ISA = qw(Rose::DB::Object::Metadata::Column);

our $VERSION = '0.01';

__PACKAGE__->add_common_method_maker_argument_names('encrypted_suffix', 'cmp_suffix');

Rose::Object::MakeMethods::Generic->make_methods(
  {
    preserve_existing => 1,
  },
  scalar => [ __PACKAGE__->common_method_maker_argument_names ],
);

foreach my $type (__PACKAGE__->available_method_types) {
  __PACKAGE__->method_maker_class($type => 'Rose::DBx::Object::MakeMethods::BCrypt');
  __PACKAGE__->method_maker_type($type => 'bcrypt');
}

sub type { 'bcrypt' }

1;
