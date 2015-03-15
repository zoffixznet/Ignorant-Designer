
package IgnorantDesigner::Model::Users;

use Moo;
use Digest::MD5 qw/md5_hex/;

has admin_pass_hash => (
    is => 'ro',
);

has admin_user_hash => (
    is => 'ro',
);

sub check {
    my ( $self, $user, $pass ) = @_;

    return 1
        if md5_hex($user) eq $self->admin_user_hash
            and md5_hex($pass) eq $self->admin_pass_hash;

    return undef;
}

1;

__END__