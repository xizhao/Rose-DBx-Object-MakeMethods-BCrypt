use strict;
use warnings;
package Rose::DBx::Object::MakeMethods::BCrypt;

use Rose::DB::Object::Metadata;
use Authen::Passphrase::BlowfishCrypt;
use Encode qw(encode);

use Rose::DBx::Object::Metadata::Column::BCrypt;
Rose::DB::Object::Metadata->column_type_class(
    bcrypt => 'Rose::DBx::Object::Metadata::Column::BCrypt'
);

our $VERSION = '0.01';

use Rose::Object::MakeMethods;
# old school yo
our @ISA = qw(Rose::Object::MakeMethods);

use Rose::DB::Object::Constants
  qw(STATE_LOADING STATE_SAVING MODIFIED_COLUMNS MODIFIED_NP_COLUMNS SET_COLUMNS STATE_IN_DB);

sub bcrypt {
  my($class, $name, $args) = @_;
  my $looks_like_bcrypt = qr /^\$2[aby]\$\d{2}\$/;

  my $key = $args->{'hash_key'} || $name;
  my $column_name = $args->{'column'} ? $args->{'column'}->name : $name;

  my $encrypted = $name . '_encrypted';
  my $cmp       = $name . '_is';

  my $default = $args->{'default'};

  my $mod_columns_key = ($args->{'column'} ? $args->{'column'}->nonpersistent : 0) ?
    MODIFIED_NP_COLUMNS : MODIFIED_COLUMNS;

  my %methods;

  # name is most like "password"
  $methods{$name} = sub {
    my($self) = shift;
    if(@_) {
      #no idea why this is needed - rosedb mystery
      $self->{$mod_columns_key}{$column_name} = 1 unless($self->{STATE_LOADING()});
      if(defined $_[0]) {
        # bcrypt is coming from db
        if($_[0] =~ $looks_like_bcrypt) {
          $self->{$key} = undef;
          return $self->{$encrypted} = shift;
        # plaintext from user input
        } else {
          $self->{$encrypted} = _encrypt($_[0],$args);
          if ($self->{STATE_LOADING()}) { # if loading we want to convert to bcrypt and clear it
             return $self->{$key} = undef;
          }
          return $self->{$key} = $_[0];
        }
      }
      return $self->{$key};
    }

    # save is called and we're updating db
    # we only want bcrypt going to db
    if($self->{STATE_SAVING()}) {
      return $self->{$encrypted};
    }

    # general accessor return plaintext for new objects only
    return $self->{$key};
  };

  $methods{$encrypted} = sub {
    my($self) = shift;

    if(@_) {
      $self->{$mod_columns_key}{$column_name} = 1 unless($self->{STATE_LOADING()});

      # load out of db
      if(!defined $_[0] || ($_[0] =~ $looks_like_bcrypt)) {
        return $self->{$encrypted} = shift;
      } else {
        $self->{$encrypted} =  _encrypt($_[0], $args);
        $self->{$key} = $_[0];
      }
    }

    return $self->{$encrypted};
  };

  $methods{$cmp} = sub {
    my($self, $check) = @_;

    my $pass = $self->{$key};
    my $crypted = $self->{$encrypted};

    return 0 if not $check;

    if(defined $crypted) {
      if (Authen::Passphrase::BlowfishCrypt->from_crypt($crypted)->match(encode('UTF-8', $check)) ) {
        $self->{$key} = $check;
        return 1;
      }
      return 0;
    }
    return undef;
  };

  return \%methods;
}

sub _encrypt {
  my ($pass, $args) = @_;
  my $cost = exists $args->{cost}    ? $args->{cost}    : 10;
  my $nul  = exists $args->{key_nul} ? $args->{key_nul} : 0;
  my $hash_obj = Authen::Passphrase::BlowfishCrypt->new(
      cost => $cost,
      salt_random => 60,
      passphrase => encode('UTF-8', $pass));

  return $hash_obj->as_crypt;
}

1;

